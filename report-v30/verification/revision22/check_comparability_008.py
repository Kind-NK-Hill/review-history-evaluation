"""Check existing elapsed-time definitions without changing report or runtime evidence."""
from pathlib import Path
import csv
import hashlib
import json
import sqlite3

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[3]
INDEX = ROOT / "reports/trajectory_analysis/team_review_v031_trajectory_v3_20260911/combined_revision_v20_20260913/manuscript/evidence/r9_rewrite_evidence/RUN_INDEX.csv"
reconstructed = {r["label"]: r for r in json.loads((OUT / "reconstruction.json").read_text(encoding="utf-8"))["runs"]}
rows = list(csv.DictReader(INDEX.open(encoding="utf-8-sig", newline="")))
checks = []
for row in rows:
    if row["main_panel"] != "True":
        continue
    label = row["arm"] + "-" + row["task_group"]
    dispatches, clocks, sources = {}, [], []
    for item in json.loads(row["root_and_continuation_paths"]):
        path = Path(item.replace("ROOT", str(ROOT), 1)) / "deadline.sqlite3"
        before = hashlib.sha256(path.read_bytes()).hexdigest()
        con = sqlite3.connect(path.as_uri() + "?mode=ro", uri=True)
        con.row_factory = sqlite3.Row
        clocks.extend(dict(r) for r in con.execute("SELECT * FROM clock"))
        for native in con.execute("SELECT * FROM dispatches"):
            native = dict(native)
            old = dispatches.get(native["id"])
            if old is None or (old["closed_epoch"] is None and native["closed_epoch"] is not None):
                dispatches[native["id"]] = native
        con.close()
        after = hashlib.sha256(path.read_bytes()).hexdigest()
        assert before == after, str(path)
        sources.append({"path": str(path), "sha256": before})
    values = list(dispatches.values())
    start = min(r["opened_epoch"] for r in values)
    end = max(r["closed_epoch"] for r in values if r["closed_epoch"] is not None)
    span = end - start
    missing = sum(r["closed_epoch"] is None for r in values)
    stored = float(row["native_root_span_seconds"]) if row["native_root_span_seconds"] else None
    item = {"label": label, "first_dispatch_epoch": start,
            "last_recorded_return_epoch": end, "elapsed_minutes": span / 60,
            "unclosed_dispatch_count": missing,
            "original_span_seconds": stored,
            "original_minus_recomputed_seconds": stored - span if stored is not None else None,
            "clock_start_matches_first_dispatch": all(c["started_epoch"] == start for c in clocks),
            "source_databases": sources}
    if stored is not None:
        assert missing == 0, label
        assert abs(stored - span) < 0.001, label
        assert abs(float(row["first_dispatch_epoch"]) - start) < 0.001, label
        assert abs(float(row["last_role_return_epoch"]) - end) < 0.001, label
    else:
        previous = reconstructed[label]
        assert abs(span - previous["recorded_return_span_seconds"]) < 0.001
        item["missing_containers_precede_last_return"] = previous["all_missing_containers_stopped_before_last_recorded_return"]
        item["estimate_note"] = "Same first-dispatch/last-recorded-return endpoints. Missing return receipts corroborated by container stops; retain estimate marker. No gaps subtracted."
    checks.append(item)
result = {"scope": "Revision 20 selected first-batch runs; original run stage only, later L7 continuation excluded consistently with existing timing table",
          "definition": "Elapsed time from first dispatch to last role return, including inter-call intervals and within-call waits. Standalone post-submission common evaluation excluded.",
          "selected_run_count": len(checks),
          "complete_original_spans_verified": sum(r["original_span_seconds"] is not None for r in checks),
          "reconstructed_estimates": [r["label"] for r in checks if r["original_span_seconds"] is None],
          "all_clock_starts_match_first_dispatch": all(r["clock_start_matches_first_dispatch"] for r in checks),
          "checks": checks}
(OUT / "comparability_008.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps({k: v for k, v in result.items() if k != "checks"}, ensure_ascii=False))
print(json.dumps([{k: r[k] for k in ("label", "elapsed_minutes", "unclosed_dispatch_count")} for r in checks if r["original_span_seconds"] is None], ensure_ascii=False))
