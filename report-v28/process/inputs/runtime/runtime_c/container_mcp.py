"""Container-only MCP bridge with a neutral, auditable help request.

The bridge stores complete raw tool streams. The model receives an explicitly
marked truncation. Every timeout is capped by the immutable root deadline.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
import time
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

VISIBLE_BYTES = 40_000


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--container", required=True)
    parser.add_argument("--docker", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, required=True)
    parser.add_argument("--deadline-epoch", type=float, required=True)
    parser.add_argument("--help-config", type=Path)
    parser.add_argument("--allowed-bind-manifest", type=Path, required=True)
    arguments = parser.parse_args()
    if not arguments.docker.is_absolute():
        raise SystemExit("docker executable must be an absolute trusted path")
    arguments.evidence.mkdir(parents=True, exist_ok=False)
    events = arguments.evidence / "bridge-events.jsonl"
    inspect = subprocess.run(
        [str(arguments.docker), "inspect", arguments.container],
        capture_output=True, check=True, timeout=20,
    )
    container_info = json.loads(inspect.stdout)[0]
    container = container_info["Id"]
    verify_container(container_info, json.loads(arguments.allowed_bind_manifest.read_text(encoding="utf-8")))
    help_command: list[str] | None = None
    if arguments.help_config:
        help_data = json.loads(arguments.help_config.read_text(encoding="utf-8"))
        help_command = help_data.get("command")
        if not isinstance(help_command, list) or not help_command or not all(
            isinstance(item, str) for item in help_command
        ):
            raise SystemExit("help config command must be a non-empty string list")

    def log(event: dict[str, Any]) -> None:
        with events.open("a", encoding="utf-8", newline="\n") as stream:
            event = {"recorded_at_utc": datetime.now(timezone.utc).isoformat(), **event}
            stream.write(json.dumps(event, ensure_ascii=False, separators=(",", ":")) + "\n")
            stream.flush()
            os.fsync(stream.fileno())

    log({
        "event": "startup", "container_id": container,
        "deadline_epoch": arguments.deadline_epoch,
        "help_enabled": help_command is not None,
        "container_inspect_sha256": hashlib.sha256(inspect.stdout).hexdigest(),
    })
    container_tool = {
        "name": "container_exec",
        "description": (
            "Execute a Bash command inside the fixed isolated workspace. This is the only "
            "file, search, build, or shell interface. There is no host filesystem, network, "
            "Docker socket, or access to another run. The root-run deadline cannot be extended."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "command": {"type": "string"},
                "timeout_seconds": {"type": "number", "minimum": 0.1, "maximum": 600},
            },
            "required": ["command"], "additionalProperties": False,
        },
    }
    help_tool = {
        "name": "request_help",
        "description": (
            "Ask a fresh independent Sol-medium session for mathematical or review help. "
            "Both experimental arms receive the same interface. reviewer is read-only; "
            "support_author works in an independent workspace copy and returns a patch for "
            "the caller to inspect and apply. Help consumes the same root-run deadline."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "role": {"type": "string", "enum": [
                    "support_author", "general_reviewer", "math_reviewer"
                ]},
                "prompt": {"type": "string", "minLength": 1, "maxLength": 100000},
            },
            "required": ["role", "prompt"], "additionalProperties": False,
        },
    }

    def remaining(requested: float) -> float:
        left = arguments.deadline_epoch - time.time()
        if left <= 0:
            raise TimeoutError("root-run deadline reached")
        return min(requested, left)

    def kill_container() -> dict[str, Any]:
        killed = subprocess.run(
            [str(arguments.docker), "kill", "--signal", "KILL", container],
            capture_output=True, timeout=20,
        )
        return {
            "exit_code": killed.returncode,
            "stdout_sha256": hashlib.sha256(killed.stdout).hexdigest(),
            "stderr_sha256": hashlib.sha256(killed.stderr).hexdigest(),
        }

    def run_and_capture(command: list[str], timeout: float, kind: str, call_id: str) -> dict[str, Any]:
        started = time.monotonic()
        timed_out = False
        try:
            completed = subprocess.run(command, capture_output=True, timeout=remaining(timeout))
            code, stdout, stderr = completed.returncode, completed.stdout, completed.stderr
            if kind == "container_exec" and code in (124, 137):
                timed_out = True
                log({"event": "command_timeout_status", "call_id": call_id, "scope": "command_process_group", "container_killed": False, "exit_status_ambiguity": True})
        except (subprocess.TimeoutExpired, TimeoutError) as error:
            timed_out = True
            code = 124
            stdout = getattr(error, "stdout", None) or b""
            stderr = getattr(error, "stderr", None) or b""
            log({"event": "timeout_container_kill", "call_id": call_id, "kill": kill_container()})
        raw_dir = arguments.evidence / "raw" / call_id
        raw_dir.mkdir(parents=True, exist_ok=False)
        (raw_dir / "stdout.bin").write_bytes(stdout)
        (raw_dir / "stderr.bin").write_bytes(stderr)
        result = {
            "exit_code": code, "timed_out": timed_out,
            "elapsed_seconds": time.monotonic() - started,
            "stdout": stdout[:VISIBLE_BYTES].decode("utf-8", errors="replace"),
            "stderr": stderr[:VISIBLE_BYTES].decode("utf-8", errors="replace"),
            "stdout_truncated": len(stdout) > VISIBLE_BYTES,
            "stderr_truncated": len(stderr) > VISIBLE_BYTES,
            "raw_stdout": {"bytes": len(stdout), "sha256": hashlib.sha256(stdout).hexdigest()},
            "raw_stderr": {"bytes": len(stderr), "sha256": hashlib.sha256(stderr).hexdigest()},
        }
        log({"event": "tool_result", "kind": kind, "call_id": call_id, **result})
        return result

    def execute(params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        supplied = params.get("arguments")
        supplied = supplied if isinstance(supplied, dict) else {}
        call_id = str(uuid.uuid4())
        log({"event": "tool_request", "kind": name, "call_id": call_id, "arguments": supplied})
        if name == "container_exec":
            if set(supplied) - {"command", "timeout_seconds"} or not isinstance(supplied.get("command"), str):
                raise ValueError("invalid container_exec arguments")
            timeout = float(supplied.get("timeout_seconds", 600))
            if not 0.1 <= timeout <= 600 or len(supplied["command"]) > 100000:
                raise ValueError("container_exec argument out of range")
            command = [
                str(arguments.docker), "exec", "--user", "1001:1001", "--workdir", "/work",
                container, "/usr/bin/timeout", "--signal=TERM", "--kill-after=1", str(timeout), "/bin/bash", "--noprofile", "--norc", "-c", supplied["command"],
            ]
            result = run_and_capture(command, timeout + 5, name, call_id)
        elif name == "request_help":
            if help_command is None:
                raise ValueError("request_help was not configured")
            if set(supplied) != {"role", "prompt"} or supplied.get("role") not in {
                "support_author", "general_reviewer", "math_reviewer"
            } or not isinstance(supplied.get("prompt"), str):
                raise ValueError("invalid request_help arguments")
            request = arguments.evidence / "help-requests" / f"{call_id}.json"
            request.parent.mkdir(parents=True, exist_ok=True)
            request.write_text(
                json.dumps({
                    "call_id": call_id, "parent_container_id": container,
                    "parent_dispatch_id": help_data.get("parent_dispatch_id"),
                    "caller_session_file": help_data.get("caller_session_file"),
                    "arm": help_data.get("arm"), "run_id": help_data.get("run_id"),
                    "task_ids": help_data.get("task_ids", []), **supplied,
                }, ensure_ascii=False),
                encoding="utf-8",
            )
            result = run_and_capture([*help_command, str(request)], float("inf"), name, call_id)
        else:
            raise ValueError("unknown tool")
        return {
            "content": [{"type": "text", "text": json.dumps(result, ensure_ascii=False)}],
            "isError": result["exit_code"] != 0,
        }

    for line in sys.stdin.buffer:
        if not line.strip():
            continue
        request: Any = None
        try:
            request = json.loads(line)
            method = request.get("method")
            if "id" not in request:
                continue
            if method == "initialize":
                result = {
                    "protocolVersion": request.get("params", {}).get("protocolVersion", "2024-11-05"),
                    "capabilities": {"tools": {}},
                    "serverInfo": {"name": "full-workflow-pilot-container", "version": "1.0.0"},
                }
            elif method == "tools/list":
                result = {"tools": [container_tool] + ([help_tool] if help_command else [])}
            elif method == "tools/call":
                result = execute(request.get("params", {}))
            elif method in {"resources/list", "resources/templates/list", "prompts/list"}:
                key = {"resources/list": "resources", "resources/templates/list": "resourceTemplates", "prompts/list": "prompts"}[method]
                result = {key: []}
            elif method == "ping":
                result = {}
            else:
                raise ValueError("unsupported method")
            response = {"jsonrpc": "2.0", "id": request["id"], "result": result}
        except Exception as error:
            response = {
                "jsonrpc": "2.0", "id": request.get("id") if isinstance(request, dict) else None,
                "error": {"code": -32603, "message": str(error)},
            }
        payload = json.dumps(response, ensure_ascii=True, separators=(",", ":")).encode("utf-8") + b"\n"
        sys.stdout.buffer.write(payload)
        sys.stdout.buffer.flush()


def verify_container(info: dict[str, Any], bind_manifest: dict[str, Any]) -> None:
    host = info["HostConfig"]
    mounts = info.get("Mounts", [])
    expected = {(str(Path(row["source"]).resolve()), row["destination"])
                for row in bind_manifest.get("mounts", [])}
    actual_binds = {(_host_source(mount["Source"]), mount["Destination"])
                    for mount in mounts if mount.get("Type") == "bind"}
    allowed = {"/work", "/tmp"} | {destination for _, destination in expected}
    immutable = allowed - {"/work", "/tmp"}
    if not (
        info["State"]["Running"] and host["NetworkMode"] == "none"
        and host["ReadonlyRootfs"] and "ALL" in host["CapDrop"]
        and not host.get("CapAdd") and not host["Privileged"]
        and host["PidMode"] != "host"
        and any(item.startswith("no-new-privileges") for item in host["SecurityOpt"])
        and info["Config"]["User"] == "1000:1000" and host["PidsLimit"] > 0
        and all(mount["Destination"] in allowed for mount in mounts)
        and all(not mount["RW"] for mount in mounts if mount["Destination"] in immutable)
        and actual_binds == expected
    ):
        raise SystemExit("container does not satisfy isolation preconditions")


def _host_source(value: str) -> str:
    prefix = "/run/desktop/mnt/host/"
    if value.startswith(prefix):
        tail = value[len(prefix):]
        drive, _, rest = tail.partition("/")
        value = drive.upper() + ":/" + rest
    return str(Path(value).resolve())


if __name__ == "__main__":
    main()
