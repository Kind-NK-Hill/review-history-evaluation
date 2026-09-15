"""Bounded exploratory statistics for recorded decisions; source files are read-only.

Run from any directory with Python, NumPy and SciPy already installed. Outputs
are restricted to the three sibling edge_statistics result files. This is not
a prospective preregistration, an accuracy study, or a causal repair estimate.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import platform
from collections import Counter, defaultdict
from pathlib import Path

import numpy as np
import scipy
from scipy import stats

HERE = Path(__file__).resolve().parent
SEED = 20260906
BOOTSTRAP_REPLICATES = 20000
LABELS = ("pass", "fail", "inconclusive", "partial")
PLAN = {
    "declared_before_estimation": True,
    "prospectively_preregistered": False,
    "primary": "all_candidate_change_edges",
    "sensitivity": ["both_endpoints_decisive", "high_confidence_edges"],
    "outcome": "A=1 iff recorded_verdict is pass; otherwise 0 for the three explicit non-pass labels only",
    "zero_does_not_mean": "mathematically incorrect, failed semantic examination, or a rejected decision",
    "estimands": ["mean of task-specific mean edge differences", "mean edge difference"],
    "reference_null": "E_task[mean_edge(A_after-A_before)]=0 in a hypothetical independent exchangeable task-generating population with the same selection mechanism",
    "inference_status": "conditional exploratory reference; task independence and transportability are unverified",
    "t_tests": "one two-sided paired t-test on task-level before/after means for each of three declared routes; no edge-level t-test",
    "bootstrap": "uniform task-cluster resampling with replacement; retain all selected task edges, same indices for before/after; percentile 95% intervals",
    "multiplicity": "all three reference p-values reported; no confirmatory family or significance-based selection; intervals are pointwise",
    "additional_descriptions": ["full label transition matrix", "nondecisive endpoint flows", "endpoint reuse", "chain telescoping", "task cluster sizes", "recorded field comparisons and unknown check extent"],
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_jsonl(path: Path) -> list[dict]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def sorted_counts(values) -> dict:
    return dict(sorted(Counter(values).items(), key=lambda x: str(x[0])))


def confidence_description(rows: list[dict]) -> dict:
    """Post-estimation selection diagnostic; no additional tests or intervals."""
    result = {}
    for confidence in ("high", "medium"):
        selected = [r for r in rows if r["original_confidence"] == confidence]
        grouped = defaultdict(list)
        for row in selected:
            grouped[row["task_id"]].append(row["difference"])
        result[confidence] = {
            "edges": len(selected), "tasks": len(grouped),
            "before_pass": sum(r["a_before"] for r in selected),
            "after_pass": sum(r["a_after"] for r in selected),
            "task_equal_difference": float(np.mean([np.mean(v) for v in grouped.values()])),
            "edge_equal_difference": float(np.mean([r["difference"] for r in selected])),
        }
    return result


def structure(rows: list[dict]) -> dict:
    endpoints = Counter(v for r in rows for v in (r["from_review_event_id"], r["to_review_event_id"]))
    outgoing = {r["from_review_event_id"]: r for r in rows}
    incoming = {r["to_review_event_id"]: r for r in rows}
    assert len(outgoing) == len(rows) == len(incoming), "Branching would invalidate the chain diagnostic"
    roots = sorted(set(outgoing) - set(incoming))
    chain_lengths, seen, total_terminal_difference = [], set(), 0
    for root in roots:
        current, edge_count = root, 0
        first = outgoing[root]
        last = first
        while current in outgoing:
            row = outgoing[current]
            assert row["adjacent_transition_id"] not in seen, "Cycle or duplicate edge"
            seen.add(row["adjacent_transition_id"])
            edge_count += 1
            last = row
            current = row["to_review_event_id"]
        chain_lengths.append(edge_count)
        total_terminal_difference += last["a_after"] - first["a_before"]
    assert len(seen) == len(rows), "Graph contains unreachable cycle"
    assert total_terminal_difference == sum(r["difference"] for r in rows)
    return {
        "unique_endpoints": len(endpoints),
        "endpoint_occurrences": 2 * len(rows),
        "endpoint_multiplicity": sorted_counts(endpoints.values()),
        "reused_endpoints": sum(n > 1 for n in endpoints.values()),
        "maximal_chains_in_this_fixed_edge_subset": len(chain_lengths),
        "chain_length_distribution": sorted_counts(chain_lengths),
        "sum_edge_differences_equals_sum_chain_terminal_differences": total_terminal_difference,
        "interpretation": "Shared interior endpoints cancel algebraically. More edges in a chain do not provide that many independent net-improvement observations. These diagnostic chains do not redefine stage-7 episodes.",
    }


def summarize(rows: list[dict], route: str, seed_offset: int) -> dict:
    grouped = defaultdict(list)
    for row in rows:
        grouped[row["task_id"]].append(row)
    task_rows = []
    for task_id, edges in sorted(grouped.items()):
        before = sum(r["a_before"] for r in edges)
        after = sum(r["a_after"] for r in edges)
        task_rows.append({"task_id": task_id, "edges": len(edges), "before_pass": before,
                          "after_pass": after, "before_mean": before / len(edges),
                          "after_mean": after / len(edges), "mean_difference": (after-before) / len(edges)})
    n = len(task_rows)
    sizes = np.array([r["edges"] for r in task_rows], dtype=np.int64)
    before = np.array([r["before_mean"] for r in task_rows])
    after = np.array([r["after_mean"] for r in task_rows])
    differences = after - before
    net = np.array([r["after_pass"] - r["before_pass"] for r in task_rows], dtype=np.int64)
    # Difference of means, mean of differences and weighted task totals must agree.
    assert np.isclose(differences.mean(), np.mean([r["mean_difference"] for r in task_rows]), atol=1e-14)
    assert int(net.sum()) == sum(r["difference"] for r in rows)
    sd = float(differences.std(ddof=1)) if n > 1 else None
    if n < 2 or sd == 0:
        t_result = {"status": "degenerate_no_finite_t_reference", "n_tasks": n, "sd_task_difference": sd}
    else:
        paired = stats.ttest_rel(after, before, alternative="two-sided", nan_policy="raise")
        formula_t = float(differences.mean() / (sd / math.sqrt(n)))
        assert np.isclose(formula_t, paired.statistic, rtol=1e-12)
        ci = paired.confidence_interval(confidence_level=0.95)
        t_result = {"status": "computed_conditional_reference_only", "n_tasks": n, "df": n-1,
                    "statistic": float(paired.statistic), "p_two_sided_unadjusted": float(paired.pvalue),
                    "sd_task_difference": sd, "se_under_independent_task_assumption": sd / math.sqrt(n),
                    "mean_difference_t_ci95": [float(ci.low), float(ci.high)]}
    rng = np.random.default_rng(np.random.SeedSequence([SEED, seed_offset]))
    task_bootstrap, edge_bootstrap = [], []
    for start in range(0, BOOTSTRAP_REPLICATES, 1000):
        m = min(1000, BOOTSTRAP_REPLICATES-start)
        indices = rng.integers(0, n, size=(m, n))
        task_bootstrap.extend(differences[indices].mean(axis=1).tolist())
        edge_bootstrap.extend((net[indices].sum(axis=1) / sizes[indices].sum(axis=1)).tolist())
    def interval(values):
        return [float(v) for v in np.quantile(values, [0.025, 0.975], method="linear")]
    transitions = {a: {b: 0 for b in LABELS} for a in LABELS}
    for row in rows:
        transitions[row["before_label"]][row["after_label"]] += 1
    nondecisive = {"inconclusive", "partial"}
    return {
        "route": route, "edges": len(rows), "tasks": n,
        "before_label_counts": sorted_counts(r["before_label"] for r in rows),
        "after_label_counts": sorted_counts(r["after_label"] for r in rows),
        "transitions": transitions,
        "nondecisive_flows": {
            "edges_with_either_nondecisive_endpoint": sum(r["before_label"] in nondecisive or r["after_label"] in nondecisive for r in rows),
            "before_nondecisive_occurrences": sum(r["before_label"] in nondecisive for r in rows),
            "after_nondecisive_occurrences": sum(r["after_label"] in nondecisive for r in rows),
            "from_nondecisive_to_pass": sum(r["before_label"] in nondecisive and r["after_label"] == "pass" for r in rows),
            "from_pass_to_nondecisive": sum(r["before_label"] == "pass" and r["after_label"] in nondecisive for r in rows),
        },
        "task_equal": {"before_mean": float(before.mean()), "after_mean": float(after.mean()),
                        "mean_difference": float(differences.mean()), "cluster_bootstrap_ci95": interval(task_bootstrap)},
        "edge_equal": {"before_pass": sum(r["a_before"] for r in rows), "after_pass": sum(r["a_after"] for r in rows),
                        "net_pass_difference": int(net.sum()), "mean_difference": float(net.sum() / sizes.sum()),
                        "cluster_bootstrap_ci95": interval(edge_bootstrap)},
        "paired_task_t_reference": t_result,
        "task_difference_diagnostics": {"negative": int((differences < -1e-12).sum()), "zero": int((np.abs(differences) < 1e-12).sum()),
                                        "positive": int((differences > 1e-12).sum()), "minimum": float(differences.min()), "maximum": float(differences.max()),
                                        "task_mean_difference_distribution": sorted_counts(round(float(x), 12) for x in differences),
                                        "exact_t_normality_assumption": "not met literally: bounded discrete task differences; t is a large-task-sample approximation conditional on task independence"},
        "task_cluster_sizes": {"distribution": sorted_counts(sizes.tolist()), "median": float(np.median(sizes)),
                               "maximum": int(sizes.max()), "tasks_with_multiple_edges": int((sizes > 1).sum()),
                               "largest_five_tasks_edge_share": float(np.sort(sizes)[-5:].sum()/sizes.sum())},
        "structure": structure(rows), "task_rows": task_rows,
        "bootstrap_rng": {"seed_sequence_entropy": [SEED, seed_offset], "bit_generator": "PCG64", "replicates": BOOTSTRAP_REPLICATES},
    }


def pct(value: float) -> str:
    return f"{value*100:.2f}"


def ci_text(values: list[float]) -> str:
    return f"[{pct(values[0])}, {pct(values[1])}]"


def render(data: dict, english: bool) -> str:
    routes = data["analyses"]
    primary = routes[0]
    context = data["context_diagnostics"]
    selection = context["confidence_selection_diagnostic"]
    high, medium = selection["high"], selection["medium"]
    title = "Exploratory paired statistics for recorded pass decisions" if english else "记录通过变化的有界配对统计补充"
    language = {"pass": "通过", "fail": "失败", "inconclusive": "无法确定", "partial": "部分"}
    names = ["All candidate-change edges", "Both endpoints pass/fail", "High-confidence edges"] if english else ["全部候选修改边", "两端均为通过／失败", "仅高置信边"]
    lines = [f"# {title}", "", "## Material Passport", "",
             "- Origin Skill: academic-research-suite / experiment-agent",
             "- Origin Mode: run + validate", "- Origin Date: 2026-09-06",
             "- Verification Status: ANALYZED", "- Version Label: edge_statistics_v0_2_0",
             ""]
    if english:
        lines += ["This analysis estimates change in **recorded pass decisions** within the fixed historical candidate-change edge set. It does not estimate mathematical improvement, reviewer accuracy, or the causal benefit of repair. A paired t-statistic is computable once the outcome and task-level pairing are defined; its inferential assumptions remain unverified.", "",
                  "The three routes below were specified before numerical effect estimation in this session. They are exploratory, not a prospective preregistration. All declared estimates and all three two-sided reference tests are reported; no route was chosen by its p-value.", "",
                  "## Outcome, units and estimands", "",
                  "For each observed endpoint, A=1 if the stored verdict is `pass`; A=0 for the explicit stored labels `fail`, `inconclusive`, or `partial`. The zero means only that a pass was not recorded. Unknown or missing labels are never converted to zero: the script stops on an unrecognized label. The four original categories and the nondecisive flows remain separately reported.", "",
                  "For task t with n_t selected edges, d_t = mean_e(A_after,e − A_before,e). The task-equal estimand is mean_t(d_t); the edge-equal estimand is sum_t(n_t d_t) / sum_t(n_t). The former gives each represented task equal weight; the latter gives long observed task histories more weight. Both are exact descriptions of the enumerated historical set. They are not first-to-last task success rates or causal treatment effects.", "",
                  "## All declared results", "",
                  "All changes and interval endpoints are percentage points. Intervals are conditional 95% task-cluster percentile bootstrap references, not uncertainty about the already enumerated historical values.", "",
                  "| Route | Edges / tasks | Task-equal change | Cluster interval | Edge-equal change | Cluster interval |",
                  "|---|---:|---:|---|---:|---|"]
    else:
        lines += ["本补充估计固定历史候选修改边中**记录通过指示的变化**，不估计数学质量改善、审查准确率或修改的因果收益。明确结果变量和任务配对后，可以计算配对 t 统计量；其推断前提仍未经验证。", "",
                  "以下三条路线在本会话计算效应量前声明。它们是探索性分析，不是前瞻预注册。三条路线的估计量及全部三次双侧参考检验都报告，没有按 p 值选择路线。", "",
                  "## 结果变量、单位和估计目标", "",
                  "对每个已观测端点，A=1 表示原记录判决为通过；A=0 仅覆盖原记录明确的失败、无法确定和部分三类。零值只表示没有记录通过。未知或缺失判决不会填零：出现未识别标签时脚本直接报错。原四分类和非决定性结果的转移另行完整保留。", "",
                  "任务 t 在所选口径中有 n_t 条边，d_t=该任务各边的后项 A 减前项 A 的均值。任务等权目标为所有 d_t 的平均；边等权目标为 Σ(n_t d_t)/Σn_t。前者每个已入组任务权重相同，后者让记录边较多的任务权重更大。两者都是已枚举历史集合的确切描述，不是任务从第一次到最后一次的成功率，也不是处理效应。", "",
                  "## 全部事先声明的结果", "",
                  "变化量与区间端点均以百分点表示。区间是以任务整群重采样得到的条件性95%百分位参考区间，不表示已经枚举的历史值存在抽样未知。", "",
                  "| 口径 | 边／任务 | 任务等权变化 | 整群区间 | 边等权变化 | 整群区间 |",
                  "|---|---:|---:|---|---:|---|"]
    for name, route in zip(names, routes):
        lines.append(f"| {name} | {route['edges']} / {route['tasks']} | {pct(route['task_equal']['mean_difference'])} | {ci_text(route['task_equal']['cluster_bootstrap_ci95'])} | {pct(route['edge_equal']['mean_difference'])} | {ci_text(route['edge_equal']['cluster_bootstrap_ci95'])} |")
    lines += ["", "| " + ("Route | Task-level before → after | t (df) | Two-sided p, unadjusted |" if english else "口径 | 任务层前项→后项 | t（自由度） | 双侧 p，未校正 |"), "|---|---:|---:|---:|"]
    for name, route in zip(names, routes):
        t = route["paired_task_t_reference"]
        lines.append(f"| {name} | {pct(route['task_equal']['before_mean'])}% → {pct(route['task_equal']['after_mean'])}% | {t['statistic']:.5f} ({t['df']}) | {t['p_two_sided_unadjusted']:.6g} |")
    ee = primary["edge_equal"]
    st = primary["structure"]
    dx = primary["task_difference_diagnostics"]
    cs = primary["task_cluster_sizes"]
    if english:
        lines += ["", f"The complete edge set has {ee['before_pass']}/465 recorded passes before and {ee['after_pass']}/465 after, a net difference of {ee['net_pass_difference']}. Task differences are negative for {dx['negative']} tasks, zero for {dx['zero']}, and positive for {dx['positive']}; their standard deviation is {primary['paired_task_t_reference']['sd_task_difference']:.6f}. This is not a zero-variance degeneracy, but the differences are bounded and discrete, so an exact normal-theory t distribution is not justified literally.", "",
                  "The two sensitivity routes change the included edges, represented tasks, and target population. Their similarity or difference is not fixed-cohort robustness. Restricting to pass/fail conditions on both observed decisions and can itself select cases. The high-confidence role is inherited from a rule that includes the presence of prior structured findings; it is not an independently validated repair label.", "",
                  f"A descriptive selection check added after the primary estimates shows why this distinction matters: earlier passes occur on {high['before_pass']}/{high['edges']} high-confidence edges but {medium['before_pass']}/{medium['edges']} medium-confidence edges. Medium-confidence edges alone have task-equal change {pct(medium['task_equal_difference'])} percentage points and edge-equal change {pct(medium['edge_equal_difference'])} percentage points. These subgroup descriptions add no t-test or interval. The classification rule does not directly use the verdict, but its prior-findings condition is strongly associated with the earlier-label composition. The larger high-confidence estimate cannot be presented as stronger repair benefit or higher statistical reliability.", "",
                  "## Why not a t-test on 465 pairs?", "",
                  f"There are {st['endpoint_occurrences']} endpoint occurrences but only {st['unique_endpoints']} unique endpoint records; {st['reused_endpoints']} endpoints occur in two edges. The selected graph contains {st['maximal_chains_in_this_fixed_edge_subset']} maximal chains. Along a chain, the sum of successive indicator differences telescopes to the final minus initial indicator. Here the sums agree at {st['sum_edge_differences_equals_sum_chain_terminal_differences']}. Consequently, treating the 465 edges as independent paired observations would ignore direct endpoint reuse and within-task dependence.", "",
                  f"The 250 task aggregates provide the pairing used here. {cs['tasks_with_multiple_edges']} tasks have multiple edges; the median is {cs['median']:.1f}, the maximum is {cs['maximum']}, and the five largest tasks contribute {pct(cs['largest_five_tasks_edge_share'])}% of edges. The task-cluster bootstrap resamples entire task histories, so shared endpoints and all selected edges within a task stay together. This handles the declared within-task grouping but does not establish independence between tasks.", "",
                  f"The 783 endpoint records correspond to {context['unique_candidate_identities']} unique candidate identities; unique event identifiers therefore do not imply distinct candidates or independently executed reviews. Within a chain, dividing its net change by its edge count also dilutes the same terminal change in a longer chain. Some tasks contain multiple disjoint selected chains, so replacing their edge summaries with one earliest-to-latest difference would change the estimand.", "",
                  "For the reference null E(d_t)=0, the statistic is t = mean(d_t)/(sd(d_t)/sqrt(T)), with T−1 reference degrees of freedom. It is computed as a paired t-test of task-specific after and before means, not an independent two-sample t-test. Equal before/after variances are not required for this paired test. Exact Student-t calibration would require independent identically distributed normal differences; the observed bounded discrete differences instead allow, at best, a large-task-sample approximation under independence and suitable exchangeability. No normality-screening test was used to select a preferred analysis. Formula and SciPy implementation: [SciPy paired t-test documentation](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.ttest_rel.html).", "",
                  "The intervals and p-values concern a hypothetical population of exchangeable tasks drawn through the same history and edge-selection mechanism. Actual task independence, representativeness, and transportability to future tasks were not established. The three p-values are unadjusted exploratory references, not three confirmatory discoveries; no familywise significance claim is made. Percentile intervals are pointwise, conditional, and do not correct selection or cross-task dependence. [SciPy bootstrap documentation](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.bootstrap.html) describes the resampling principle; this script implements task-cluster sampling explicitly.", "",
                  "## Complete original-label transition table", "",
                  "Rows are earlier labels and columns later labels. `inconclusive` and `partial` are nondecisive categories here; they are not mathematical truth labels.", ""]
    else:
        lines += ["", f"完整边集前项记录通过 {ee['before_pass']}/465，后项 {ee['after_pass']}/465，净差 {ee['net_pass_difference']}。任务均差为负、零、正的任务分别有 {dx['negative']}、{dx['zero']}、{dx['positive']} 个，任务均差样本标准差为 {primary['paired_task_t_reference']['sd_task_difference']:.6f}。这不是零方差退化，但差值有界且离散，不满足精确正态理论 t 分布的字面前提。", "",
                  "两条敏感性路线均改变了入组边、涉及任务和估计总体；数值接近或不同均不能称为固定任务群的稳健性。只保留通过／失败会条件化于两端已经发生的决定，可能形成选择。高置信角色继承自包含前项存在结构化问题条目这一条件的旧规则，不是独立验证过的真实修改标签。", "",
                  f"主估计后增加的描述性选择检查说明了这一差异：高置信前项通过 {high['before_pass']}/{high['edges']}，中置信前项通过 {medium['before_pass']}/{medium['edges']}。中置信边单独的任务等权变化为 {pct(medium['task_equal_difference'])} 个百分点、边等权变化为 {pct(medium['edge_equal_difference'])} 个百分点。这些分组描述没有新增 t 检验或区间。分类规则未直接读取判决，但前项问题条目条件与前项标签构成紧密相关；不能把较大的高置信估计写成更强修复收益或更高统计可靠性。", "",
                  "## 为什么不直接对465对做 t 检验", "",
                  f"共有 {st['endpoint_occurrences']} 次端点出现，但只有 {st['unique_endpoints']} 个唯一端点记录，其中 {st['reused_endpoints']} 个端点同时用于两条边。所选图构成 {st['maximal_chains_in_this_fixed_edge_subset']} 条最大连续链。一条链内逐边指示差求和时，中间端点代数抵消，只剩末项减首项；本数据两种求和均为 {st['sum_edge_differences_equals_sum_chain_terminal_differences']}。所以把465条边当独立配对观察，会忽略共享端点和任务内依赖。", "",
                  f"本补充以250个任务汇总值配对。其中 {cs['tasks_with_multiple_edges']} 个任务有多条边，边数中位数 {cs['median']:.1f}、最多 {cs['maximum']}，最大的五个任务贡献 {pct(cs['largest_five_tasks_edge_share'])}% 的边。整群重采样保留所抽任务的全部边及共享端点，处理这里声明的任务内分组；它不能证明任务之间独立。", "",
                  f"783个端点记录对应 {context['unique_candidate_identities']} 个唯一候选身份，唯一事件标识不等于不同候选或实际独立执行。链的净变化除以边数，会使相同首末变化在较长链中被稀释。部分任务包含多条不相连的所选链，因此改用任务最早和最晚的单一差值也会改变本次估计目标。", "",
                  "参考原假设为 E(d_t)=0，统计量 t=均值(d_t)/(标准差(d_t)/√T)，参考自由度 T−1。程序对每任务后项均值和前项均值做配对检验，不是独立两样本检验，因此不要求前后方差相同。精确 t 分布需要各任务差值独立、同分布且正态；实际有界离散差值至多在任务独立和适当可交换的前提下采用大任务样本近似。没有通过正态性检验来选择更好看的分析。公式与程序接口见 [SciPy 配对 t 检验官方文档](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.ttest_rel.html)。", "",
                  "区间和 p 值指向的是假设由相同历史记录与边选择机制产生的可交换任务总体。实际任务独立性、代表性和对未来任务的可推广性均未建立。三次 p 值是未校正的探索性参考，不是三项确认性发现，不据此提出家族显著性结论。百分位区间逐项适用，并不能纠正选择或跨任务依赖。[SciPy 重采样官方文档](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.bootstrap.html)说明一般原理；本脚本自行明确实现任务整群抽样。", "",
                  "## 原标签完整转移表", "",
                  "行是前项标签，列是后项标签。无法确定和部分在此作为非决定性类别保留，不当作数学真值。", ""]
    display_labels = list(LABELS) if english else [language[x] for x in LABELS]
    lines += ["| " + ("Before / after" if english else "前项／后项") + " | " + " | ".join(display_labels) + " |", "|---|---:|---:|---:|---:|"]
    for label, display in zip(LABELS, display_labels):
        lines.append("| " + display + " | " + " | ".join(str(primary["transitions"][label][b]) for b in LABELS) + " |")
    nf = primary["nondecisive_flows"]
    cx = data["context_diagnostics"]
    if english:
        lines += ["", f"{nf['edges_with_either_nondecisive_endpoint']} edges have at least one nondecisive endpoint. Earlier/later nondecisive occurrences are {nf['before_nondecisive_occurrences']}/{nf['after_nondecisive_occurrences']}; {nf['from_nondecisive_to_pass']} edges move from a nondecisive result to pass and {nf['from_pass_to_nondecisive']} move from pass to a nondecisive result. Thus the primary net difference includes changed decision availability as well as fail/pass transitions. The pass/fail-only route excludes these edges explicitly.", "",
                  "## Limits that the calculations cannot remove", "",
                  f"This is a selected retrospective edge set, not a random sample of all tasks, all review attempts, or all possible modifications. Continued review, stopping after pass, prior findings, and recorded role classification shape inclusion. Before/after ordering is inherited from the registered adjacency proxy; this projection does not establish review-completion timestamps. No calendar-time or rule-version effect is estimated. The recorded source-review contract differs on {cx['spine_contract_comparison'].get('different_recorded_value', 0)} edges and task-content fields differ on {cx['task_content_comparison'].get('different_recorded_value', 0)}; equal or different fields alone do not establish fixed conditions or changed goals. Other contemporaneous inputs and dependency versions can also change.", "",
                  "Task aggregation and cluster resampling do not control task difficulty, feedback-driven selection, reviewer configuration, rule changes, calendar effects, shared dependencies, or shared review batches. Cross-task dependency blocks are not available in this projection, so no block-robust inference is claimed. Regression to the mean, selective continuation, and real candidate improvement are possible explanations not distinguished here; no control group or independent correctness outcome identifies their contributions.", "",
                  f"Among the 783 unique endpoint records, check-scope self-reports are {json.dumps(cx['semantic_check_self_report'], ensure_ascii=False, sort_keys=True)}. The {cx['semantic_check_self_report'].get('unknown_check_extent', 0)} unknown extents are not imputed as completed or failed checks; all independent-execution statuses remain `{next(iter(cx['independent_execution_evidence']))}`. The 451 edges without case assessment remain semantically unassessed. A small p-value for recorded-decision change cannot fill these evidence gaps.", "",
                  "## Reproduction and audit", "",
                  f"Run `python -B edge_statistics.py --input-root inputs/edge --output-root .` in this directory; both arguments are optional with those defaults. The portable inputs are minimal frozen field projections, not copies of complete historical records. The script checks their manifest hashes, fixes NumPy PCG64 seed sequences [{SEED}, route_index], uses {BOOTSTRAP_REPLICATES:,} task-cluster draws per route and NumPy's linear 2.5%/97.5% quantiles, and writes only the result JSON and Chinese/English Markdown to the selected output directory. It requires already-installed NumPy and SciPy; no package installation or long-running experiment is involved. Original full-source hashes are recorded at freezing; a portable run verifies the frozen projections and does not claim to reopen unavailable full originals. Absolute source paths are confined to the separate local source manifest, which is not a runtime input.", "",
                  "Mechanical checks cover unique edge/endpoint keys, exact joins, task and candidate bindings, agreement between projected and raw verdict fields, absence of unknown label recoding, input/result hash registration, mean-difference identities, agreement of the t formula and SciPy, graph coverage, and chain telescoping. These checks verify record processing, not semantic validity or task independence. Source SHA-256 values and per-task sufficient statistics are in `edge_statistics.json`. The script itself is also hashed. Software: Python " + data["software"]["python"] + ", NumPy " + data["software"]["numpy"] + ", SciPy " + data["software"]["scipy"] + ".", "",
                  "The statistical fallacy review covers all 11 ARS categories: aggregate/subgroup conflation (no Simpson explanation claimed); ecological inference (estimand remains task or edge mean); selection/Berkson mechanisms (selected history); collider conditioning (decisive-only selection); base-rate neglect (both endpoint pass rates shown); regression to the mean (possible, unseparated); survivorship (continuation and stopping selected); multiple searching (all three tests disclosed); analytic flexibility (session-declared, not preregistered); association/causation (no causal estimate); reverse direction (prior feedback drives subsequent action and time order is a proxy). Coverage is an interpretation checklist, not empirical certification that every bias is absent.", ""]
    else:
        lines += ["", f"{nf['edges_with_either_nondecisive_endpoint']} 条边至少有一端为非决定性结果。前项／后项非决定性结果分别出现 {nf['before_nondecisive_occurrences']}/{nf['after_nondecisive_occurrences']} 次；非决定性结果转通过 {nf['from_nondecisive_to_pass']} 条，通过转非决定性结果 {nf['from_pass_to_nondecisive']} 条。所以主分析净差同时包含作出通过决定的可用性变化和失败／通过转移。纯通过／失败路线明确排除了这些边。", "",
                  "## 计算不能消除的边界", "",
                  f"这是选择后的回溯边集，不是全部任务、全部审核或全部可能修改的随机样本。继续审核、通过后停止、前项问题和角色分类都会影响入组。前后顺序继承登记邻接代理，本投影没有建立审核完成时间；本次没有估计日历时间或规则版本效应。来源审核约束字段在 {cx['spine_contract_comparison'].get('different_recorded_value', 0)} 条边不同，任务内容字段在 {cx['task_content_comparison'].get('different_recorded_value', 0)} 条边不同；字段相同或不同均不单独证明条件固定或目标改变。其他同时期输入和依赖版本也可能变化。", "",
                  "任务汇总和整群重采样不会控制任务难度、反馈驱动的选择、审查配置、规则变化、时期效应、共享依赖或审核批次。本投影没有可用于推断的跨任务独立块，因此不声称得到块稳健结论。均值回归、选择性继续和真实候选改善都是本次未能区分的可能解释；没有对照或独立正确性终点，不能识别各因素贡献。", "",
                  f"783个唯一端点中，{cx['semantic_check_self_report'].get('explicit_not_reviewed', 0)} 份自述未审，{cx['semantic_check_self_report'].get('explicit_reviewability_block', 0)} 份自述可审核性受阻，{cx['semantic_check_self_report'].get('unknown_check_extent', 0)} 份完整检查范围未知；未知既不补作已完成，也不补作失败。独立执行全部为本投影未核查。451条未作逐例判断的边仍保持语义未知。记录决定变化的 p 值再小，也不能填补这些证据缺口。", "",
                  "## 复算与核验", "",
                  f"在本目录执行 `python -B edge_statistics.py --input-root inputs/edge --output-root .`；两个参数不填时采用相同默认值。便携输入是最小字段冻结投影，不是完整历史记录副本。脚本核对清单哈希，固定 NumPy PCG64 种子序列 [{SEED}, 路线索引]，每路线任务整群抽样 {BOOTSTRAP_REPLICATES:,} 次，采用 NumPy 线性2.5%与97.5%分位数，只向指定输出目录写结果 JSON 和中英文报告。使用已安装 NumPy、SciPy，没有安装依赖或启动长期实验。完整原始来源哈希在冻结时记录；便携运行只核对冻结投影，不声称重新打开不可用的完整原件。绝对来源路径仅存于独立的本地来源清单，它不是运行输入。", "",
                  "机械检查覆盖边和端点主键唯一、精确连接、任务与候选绑定、投影和原字段判决一致、未知标签不转零、输入及结果登记哈希匹配、均差恒等式、t公式与SciPy一致、图覆盖及连续链抵消。检查支持记录处理正确，不证明语义有效或任务独立。来源 SHA-256、逐任务充分统计量及脚本自身哈希均写入 `edge_statistics.json`。软件：Python " + data["software"]["python"] + "，NumPy " + data["software"]["numpy"] + "，SciPy " + data["software"]["scipy"] + "。", "",
                  "统计误推检查覆盖11类：汇总／分组混淆（不声称辛普森解释）；生态推断（目标始终为任务或边均值）；选择机制（历史边已筛选）；碰撞条件（纯决定子集）；基准率忽略（同时报告前后通过比例）；均值回归（可能但未区分）；幸存选择（继续与停止）；多重搜寻（三次检验全报）；分析自由度（会话内事先声明，非预注册）；相关与因果（不估计因果）；反向驱动（前次反馈决定后续行动，时间也是代理）。覆盖只说明解释检查已做，不表示每种偏差已经被实证排除。", ""]
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-root", type=Path, default=HERE / "inputs" / "edge", help="Frozen edge input directory")
    parser.add_argument("--output-root", type=Path, default=HERE, help="Directory for the three result files")
    args = parser.parse_args()
    input_root, output_root = args.input_root.resolve(), args.output_root.resolve()
    manifest_path = input_root / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    paths = [input_root / "edge_view.jsonl", input_root / "review_events.jsonl", manifest_path]
    before_hashes = {p.name: digest(p) for p in paths}
    for name, expected in manifest["frozen_input_sha256"].items():
        assert digest(input_root / name) == expected, f"Frozen input hash mismatch: {name}"
    source_edges, reviews = read_jsonl(paths[0]), read_jsonl(paths[1])
    events = {r["review_event_id"]: r for r in reviews}
    assert len(events) == len(reviews) == 783
    assert len({r["adjacent_transition_id"] for r in source_edges}) == len(source_edges) == 465
    assert len({r["raw_pair_id"] for r in source_edges}) == 465
    rows = []
    for edge in source_edges:
        assert edge["original_role"] == "candidate_repair"
        left, right = events[edge["from_review_event_id"]], events[edge["to_review_event_id"]]
        assert left["task_id"] == right["task_id"] == edge["task_id"]
        assert left["review_event_id"] != right["review_event_id"]
        assert left["candidate_sha256"] == edge["from_code_sha256"]
        assert right["candidate_sha256"] == edge["to_code_sha256"]
        assert left["candidate_sha256"] != right["candidate_sha256"]
        before, after = left["recorded_verdict"], right["recorded_verdict"]
        assert before in LABELS and after in LABELS, "Unknown label must never be recoded to zero"
        assert edge["original_verdict_transition"] == f"{before}→{after}"
        rows.append(dict(edge, before_label=before, after_label=after, a_before=int(before == "pass"),
                         a_after=int(after == "pass"), difference=int(after == "pass")-int(before == "pass")))
    assert len({r["task_id"] for r in rows}) == 250
    assert set(events) == {v for r in rows for v in (r["from_review_event_id"], r["to_review_event_id"])}
    for event in reviews:
        assert event["result_fields"]["/verdict"]["state"] == "present"
        assert event["result_fields"]["/verdict"]["value"] == event["recorded_verdict"]
        assert event["candidate_binding_state"] == "matches_snapshot_and_registered_hash"
        for prefix in ("input", "result"):
            assert event[f"{prefix}_document_state"] == "ok"
            assert event[f"{prefix}_expected_sha256"] == event[f"{prefix}_actual_sha256"]
    cohorts = [rows, [r for r in rows if r["before_label"] in ("pass", "fail") and r["after_label"] in ("pass", "fail")],
               [r for r in rows if r["original_confidence"] == "high"]]
    names = [PLAN["primary"], *PLAN["sensitivity"]]
    analyses = [summarize(cohort, name, i) for i, (cohort, name) in enumerate(zip(cohorts, names))]
    output = {"analysis_id": "edge_statistics_v0_2_0_20260906", "analysis_plan": PLAN,
              "software": {"python": platform.python_version(), "numpy": np.__version__, "scipy": scipy.__version__},
              "source_sha256": manifest["original_source_sha256"],
              "frozen_input_sha256": before_hashes, "script_sha256": digest(Path(__file__)),
              "frozen_input_hashes_unchanged_after_analysis": True,
              "source_verification_scope": "Original source hashes recorded at freeze; portable runtime verifies frozen projections, not unavailable full originals",
              "context_diagnostics": {
                  "unique_endpoint_verdicts": sorted_counts(r["recorded_verdict"] for r in reviews),
                  "semantic_check_self_report": sorted_counts(r["semantic_check_self_report"] for r in reviews),
                  "independent_execution_evidence": sorted_counts(r["independent_execution_evidence"] for r in reviews),
                  "spine_contract_comparison": sorted_counts(r["spine_contract_comparison"] for r in rows),
                  "task_content_comparison": sorted_counts(r["task_content_comparison"] for r in rows),
                  "case_assessment": sorted_counts(r["semantic_annotation_status"] for r in rows),
                  "confidence_counts": sorted_counts(r["original_confidence"] for r in rows),
                  "confidence_selection_diagnostic": confidence_description(rows),
                  "confidence_selection_diagnostic_timing": "added after primary estimates to explain inherited selection; descriptive only, no added test or interval",
                  "unique_candidate_identities": len({r["candidate_identity_id"] for r in reviews}),
                  "candidate_identity_multiplicity": sorted_counts(Counter(r["candidate_identity_id"] for r in reviews).values()),
                  "review_completion_time": "not established by these projection tables",
                  "cross_task_independence_blocks": "not available in this projection; no block-robust inference attempted",
              }, "analyses": analyses}
    assert before_hashes == {p.name: digest(p) for p in paths}
    output_root.mkdir(parents=True, exist_ok=True)
    (output_root / "edge_statistics.json").write_text(json.dumps(output, ensure_ascii=False, indent=2, allow_nan=False)+"\n", encoding="utf-8")
    (output_root / "edge_statistics.md").write_text(render(output, False), encoding="utf-8")
    (output_root / "edge_statistics_en.md").write_text(render(output, True), encoding="utf-8")
    print(json.dumps({"completed": True, "frozen_inputs_unchanged": True, "routes": [{"route": r["route"], "edges": r["edges"],
          "tasks": r["tasks"], "task_equal": r["task_equal"], "edge_equal": r["edge_equal"],
          "paired_task_t_reference": r["paired_task_t_reference"]} for r in analyses]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
