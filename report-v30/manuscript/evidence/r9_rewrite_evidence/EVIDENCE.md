# 可离线核查的原始证据

ROOT 表示原 Formalization 工作区；USER_HOME 表示用户主目录。这些是来源定位别名，不是外部链接。原文件 SHA-256 针对读取的完整原始字节；包内文件为明确范围的摘录，另列哈希。没有复制整个日志、教材、数据库或私有推理。

## 结构化证据

- [B07：41 个运行的原字段与输入绑定](sources/B07-root-bindings.json)，RUN_INDEX 的 source_pointer 指向其 roots 数组；各源文件原始哈希列于文件头。
- [A40：114 次评价的回执、请求与公开结果](sources/A40-call-evidence.json)，EVALUATION_INDEX 的 source_pointer 指向其 calls 数组；每个对象分列原文件路径和哈希。
- [B08：缺失用量原账本行](sources/B08-missing-usage.json)。
- [本次机械核对记录](sources/PACKAGING_CHECKS.json)。

## B01 — Z002

命名空间：`Z002`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Z002`

原 SHA-256：`855ac21e06cdd54957c0c54edb7216f58679289fb599249192f37bc9d3c366ba`

范围：`/cutoff_epoch, /cutoff_beijing, /version_denominators, /scope`

[包内摘录](sources/B01.json)；包内 SHA-256：`f6e9e7029149c6356546996aa998d45cc842d36085aaf13afdaec1e4583d2f38`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "/cutoff_epoch": 1789153657.5229585,
  "/cutoff_beijing": "2026-09-12T03:07:37+08:00",
  "/version_denominators": {
    "A_l7_repair_r1": {
      "actual_solver_roots": 1,
      "complete_candidate_packages_observed": 1,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 1,
      "original_selected_common_verdicts": {
        "fail": 1
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "A_original_development_r1": {
      "actual_solver_roots": 9,
      "complete_candidate_packages_observed": 8,
      "noncomplete_packages_observed": 1,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 9,
      "original_selected_common_verdicts": {
        "pass": 8,
        "fail": 1
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "A_runtime_r2_late_development": {
      "actual_solver_roots": 2,
      "complete_candidate_packages_observed": 2,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 2,
      "original_selected_common_verdicts": {
        "pass": 2
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "B_capability_r3": {
      "actual_solver_roots": 1,
      "complete_candidate_packages_observed": 1,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 1,
      "original_selected_common_verdicts": {
        "pass": 1
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "B_original_development_r1": {
      "actual_solver_roots": 5,
      "complete_candidate_packages_observed": 0,
      "noncomplete_packages_observed": 0,
      "package_unknown": 5,
      "common_endpoint_executed_roots": 0,
      "original_selected_common_verdicts": {
        "no_common_label": 5
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "B_transport_r4": {
      "actual_solver_roots": 11,
      "complete_candidate_packages_observed": 11,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 11,
      "original_selected_common_verdicts": {
        "pass": 8,
        "fail": 3
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "C_pilot_r1": {
      "actual_solver_roots": 1,
      "complete_candidate_packages_observed": 1,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 1,
      "original_selected_common_verdicts": {
        "no_common_label": 1
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    },
    "C_runtime_r3": {
      "actual_solver_roots": 11,
      "complete_candidate_packages_observed": 11,
      "noncomplete_packages_observed": 0,
      "package_unknown": 0,
      "common_endpoint_executed_roots": 11,
      "original_selected_common_verdicts": {
        "pass": 9,
        "fail": 1,
        "unresolved": 1
      },
      "denominator_rule": "All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking."
    }
  },
  "/scope": {
    "new_B_C_solver_roots": 16,
    "new_solver_roots_under_revised_L7": 0,
    "registered_consistency_calls": 31,
    "old_opinions_replaced": 0,
    "original_partial_A_H1_and_same_root_full_continuation": "Retained under one root with separate candidate scopes.",
    "A_L7_repair": "Separate root/version, excluded from equal-first-condition interpretation."
  }
}
```

## B02 — DERIVED_RUN_METRICS.json

命名空间：`revision7 DERIVED_RUN_METRICS`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\DERIVED_RUN_METRICS.json`

原 SHA-256：`e29f58d630a10bd69468496f04d148ff82e4b60fc1ae719b50593a8a8a3cd17b`

范围：`/schema, /rules, /summaries`

[包内摘录](sources/B02.json)；包内 SHA-256：`00c8db95f4e7f2e7dd68f7a46b468b1b5f6499a6e1d59bda03e094183bd7600f`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "/schema": "descriptive.current_main_panel.v7",
  "/rules": [
    "Join native root identities, retaining selected versions and the H1 same-root continuation.",
    "Each metric uses only groups complete in all three configurations; missing costs are not replaced with zero.",
    "Spans run from first dispatch to last role return, excluding common endpoint evaluation.",
    "Dispatches include unsuccessful dispatches. Tool counts include completed model-visible returns across solver roles.",
    "Input includes cached input. Tokens are not monetary costs. These are descriptive selected-task summaries."
  ],
  "/summaries": {
    "span_seconds": {
      "groups": [
        "H1",
        "L2",
        "L3",
        "L4",
        "L5",
        "L6",
        "L7",
        "M2",
        "M3"
      ],
      "A": {
        "n": 9,
        "median": 3531.842290878296,
        "min": 854.9600296020508,
        "max": 10929.619734048843
      },
      "B": {
        "n": 9,
        "median": 1989.0595593452454,
        "min": 953.6496787071228,
        "max": 7570.467349052429
      },
      "C": {
        "n": 9,
        "median": 1721.7470161914825,
        "min": 913.9763045310974,
        "max": 6201.780104637146
      }
    },
    "dispatches": {
      "groups": [
        "H1",
        "L1",
        "L2",
        "L3",
        "L4",
        "L5",
        "L6",
        "L7",
        "M1",
        "M2",
        "M3"
      ],
      "A": {
        "n": 11,
        "median": 10,
        "min": 3,
        "max": 32
      },
      "B": {
        "n": 11,
        "median": 3,
        "min": 2,
        "max": 7
      },
      "C": {
        "n": 11,
        "median": 5,
        "min": 3,
        "max": 12
      }
    },
    "input_tokens": {
      "groups": [
        "H1",
        "L2",
        "L3",
        "L4",
        "L6",
        "L7",
        "M2",
        "M3"
      ],
      "A": {
        "n": 8,
        "median": 12940451.0,
        "min": 4541703,
        "max": 95568298
      },
      "B": {
        "n": 8,
        "median": 8532553.5,
        "min": 5025081,
        "max": 63346168
      },
      "C": {
        "n": 8,
        "median": 6750761.5,
        "min": 2915724,
        "max": 55201327
      }
    },
    "completed_tool_returns": {
      "groups": [
        "H1",
        "L1",
        "L2",
        "L3",
        "L4",
        "L5",
        "L6",
        "L7",
        "M1",
        "M2",
        "M3"
      ],
      "A": {
        "n": 11,
        "median": 137,
        "min": 49,
        "max": 484
      },
      "B": {
        "n": 11,
        "median": 107,
        "min": 33,
        "max": 513
      },
      "C": {
        "n": 11,
        "median": 104,
        "min": 44,
        "max": 464
      }
    }
  }
}
```

## B03 — 已归档主表选入程序（只读）

命名空间：`Z synthesis source`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\assemble_final_delivery_r1.py`

原 SHA-256：`998ac78af29ebdebaf53785a36e380d36831ea196ba2978e3e1a2c61b5aaab41`

范围：`lines 1-74`

[包内摘录](sources/B03.txt)；包内 SHA-256：`646ec6c84dfefbabb4c49e485713f3a1f0058a0c0e791ee9dd4a1367745ae3ee`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-74]
"""Self-contained final evidence package; no model execution or replacement of original judgments."""
import collections,csv,datetime,hashlib,json,subprocess,time
from pathlib import Path
R=Path(__file__).resolve().parent;E=R.parent;W=E.parents[2];C=E/'controller_bc_completion_20260911'
read=lambda p:json.loads(Path(p).read_text('utf-8'));sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,v):
    with p.open('x',encoding='utf-8') as f:json.dump(v,f,ensure_ascii=False,indent=2)
census=read(R/'ATTEMPT_CENSUS_DATA.json');roots=census['solver_roots'];bound=read(R/'ROOT_ENDPOINT_BINDINGS.json');byroot={x['root_id']:x for x in bound['roots']}
assert len(roots)==41 and not census['undispatched_queue'] and not census['issues'] and not bound['issues']
reeval=read(R/'REEVALUATION_ACCOUNTING_AND_AUDIT.json');assert len(reeval['calls'])==31 and not reeval['recording_issues'] and not reeval['over_limit_guard_records'] and not reeval['previous_17_bound_files_changed']
resource=read(C/'RESOURCE_AND_GUARD_AUDIT_CURRENT.json');recording=read(C/'RECORDING_AUDIT_CURRENT.json');assert resource['max_active_observed']==2 and not resource['previous_bound_files_changed'] and resource['previous_manifest_unchanged']
assert not recording['issues']
assert not subprocess.check_output([read(C/'L3/C_CONFIG.json')['docker_path'],'ps','-q']).strip()
csv_checks={}
for name,expected in [('ATTEMPT_CENSUS',41),('COVERAGE_MATRIX',41),('UNDISPATCHED_QUEUE',0)]:
    p=R/(name+'.csv')
    with p.open(encoding='utf-8',newline='') as f:reader=csv.DictReader(f);records=list(reader);headers=reader.fieldnames
    assert len(records)==expected and headers
    if expected:assert {x['root_id'] for x in records}=={x['root_id'] for x in roots}
    if name=='ATTEMPT_CENSUS':
        expected_by={x['root_id']:x for x in roots}
        for row in records:
            x=expected_by[row['root_id']];assert float(row['budget_seconds'])==x['budget_seconds']
            for k in ['input_tokens','cached_input_tokens','output_tokens','reasoning_output_tokens']:
                assert row[k]=='' if x['usage'][k] is None else float(row[k])==x['usage'][k]
    if name=='COVERAGE_MATRIX':
        assert sum(int(x['native_service_episodes']) for x in records)==127
        assert sum(int(x['reported_finding_rows']) for x in records)==121
        assert sum(int(x['targeted_semantic_episodes']) for x in records)==6
    csv_checks[name]={'rows':len(records),'columns':len(headers),'sha256':sha(p),'independent_csv_readback':True}
matrices={k:read(R/(k+'_RESULT_MATRIX.json')) for k in ['L2','L3','H1']}
for m in matrices.values():
    for p,h in m['source_index'].items():assert sha(p)==h,(p,'changed matrix source')
index=read(R/'EPISODE_INDEX_STATUS.json')
for p,h in index['source_bindings'].items():assert sha(p)==h,(p,'changed index source')
new_by_decision={}
for label,m in matrices.items():
    for row in m['candidates']:new_by_decision[row['original_decision']['path']]={'group':label,'candidate_id':row['candidate_id'],'values':{k:row[k] for k in ['new_G','new_S','new_F','new_E','new_T','new_Std','new_Family'] if k in row},'source':str(R/(label+'_RESULT_MATRIX.json'))}
allrows=[]
for root in roots:
    evaluations=byroot[root['root_id']]['original_evaluations'];common=[x for x in evaluations if x.get('original_decision')]
    full=[x for x in common if x['candidate_package_status']=='complete'];selected=full[0] if full else common[0] if common else None
    # Selection is complete authorized candidate scope, never its favorable verdict; retain every scope below.
    decision=selected['final_decision'] if selected else None
    row={'root_id':root['root_id'],'task_group':root['task_group'],'arm':root['arm'],'version_subset':root['version_subset'],'run_id':root['run_id'],'budget_seconds':root['budget_seconds'],
      'original_selected_verdict':selected['original_decision']['verdict'] if selected else None,'selected_candidate_scope':selected.get('evaluation_scope') if selected else None,'original_selected_decision':decision,
      'all_original_evaluation_sources':[x.get('final_decision') or x.get('provisional_opinion') for x in evaluations],
      'new_consistency':new_by_decision.get(decision['path']) if decision else None,'comparison_status':'contract_diagnostic_only' if root['task_group']=='L7' else 'interpretation_or_evaluation_limit' if root['task_group'] in ['L2','L3','H1'] else 'version_stratified_development_only',
      'same_root_continuation':root['same_root_continuation'],'repair_trial':root['repair_trial'],'recorded_complete_package':root['complete_candidate_package_observed'],
      'native_dispatch_record_gaps':root['missing_actor_receipts'],'source':str(R/'ROOT_ENDPOINT_BINDINGS.json')}
    allrows.append(row)
main=[x for x in allrows if (x['arm']=='A' and x['version_subset'] in ['A_original_development_r1','A_runtime_r2_late_development']) or x['version_subset'] in ['B_transport_r4','C_runtime_r3']]
assert len(main)==33 and all(sum(x['arm']==arm for x in main)==11 for arm in ['A','B','C'])
subsets={}
for version in sorted({x['version_subset'] for x in roots}):
    rs=[x for x in roots if x['version_subset']==version];ars=[x for x in allrows if x['version_subset']==version]
    subsets[version]={'actual_solver_roots':len(rs),'complete_candidate_packages_observed':sum(x['complete_candidate_package_observed'] is True for x in rs),'noncomplete_packages_observed':sum(x['complete_candidate_package_observed'] is False for x in rs),'package_unknown':sum(x['complete_candidate_package_observed'] is None for x in rs),
      'common_endpoint_executed_roots':sum(x['actual_common_endpoint_executed'] is True for x in rs),'original_selected_common_verdicts':dict(collections.Counter(x['original_selected_verdict'] or 'no_common_label' for x in ars)),
      'denominator_rule':'All actual solver roots in this named version, including failures and missing records. Package presence is not a recovered precise submission timestamp. Original verdict counts are historical outcome accounting, not configuration ranking.'}
costs=read(R/'ALL_COSTS_SEPARATED.json');assert not costs['recording_issues'];coverage=read(R/'EPISODE_SEMANTIC_COVERAGE_FINAL.json');assert coverage['native_service_episodes']==127 and coverage['targeted_semantic_episodes']==6
now=time.time();cutoff=datetime.datetime.fromtimestamp(now,datetime.timezone(datetime.timedelta(hours=8))).isoformat(timespec='seconds')
newstage=[]
for label in ['L3','L4','L5','L6','M2','M3','H1','L7']:
    for arm in ['B','C']:
        ret=read(C/label/('endpoint-'+arm)/'DRIVER_RETURN.json');assert ret['completed'];newstage.append({'task_group':label,'arm':arm,'original_verdict':ret['state']['verdict'],'source':str(C/label/('endpoint-'+arm)/'DRIVER_RETURN.json')})
out={'cutoff_epoch':now,'cutoff_beijing':cutoff,'status':'all_authorized_solver_and_evaluation_calls_executed; unresolved evidence and audit gaps explicitly retained','new_stage':newstage,'all_41_root_rows':allrows,'main_33_root_panel':main,'version_denominators':subsets,
 'scope':{'new_B_C_solver_roots':16,'new_solver_roots_under_revised_L7':0,'registered_consistency_calls':31,'old_opinions_replaced':0,'original_partial_A_H1_and_same_root_full_continuation':'Retained under one root with separate candidate scopes.','A_L7_repair':'Separate root/version, excluded from equal-first-condition interpretation.'},
 'cost_categories':costs['totals_by_category'],'resource_summary':{k:resource[k] for k in ['successful_samples','max_active_observed','max_observation_gap_seconds','previous_manifest_unchanged','previous_bound_files_changed']},
 'coverage':{'all_root_identity_and_original_evaluation_bindings':41,'original_common_endpoint_bound_roots':sum(x['common_endpoint_count']>0 for x in roots),'native_service_episodes':127,'reported_finding_rows':121,'full_returned_feedback_exposures_verified':67,'targeted_semantic_episodes':6,'unchecked_service_episodes':121,'full_trajectory_semantic_coverage':False,'all_original_Lean_proofs_independently_rechecked_by_owner':False},
 'unresolved':['L2 remains G/S interpretation-sensitive for A, early B and C.','L3 unique adjudications for A and B r4 have invalid quotations; accepted labels unresolved.','H1 B unique adjudication has invalid source quotation; reported Std pass/Family fail is not an accepted label.','H1 A is Std pass/Family fail; original unparameterized scope remains ambiguous.','L7 original measurability obligation is not implied; B/C changed public hypotheses and A repair omitted it. C original endpoint also has two format-invalid reviews and finishes unresolved.','121 internal-service episodes lack the targeted owner semantic/adoption reconstruction. Existing independent endpoint opinions do not replace that analysis.','Historical missing usage and exact submission/end timestamps remain unknown or observed lower bounds.','H1 exposed omission of non-Lean delivery documents in the anonymous endpoint adapter. L2/L3 delivery judgments describe the supplied endpoint scope; no universal original-document completeness audit is claimed.'],
 'requires_new_authorization':['Any fresh equal-start A/B/C solving under a revised L7 measurable-f contract.','Any repetition or larger comparative batch with prospectively chosen count, order and budget.'],
 'no_further_model_calls_to_remove_failures':True,'verification':csv_checks}
write(R/'FINAL_UNIFIED_STATUS.json',out)
write(R/'FINAL_ARTIFACT_CHECKS.json',{'epoch':now,'csv':csv_checks,'matrix_source_hashes_all_match':True,'matrix_obligation_rows':{k:len(v['obligation_matrix']) for k,v in matrices.items()},'indexed_episode_source_hashes_match':True,'old_17_files_unchanged':True,'active_or_paused_running_containers':0,'final_csv_no_render_process_exit_code':0,'prior_csv_render_process_exit_code':read(R/'FINAL_DATA_REFRESH_RETURNED_R1.json')['csv_process_exit_code'],'render_failure_resolution':'Machine-readable CSV export repeated without unnecessary preview rendering; process exited 0 and independent CSV readback verified final data.','episode_count_correction':'Finding subrows retain dispatch_id, so parent_episode_id distinguishes 127 native episodes from 121 finding rows; both counts independently checked.'})
```

## A01 — Y001_CURRENT_ACCEPTANCE.zh-CN.md

命名空间：`Y001`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Y001_CURRENT_ACCEPTANCE.zh-CN.md`

原 SHA-256：`28672b45989c21f7c56d9b20b6205d047e124e6849d0ca07db8cb2331fca5113`

范围：`lines 1-31`

[包内摘录](sources/A01.txt)；包内 SHA-256：`4ac4909d9e990902e45ba8bef513f15b93ee45b6f074117df055a21350ddf4ae`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
# 当前验收标准（事后更正）

本标准落实2026-09-12用户的明确决定，用于当前主表。它不改写原始候选、原始评审或历史实验条件，也不要求重新求解。当前结果必须回答是否完成，以及真正尚缺什么；旧合同不满足和外围格式失败不再自动成为当前失败项。

## 评价器

置信度是可选元数据。无可确定数值时记 null，不阻断数学评价。仅对可确定的外层JSON代码围栏、空白、文本换行转义、TeX命令重复转义与排版定界符做兼容；不更改数学符号、语义理由或原投票。来源身份不符仍阻断；确实无法对应的引文进入补证队列，只有实质数学争议才进入针对性模型评价。原输出保留，修复记录保存在本阶段后台。

## L2

采用允许通用数学库及等价证明的G解释。可调用对一般相关族成立的协方差展开，但必须由题设不相关条件实际消去交叉项，并完成弱大数定律的均值、方差、切比雪夫及极限步骤。S解释的自行平方展开只作附加分析，不阻断当前主验收。

## L3

采用原任务明确允许的最终尾部可积表述T。须真实交付该公开范围下的负部控制与一范数收敛，以及密度、全变差、依分布和正态边界任务。不额外要求从扩展积分推出最终可积的E包装。若实际公开定理仍要求所有项可积且无最终尾部包装，则是确切的交付范围缺口，记未完成，而不是数学推理错误。

## H1

全部五个目标及反演/唯一性证明责任均须完成。对原题无参数的柯西应用，采用教材第1/6章明确给出的标准柯西语义作为当前核心范围；允许更广的中心尺度族或位置尺度族实现。表9.1的中心尺度族支持B实际给出的推广，不据此反向发明任意位置量词。任意尺度和任意位置的推广程度单列，不将未明示推广当作当前主失败项。此为当前明确验收选择，不宣称原历史文字本就毫无歧义。

## L7

修正数学任务：有限维随机向量逐坐标的两种收敛等价；连续映射部分明确函数为Borel可测，并在S每一点于环境空间连续，极限落入S为满概率/几乎处处事件。必须实际证明所有复合输出可测以及两种收敛保持；可以由公开支持定理而非仅最后包装定理交付。

对原条件不足所作的合理、公开说明且完整证明的修正版，当前验收为通过。事件表达可采用S可测、预像事件可测或几乎处处成员形式。采用S本身可测是较强的充分修正，其范围须保留说明；在本次“合理修正版完成”标准下可验收，但不宣称与另外两种形式具有完全相同的假设范围。无需最弱修正。无新增函数可测性前提的数值收敛核心作为额外成果记录。

只有数值收敛而没有交付复合可测性、缺整个目标分支、或有实际证明错误，仍如实记未完成/数学失败。原坏合同的字面不满足仅作历史背景。

## 输出与后续

当前主表使用通过、未完成、数学失败、确需补证四类，明确沿用原候选版本及续跑/修复身份。所有足够的原评价可复用；不为消除失败而求解，不通过改标签伪造新模型意见。只作一次阶段级留档，原回执置于后台，用户阅读稿以改动和剩余缺口为主。

```

## A02 — Y002_CURRENT_MAIN_RESULTS.json

命名空间：`Y002`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Y002_CURRENT_MAIN_RESULTS.json`

原 SHA-256：`144e54c6f5008e40e7d1fe101d95c234fc8e0c87105afb91592edd5cf6642a9a`

范围：`(whole object)`

[包内摘录](sources/A02.json)；包内 SHA-256：`97bb70058d2a66627825c3fc94fc84bfa2c78cc0075fe94aec7d8d200ba35dff`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## A03 — Y005_PROCESSING_REPAIRS.json

命名空间：`Y005`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Y005_PROCESSING_REPAIRS.json`

原 SHA-256：`761c02156dae2d0f5ca5bead7fd3003e7a7477822af5e641664389f6e5deaf72`

范围：`(whole object)`

[包内摘录](sources/A03.json)；包内 SHA-256：`a6eb551624f93dbdf8ff529786a125bff24aa13faca5674b25144c5d75dd9107`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "reviews": [
    {
      "label": "L2-candidate-67c83c8b4bf7-1",
      "source": "ROOT/rr-l2-v1\\candidate-67c83c8b4bf7-adjud\\executions\\adjudicator\\attempt-02\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-67c83c8b4bf7-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L2-candidate-92da00620333-1",
      "source": "ROOT/rr-l2-v1\\candidate-92da00620333\\executions\\reviewer-1\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-92da00620333-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L2-candidate-92da00620333-2",
      "source": "ROOT/rr-l2-v1\\candidate-92da00620333\\executions\\reviewer-2\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-92da00620333-2.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L2-candidate-dddb2b2aae36-1",
      "source": "ROOT/rr-l2-v1\\candidate-dddb2b2aae36-adjud\\executions\\adjudicator\\attempt-02\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-dddb2b2aae36-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L2-candidate-8df72d8fe638-1",
      "source": "ROOT/rr-l2-v1\\candidate-8df72d8fe638\\executions\\reviewer-1\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-8df72d8fe638-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L2-candidate-8df72d8fe638-2",
      "source": "ROOT/rr-l2-v1\\candidate-8df72d8fe638\\executions\\reviewer-2\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L2-candidate-8df72d8fe638-2.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L3-candidate-6d87e44415de-1",
      "source": "ROOT/rr-l3-v1\\candidate-6d87e44415de-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L3-candidate-6d87e44415de-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L3-candidate-b299284a15fd-1",
      "source": "ROOT/rr-l3-v1\\candidate-b299284a15fd-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L3-candidate-b299284a15fd-1.json",
      "state": "ready",
      "repairs": [
        {
          "kind": "quotation_presentation",
          "resolution": {
            "state": "presentation_repair",
            "path": "reevaluation\\TAIL_SCOPE_REVISION.json",
            "line_start": 3,
            "line_end": 5,
            "original_quote": "\"not_original_preregistration\": true,\r\n  \"trigger\": \"Initial F/E reviews exposed that E demands an extended-integral-to-eventual-integrability wrapper even when a candidate uses the eventual-integrability formulation expressly permitted by TASK. Preserve E as strict source-scope sensitivity; do not silently impose it as the only original TASK acceptance rule.\",\r\n  \"quoted_original_task\": \"合同允许采用最终尾部可积表述\"",
            "exact_source_context": "  \"not_original_preregistration\": true,\n  \"trigger\": \"Initial F/E reviews exposed that E demands an extended-integral-to-eventual-integrability wrapper even when a candidate uses the eventual-integrability formulation expressly permitted by TASK. Preserve E as strict source-scope sensitivity; do not silently impose it as the only original TASK acceptance rule.\",\n  \"quoted_original_task\": \"合同允许采用最终尾部可积表述\",",
            "normalization": "whitespace; prose literal newlines; TeX repeated command escapes and math delimiters only",
            "location": "$.source_reading.evidence[2]"
          }
        }
      ],
      "issue_count": 0
    },
    {
      "label": "L3-candidate-ca86a7f5709c-1",
      "source": "ROOT/rr-l3-v1\\candidate-ca86a7f5709c-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L3-candidate-ca86a7f5709c-1.json",
      "state": "ready",
      "repairs": [
        {
          "kind": "quotation_presentation",
          "resolution": {
            "state": "presentation_repair",
            "path": "source\\SOURCE.tex",
            "line_start": 2,
            "line_end": 2,
            "original_quote": "Assume that \\int f_n\\, d\\mu \\to \\int f\\, d\\mu < \\infty$.",
            "exact_source_context": "\\textbf{7.6 (Scheff\\'e Lemma).} Suppose $f_n$'s are nonnegative measurable functions that converge to $f$ almost everywhere as $n\\to\\infty$. Assume that $\\int f_n\\, d\\mu \\to \\int f\\, d\\mu < \\infty$.",
            "normalization": "whitespace; prose literal newlines; TeX repeated command escapes and math delimiters only",
            "location": "$.source_reading.evidence[0]"
          }
        }
      ],
      "issue_count": 0
    },
    {
      "label": "L3-candidate-2ec562216bc6-1",
      "source": "ROOT/rr-l3-v1\\candidate-2ec562216bc6-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L3-candidate-2ec562216bc6-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "H1-candidate-ad3cbe004a3a-1",
      "source": "ROOT/rr-h1-v1\\candidate-ad3cbe004a3a-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\H1-candidate-ad3cbe004a3a-1.json",
      "state": "ready",
      "repairs": [
        {
          "kind": "quotation_presentation",
          "resolution": {
            "state": "presentation_repair",
            "path": "source\\SOURCE.tex",
            "line_start": 132,
            "line_end": 132,
            "original_quote": "\\\\textbf{Problem 9.6} Let $X_1,\\\\ldots,X_n$ be i.i.d. Cauchy random variables.",
            "exact_source_context": "\\textbf{Problem 9.6} Let $X_1,\\ldots,X_n$ be i.i.d. Cauchy random variables. Show that $(X_1+\\cdots+X_n)/n$ is Cauchy with the same distribution as $X_1$.",
            "normalization": "whitespace; prose literal newlines; TeX repeated command escapes and math delimiters only",
            "location": "$.source_reading.evidence[0]"
          }
        }
      ],
      "issue_count": 0
    },
    {
      "label": "H1-candidate-c47950c412e8-1",
      "source": "ROOT/rr-h1-v1\\candidate-c47950c412e8-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\H1-candidate-c47950c412e8-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "H1-candidate-dfce8b6cb8f4-1",
      "source": "ROOT/rr-h1-v1\\candidate-dfce8b6cb8f4-adjud\\executions\\adjudicator\\attempt-01\\REVIEW_RESULT.json",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\H1-candidate-dfce8b6cb8f4-1.json",
      "state": "ready",
      "repairs": [],
      "issue_count": 0
    },
    {
      "label": "L7-C-original-reviewer-1",
      "source": "ROOT/ep-bc-l7-c\\development-ac-r1\\cases\\c2fb5f540fc9fa12c894317b9f8877dda7181210d43384d4a81b417eb07ea39d\\executions\\reviewer-1\\attempt-01\\actor\\raw-public-events.bin",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L7-C-original-reviewer-1.json",
      "state": "ready",
      "repairs": [
        {
          "kind": "optional_confidence",
          "original": {
            "score": 0.97,
            "level": "high",
            "rationale": "技术验证通过，且两份候选源码及全部指定上游文件均已完整核验；失败原因是公开定理 thm_10_11 增加了无法由教材条件推出的全局可测性前提 hf，因而没有证明原公开陈述的强度。"
          },
          "normalized": 0.97,
          "note": "Unavailable numerical confidence is null and never a mathematical verdict."
        }
      ],
      "historical_vote_unchanged": "fail",
      "issue_count": 0
    },
    {
      "label": "L7-C-original-reviewer-2",
      "source": "ROOT/ep-bc-l7-c\\development-ac-r1\\cases\\c2fb5f540fc9fa12c894317b9f8877dda7181210d43384d4a81b417eb07ea39d\\executions\\reviewer-2\\attempt-01\\actor\\raw-public-events.bin",
      "output": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_repair_r3_20260912\\normalized\\L7-C-original-reviewer-2.json",
      "state": "ready",
      "repairs": [
        {
          "kind": "optional_confidence",
          "original": {
            "score": 0.97,
            "level": "高",
            "rationale": "已完整读取全部指定冻结输入，逐项核对公开声明、定义展开、证明路线和中性技术事实。两项目标均闭合，未发现结论迁移、额外公理、未证关键责任或语义削弱。"
          },
          "normalized": 0.97,
          "note": "Unavailable numerical confidence is null and never a mathematical verdict."
        }
      ],
      "historical_vote_unchanged": "pass",
      "issue_count": 0
    }
  ],
  "real_previously_invalid_outputs_recovered": 5,
  "unresolved_evidence_items": [],
  "new_model_calls": 0,
  "original_votes_and_reasons_preserved": true
}
```

## A04 — Y006_TEST_RESULTS.json

命名空间：`Y006`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Y006_TEST_RESULTS.json`

原 SHA-256：`00cb18d7d9fa2d5ccc90a3b171013628a6285dca1446a019490e2b04adb4edeb`

范围：`(whole object)`

[包内摘录](sources/A04.json)；包内 SHA-256：`fb7263a57c909212235dffe327e834a5678a624982e7c82d60bbe1b7f643e72b`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "command": "python -m unittest discover -s evaluation_repair_r3_20260912 -p test_*.py",
  "observed_exit_code": 0,
  "tests_run": 18,
  "failures": 0,
  "errors": 0,
  "observed_elapsed_seconds": 0.117,
  "before_fix_repro": "parser-before-tests.txt",
  "real_legacy_failure_samples": 5,
  "new_model_calls": 0
}
```

## A05 — Y007_STAGE_COMPLETED.json

命名空间：`Y007`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\Y007_STAGE_COMPLETED.json`

原 SHA-256：`e4ac07beb2c72516b9927c3caf6e011a3a7a9c8e12e90cf5cebbb2f945116aee`

范围：`(whole object)`

[包内摘录](sources/A05.json)；包内 SHA-256：`3a4becc47c75289ee1c87469ecba8c6223eabd7877083b330f953cb8c6f87bb9`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "completed_at": "2026-09-12T09:22:31.625939+08:00",
  "current_main_rows": 33,
  "pass": 30,
  "incomplete": 3,
  "format_unresolved": 0,
  "pending_model_followups": 0,
  "new_model_calls": 0,
  "new_solver_calls": 0,
  "new_builds": 0,
  "new_containers": 0,
  "production_state_touched": false,
  "original_evidence_unchanged_by_this_stage": true
}
```

## A10 — RULE_INTERPRETATION.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\RULE_INTERPRETATION.json`

原 SHA-256：`149c70441ffd374a1b99a0de484f41fb5fb3142ea9be093e1e30b89024811b9d`

范围：`(whole object)`

[包内摘录](sources/A10.json)；包内 SHA-256：`10820df4771c1ae8af8a0a765017ebf396a6b5657bf36236df2e943d9981f5e9`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789128993.1904583,
  "version": "obligation-consistency-sensitivity-r1",
  "status": "registered_before_new_evaluations; frozen library identity verification required before model dispatch",
  "source_request": "ROOT/reports\\trajectory_analysis\\team_review_v031_trajectory_v3_20260911\\combined_revision_v3_20260911\\EXECUTION_REQUEST.zh-CN.md",
  "source_request_sha256": "761c800c4fb6c594ae0f43fe0d15d95204e8f6ce5190516f8def1542da3b1326",
  "L2_common_rule_quote": "合法 Mathlib 能力不为制造难度而临时禁用。计划依赖或现有导入只说明可用上游，并不要求采用某条已有证明路线；数学等价的替代证明允许。",
  "L2_task_quote": "证明须从不相关定义处理中心化与交叉项，不能把和方差公式作为调用前提。",
  "behavior_classes": {
    "1": "Circular premise or target-specific answer: importing the desired uncorrelated variance additivity as a new premise or delegating the same target obligation without discharging it. Prohibited in both readings.",
    "2": "General variance/covariance expansion valid for correlated variables, followed by a candidate proof from the given uncorrelated definition that cross terms vanish. Distinct from class 1; assess mathematics and delegation separately.",
    "3": "Candidate or allowed support proves centered-square expansion and expectation linearity itself, then eliminates cross terms. Permitted in both readings if correct."
  },
  "interpretations": {
    "G_general_foundation_allowed": "Class 2 is permitted by the shared lawful-library and equivalent-route rules; the task-specific prohibition concerns assuming/delegating the target additivity result itself. Centering, cross-term elimination and all WLLN obligations remain mandatory.",
    "S_expansion_must_be_in_candidate": "Read the task-specific wording as requiring the centered-square/expectation expansion in candidate or allowed support; a general covariance expansion delegates that required derivation and fails route closure even if mathematically correct."
  },
  "selection_policy": "Run both readings symmetrically for every candidate; do not select by winning configuration, function name, code length or old pass. If results differ, main comparison label is criterion_dispute and both sensitivity labels remain visible. Old labels remain immutable.",
  "dimensions": [
    "mathematical_statement_and_premises",
    "source_route_obligation",
    "public_interface",
    "bundle_delivery",
    "response_format",
    "controller_or_contract_responsibility"
  ],
  "composition": {
    "math": "pass only if original mathematical statement follows from original admissible premises with no escapes and all target conclusions present",
    "route_G_S": "evaluate each obligation under both registered readings",
    "interface_delivery": "each required endpoint and every task in bundle must close; support may close an obligation only with a real code binding",
    "overall_G_S": "pass iff math, selected route interpretation, interface and complete delivery all pass; valid negative evidence may yield fail; missing or invalid evaluation yields unresolved rather than mathematical fail",
    "main_comparison": "criterion_dispute when the registered interpretations change overall status; contract_unresolved for unsupported/unsatisfiable obligations; otherwise retain robust interpretation result",
    "format": "invalid format is an execution/evaluation failure, not a mathematical verdict; original response and costs retained; at most the existing unique adjudication, never retry until pass"
  },
  "new_review_policy": {
    "original_candidate_bytes_unchanged": true,
    "original_source_and_dependencies_unchanged": true,
    "arm_and_old_verdict_hidden": true,
    "independent_dual_review_per_candidate": true,
    "same_obligation_schema": true,
    "cross_candidate_consistency_after_independent_reviews": true,
    "model": "gpt-5.6-sol",
    "effort": "medium",
    "per_review_seconds": 1800,
    "new_solver_calls": 0,
    "shared_global_activity_limit": 2,
    "solver_and_reassessment_costs_separate": true
  },
  "L7_policy": {
    "current_and_authorized_original_runs": "Preserve original input; classify original L7 runs as diagnostic pending source-convention and satisfiability analysis; never use unresolved L7 for configuration ranking.",
    "new_contract": "Separate revision may add explicit Borel measurability plus ambient continuity at S; no revised-condition solver dispatch in the existing 16-run authorization.",
    "separate_columns": [
      "candidate_did_not_prove_written_measurability",
      "written_measurability_follows_from_original_assumptions",
      "convergence_statement_proved",
      "source_convention_evidence"
    ],
    "new_trials": "Proposal only if beyond existing authorization"
  },
  "L3_H1_policy": "Scan all 11 contracts; apply analogous disputes to every affected candidate, including new L3 B/C, and distinguish eventual-tail integrability and standard/general Cauchy range."
}
```

## A11 — H1_DETAILED_RULE_R1.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\H1_DETAILED_RULE_R1.json`

原 SHA-256：`f0d17d1d95131f2ace2c50d4192e7aa382b6b408790eecfd6beb5e44dcd54046`

范围：`(whole object)`

[包内摘录](sources/A11.json)；包内 SHA-256：`6b0a310419950faa0b079be16c96a5d732c96b44d086de6c8701042c23884b85`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789148840.4816048,
  "rule": {
    "scope_registration": {
      "epoch": 1789130628.6146948,
      "status": "scope_sensitivity_registered_before_B_C_H1_dispatch",
      "Std": "Unparameterized Cauchy read as the standard cauchyMeasure 0 1 convention.",
      "Family": "Cauchy read as all location/positive-scale laws; requires same-law sample-average conclusion for arbitrary common location and positive scale.",
      "evidence": "Frozen H1 TASK item 4 and SOURCE prob_9_6 do not spell out location/scale or standard; old A adjudicator chose Std and the opposing reviewer chose Family.",
      "rule": "Preserve original A complete/partial and continuation identities. Apply both ranges to every eventual original A/B/C full candidate; do not retroactively treat old adjudicator choice as a unique frozen definition. Inspect all other inversion-chain obligations.",
      "inflight_inputs_changed": false,
      "new_solver_trials": 0
    },
    "scope_registration_sha256": "fd39abddd2b522d5106e5e34bab34b242409c4b5809cad13041a91b2e829e00b",
    "obligations": {
      "E1": "所有实数的复指数差界，正负与零值及真实证明。",
      "I1": "反演公式一般概率分布公开端点，无额外无原子/密度假设；端点半质量。",
      "I2": "有限截断的被积函数可积性、Fubini交换及界；不是把目标积分交换直接作为假设。",
      "I3": "振荡核化简与Dirichlet积分极限的本组新证明；允许通用基础但无目标专有预给答案。",
      "I4": "开区间内部、端点、外部各极限值；统一支配与积分极限实际闭合。",
      "U1": "由反演公式证明特征函数唯一性；实际落实连续点稠密选择与测度确定。",
      "C1": "独立同分布柯西样本平均同分布；Std标准与Family任意共同位置正尺度分别核查，不由未量化参数推一般结论。",
      "C2": "教材密度语义与特征函数表征真实连接；两种范围各自可用，允许不调用唯一性定理的合法替代。",
      "Z1": "特征函数在2π等于1推出几乎处处整数值，单位模等号及复指数周期刻画真实闭合。",
      "Z2": "几乎处处整数值推出特征函数在2π等于1；可测与分布接口。",
      "P1": "除柯西量词歧义以外，全部公开前提、边界与目标数学陈述正确且获任务许可。",
      "D1": "五目标全部交付；目标专有分析支持在本组新做，依赖闭合，无循环或证明逃逸。"
    },
    "timing": "Std/Family registered before B/C first H1 dispatch. Detailed common rubric frozen after original candidates return, before new independent reviews; not original experiment preregistration.",
    "composition": "For each reading combine mathematics, public_premises, route_<reading>, interface, delivery and all obligation statuses. Any fail => fail; else any unresolved => unresolved; else pass.",
    "separation": "Mathematical validity under stated premises is separate from missing source domain, required proof route, interface and delivery. Cauchy range affects C1/C2 and corresponding route, not automatically all other obligations.",
    "nonranking": "If scope changes labels preserve criterion_dispute; do not choose Std or Family from winner. Original A partial and same-root full continuation remain separate evidence, with no new A solver.",
    "limits": "The unparameterized frozen Cauchy wording is not made uniquely standard by the old adjudicator. Read all five target proofs and permitted support; no majority-vote truth."
  },
  "new_solver_trials": 0
}
```

## A12 — H1_DELIVERY_EVIDENCE_SCOPE_ADDENDUM_R1.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\H1_DELIVERY_EVIDENCE_SCOPE_ADDENDUM_R1.json`

原 SHA-256：`9315583ad1f94030fa83f615b969e31d3ac759391affdd9c7b5b26f00a6574db`

范围：`(whole object)`

[包内摘录](sources/A12.json)；包内 SHA-256：`8ab8bbb8bab12bffba1ec6b988fd5d766662927418c4759443a01956ec5786bd`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789149911.8834066,
  "status": "additional_evidence_scope_registered_after_six_initial_reviews_before_unique_adjudications",
  "trigger": "Initial reviews inconsistently equate delivery with Lean source completeness, or infer missing final explanation from an endpoint subject that omitted original non-Lean delivery artifacts. B D1 differs; A has invalid quote and delivery disagreement; C uses source completeness only. Symmetric adjudication is required.",
  "original_rule": "最终说明须列出全部目标/支持文件、公开声明与前提，并把任务书每项义务绑定到实际证明。",
  "uniform_application": "Evaluate original delivered explanation across preserved final message, native neutral submission manifest, original delivered documentation and explicit source documentation. Missing from the anonymized endpoint view does not prove absent from the solver delivery. Do not require a new centralized filename or the later 12-row evaluator decomposition: original TASK has five targets and its stated sub-obligations.",
  "separation": "Report source-code completeness and explanatory-delivery completeness separately within dimensions.delivery, with reasons and evidence. Mathematical correctness under stated premises does not fail solely because explanation is absent. Overall composition retains the original delivery dimension, with uncertainty explicit.",
  "no_changed_solver_artifacts": true,
  "old_initial_views_unchanged": true,
  "not_original_preregistration": true,
  "max_adjudications_per_candidate": 1,
  "new_solver_trials": 0
}
```

## A13 — H1_DELIVERY_ORIGINAL_PROVENANCE_R1.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\H1_DELIVERY_ORIGINAL_PROVENANCE_R1.json`

原 SHA-256：`67145ed72304d687d58bf9634738ebd1bde6c0508425169dfdeba9cf0c19a6ed`

范围：`(whole object)`

[包内摘录](sources/A13.json)；包内 SHA-256：`321e6c472f5d3a8f9ddd52373e98cceefc52815f3668a96b4d688ca1806f4832`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789149912.3025463,
  "candidates": [
    {
      "candidate_id": "candidate-ad3cbe004a3a",
      "arm": "B",
      "original_delivery_sources": [
        {
          "original_raw": "ROOT/bcap-r4-runs\\coverage-H1-B-r4-001\\author-call-01\\raw-public-events.bin",
          "raw_sha256": "153fb283e39c78b5467f6cefbf02eb1af428b6655aacddada2618f1d9cd85725",
          "final_message_line": 1064,
          "original_message_sha256": "7dbd92c42f33e68d90f7a05e0f502222fe854236464730adaf17d422dd85407d",
          "neutral_file": "original_delivery/FINAL_MESSAGE.txt",
          "neutral_sha256": "6a855d486cc2a480adba66710ceae10f1d7cad263c72dd11b3e6531857544b6a",
          "transformation": "Deterministic removal of internal review status/clock lines; original retained in raw. Not a mathematical rewrite."
        },
        {
          "original_path": "ROOT/bcap-r4-runs\\coverage-H1-B-r4-001\\submission.json",
          "sha256": "6653796a4ff85c0296a90d1f35e188e2a70a6e5da051215bf2f5c9096dd538f5",
          "copied_as": "original_delivery/NEUTRAL_SUBMISSION.json",
          "native_archive_binding": {
            "path": "ROOT/bcap-r4-runs\\coverage-H1-B-r4-001\\final-snapshot\\work.tar",
            "sha256": "72fb77c03863a22a815b0e87ba2b8f6e8d4086cdb29e537b2e409a3043012192",
            "entry": "./submission.json",
            "entry_sha256": "6653796a4ff85c0296a90d1f35e188e2a70a6e5da051215bf2f5c9096dd538f5",
            "json_semantically_identical": true
          }
        }
      ]
    },
    {
      "candidate_id": "candidate-c47950c412e8",
      "arm": "C",
      "original_delivery_sources": [
        {
          "original_raw": "ROOT/c-r3-runs\\c-r3-h1-001\\run\\actors\\coordinator-001\\raw-public-events.bin",
          "raw_sha256": "24d6cdbeea799387410a1e4d24e3720e5bceb770391692c7f6fd58e149470b52",
          "final_message_line": 287,
          "original_message_sha256": "db6ce132e6b173ba4baf4eb061868ad8a024537e7ad1b8eb87e6429025357178",
          "neutral_file": "original_delivery/FINAL_MESSAGE.txt",
          "neutral_sha256": "9d6b7a532c011b0a0047f26e18f140730a08c702bb476fb56b82cb2bf8cfd1ef",
          "transformation": "Deterministic removal of internal review status/clock lines; original retained in raw. Not a mathematical rewrite."
        },
        {
          "original_path": "ROOT/c-r3-runs\\c-r3-h1-001\\run\\candidates\\c6\\visible-files\\DELIVERY.zh-CN.md",
          "sha256": "06c053469b31ad8fd4bcbb1dc3eb22158d6b429ae39a648dff415fb4040a0eda",
          "copied_as": "original_delivery/DELIVERY.zh-CN.md"
        },
        {
          "original_path": "ROOT/c-r3-runs\\c-r3-h1-001\\run\\candidates\\c6\\visible-files\\DECLARATIONS.zh-CN.md",
          "sha256": "6ec213dee7c24e4b093357bfd8f04af40de235fe249106957b2c7c7083aacc92",
          "copied_as": "original_delivery/DECLARATIONS.zh-CN.md"
        }
      ]
    },
    {
      "candidate_id": "candidate-dfce8b6cb8f4",
      "arm": "A",
      "original_delivery_sources": [
        {
          "original_raw": "ROOT/a-h1-cont-r4\\author-call-03\\raw-public-events.bin",
          "raw_sha256": "b7ee62a16bbb0be90f4473f7e083bfcd09a3cd01ed7987ce6f4ad4d69a470801",
          "final_message_line": 116,
          "original_message_sha256": "664549f43f4b205546711a9e46c01494c1e872a2422b8dc657e3d70dd9677a0c",
          "neutral_file": "original_delivery/FINAL_MESSAGE.txt",
          "neutral_sha256": "b6e8930fe3bda46697022808b46c4e8c7dd2c32ff73064644006d2a1f6719eb3",
          "transformation": "Deterministic removal of internal review status/clock lines; original retained in raw. Not a mathematical rewrite."
        },
        {
          "archive": "ROOT/a-h1-cont-r4\\final-snapshot\\work.tar",
          "archive_sha256": "462505fef05125b08f33094a316e9489f7a857f1db629514951f9150eebaec64",
          "report_like_names": [
            "./artifacts/phase2_prompt_packs/prob_9_6/failure_summary.md",
            "./artifacts/phase2_prompt_packs/prob_9_6/semantic_review_report.md",
            "./artifacts/phase2_prompt_packs/prob_9_6/semantic_review_report_v1.md",
            "./artifacts/phase2_prompt_packs/prob_9_6/verification_report.md",
            "./artifacts/phase2_prompt_packs/prob_9_8/failure_summary.md",
            "./artifacts/phase2_prompt_packs/prob_9_8/semantic_review_report.md",
            "./artifacts/phase2_prompt_packs/prob_9_8/semantic_review_report_v1.md",
            "./artifacts/phase2_prompt_packs/prob_9_8/verification_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_4/failure_summary.md",
            "./artifacts/phase2_prompt_packs/thm_9_4/semantic_review_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_4/semantic_review_report_v1.md",
            "./artifacts/phase2_prompt_packs/thm_9_4/verification_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_5/failure_summary.md",
            "./artifacts/phase2_prompt_packs/thm_9_5/semantic_review_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_5/semantic_review_report_v1.md",
            "./artifacts/phase2_prompt_packs/thm_9_5/verification_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_6/failure_summary.md",
            "./artifacts/phase2_prompt_packs/thm_9_6/semantic_review_report.md",
            "./artifacts/phase2_prompt_packs/thm_9_6/semantic_review_report_v1.md",
            "./artifacts/phase2_prompt_packs/thm_9_6/verification_report.md",
            "./artifacts/phase2_softdep_packs/ch9_batch_0236031/apply_report.md",
            "./artifacts/phase2_softdep_packs/ch9_batch_1540889/apply_report.md"
          ],
          "limit": "Names found here are historical engine review/verification reports, not treated as an author-created final explanatory report. Source docstrings and final message remain available; no claim of exhaustive semantic absence from every file."
        }
      ]
    }
  ],
  "new_solver_trials": 0
}
```

## A14 — L3_RULE_AND_CANDIDATE_ROSTER.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L3_RULE_AND_CANDIDATE_ROSTER.json`

原 SHA-256：`a00d1718a78295bfe7d513fe02db51db37b2ab5b82eaf7737bb26698880d39e4`

范围：`(whole object)`

[包内摘录](sources/A14.json)；包内 SHA-256：`3188d4131ac1a184288a53293ae8348f77e4ce6e8e1b88b7adace012a8172148`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789130628.6146948,
  "version": "L3-integral-domain-sensitivity-r1",
  "registered_before_new_L3_evaluation": true,
  "retrospective_to_original_results": true,
  "original_rule_quote": "合同允许采用最终尾部可积表述",
  "readings": {
    "F_finite_real_integral_sequence": "Interpret the displayed integral convergence as a real-valued sequence of finite integrals. Then individual integrability is part of that convention; assess the rest of the original theorem and density/Gaussian obligations independently.",
    "E_nonnegative_extended_integrals": "Nonnegative measurable inputs have extended integrals; convergence to a finite limit implies only eventual integrability, allowing finitely many infinite initial integrals. A source-scope public theorem must close this tail reduction rather than require all terms integrable."
  },
  "required_separation": [
    "correctness of the theorem under explicitly stated premises",
    "source-domain convention for integral sequence",
    "public interface closure or missing tail wrapper",
    "all general density and Gaussian positive/zero-variance obligations"
  ],
  "composition": "Both readings applied to all three candidates; retain original labels. Do not infer mathematical falsity from a stronger interface. If source-domain convention changes acceptance, mark criterion_dispute and retain both sensitivity labels.",
  "not_a_winner_selection": "A old pass is not truth; B old fail is not truth; C must be checked for all other obligations too.",
  "new_solver_calls": 0,
  "candidates": [
    {
      "private_source_arm": "A",
      "case": "ROOT/ep-a-stage-l3\\development-ac-r1\\cases\\da84ef9a9f0ba214ab52b794960ac6abcbfd3cdefa45ae811e1d70dd9f8edf47",
      "original_decision": "ROOT/ep-a-stage-l3\\development-ac-r1\\cases\\da84ef9a9f0ba214ab52b794960ac6abcbfd3cdefa45ae811e1d70dd9f8edf47\\final\\decision.json",
      "original_verdict": "pass",
      "decision_sha256": "9458846909ec9b3b33704e2abb955bcd24d5d161dc59010397146d1ba6d771d1",
      "subject_files_sha256": {
        "source/SOURCE.tex": "db9b1054cdd6029537037157fb0a187503d2ab35f9021ea9f6a61d57152cc614",
        "task_contract/COMMON_RULES.zh-CN.md": "640e3fe538afea156b97e1766290be0b662486e5ff247af69c9f587f0a2a7949",
        "task_contract/TASK.zh-CN.md": "b0c4dd2ccfb79f00537b98c83af82810a1fb78cac3bbaa09b37f719081acfb16",
        "tool_fact/technical-validation.json": "2c8b5b3b4aca641a6703689000d71bf18a449fe7d4cf7ad713daa581c3288d35",
        "candidate/ProbabilityTheory/chapter_07/prob_7_6.lean": "56c208c148b8528350fadd192743712b22a696d606b3febb8eefce3e140866b2",
        "candidate/ProbabilityTheory/chapter_10/ex_10_3_2.lean": "9c7a123c815c1d5a91f92de77239e205e502849c24feff7a57e25000fc57aedb",
        "upstream/ProbabilityTheory/chapter_07/thm_7_11.lean": "d426c39e02bb1c0021872b986bcb5efef4201f01fcfd7f0d836cecf367a04b68",
        "upstream/ProbabilityTheory/chapter_08/def_8_5.lean": "f1eabbdb8039dcb106bf5c1d2e45cb19709c5e09e1a646dd8a9ec5a7d2485963",
        "upstream/ProbabilityTheory/chapter_08/prob_8_7.lean": "e519469e0774622e346298e4302f07f3a1ecbac0ce9a0d5d3ca598f1d850d7d2",
        "upstream/ProbabilityTheory/chapter_08/thm_8_6.lean": "6bdefb8b6d56ede91290d4b5cabf2be96badb792b177178ceb9813b9ade0330a",
        "upstream/ProbabilityTheory/chapter_10/def_10_4.lean": "3a1acf25daa209a89fc590bb47e562fccd83051433688af7a1383512f637bc24",
        "upstream/ProbabilityTheory/chapter_10/def_10_5.lean": "eddf0d56154ef3104ab5fc2852c1fdae85d39da52d8baa5ce6486aba702d762a",
        "upstream/ProbabilityTheory/chapter_10/ex_10_3_1.lean": "90ec14c6ebf589763e63b7afe24ddb71d693b704ee4f82acaf1228b3f67578bb",
        "upstream/ProbabilityTheory/chapter_10/thm_10_6.lean": "2572f91885ca57222a32a058ddf665174438756581f2739ddc149ae15047d38d",
        "upstream/ProbabilityTheory/chapter_13/thm_13_5.lean": "1f873b33c7c446e3f9840896c8a4362eb1fa1757e96a8a5be39774652e4d2edc",
        "upstream/ProbabilityTheory/chapter_14/def_14_1.lean": "5f6fad3aea7270b16c5b339f2535a4d1777b72f43073ad01a32658f458144cc1",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4.lean": "921416e3fbe6525b2e87e6b88f1ab42fcb87c7757f4fda5568c74ae73dcf1f47",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_density_support.lean": "08b047e2251579d907798fbdee67e11a33a6b258cc0a4150a90b9a9460ad6ccb",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_dominating_measure.lean": "f5a1f21acd9e1a37c2f445acb4f9d64b33b1442151b6fa90f18c00a0cf43ddfe",
        "upstream/ProbabilityTheory/common_support/tv_distance_core.lean": "b05b2b4d9b460fd9be5d1a3d4327ed6642ff0aa96a88b65ff2aa577987f80881"
      }
    },
    {
      "private_source_arm": "B",
      "case": "ROOT/ep-bc-l3-b\\development-b-r4\\cases\\447c36e582349b851e226f61f1ffe27bf131228f880a4e333ed0870f57bf457b",
      "original_decision": "ROOT/ep-bc-l3-b\\development-b-r4\\cases\\447c36e582349b851e226f61f1ffe27bf131228f880a4e333ed0870f57bf457b\\final\\decision.json",
      "original_verdict": "fail",
      "decision_sha256": "f6267dc0651ff979a2d10877f93e79952f8056c489e4b42d191c0fcd06593a51",
      "subject_files_sha256": {
        "source/SOURCE.tex": "db9b1054cdd6029537037157fb0a187503d2ab35f9021ea9f6a61d57152cc614",
        "task_contract/COMMON_RULES.zh-CN.md": "640e3fe538afea156b97e1766290be0b662486e5ff247af69c9f587f0a2a7949",
        "task_contract/TASK.zh-CN.md": "b0c4dd2ccfb79f00537b98c83af82810a1fb78cac3bbaa09b37f719081acfb16",
        "tool_fact/technical-validation.json": "f34884919ddfb6fbd8517f897cc9697d244ad7d7c3564803eb478f3130d66676",
        "candidate/ProbabilityTheory/chapter_07/prob_7_6.lean": "d2c237c168b2346e235ded87654798c76b356de65387ffe86dab48666cb53d13",
        "candidate/ProbabilityTheory/chapter_10/ex_10_3_2.lean": "4a67292b0fe682cc35702861bc241286ba642fc1dc6a5423f7d838f6ec3ef08e",
        "upstream/ProbabilityTheory/chapter_07/thm_7_11.lean": "d426c39e02bb1c0021872b986bcb5efef4201f01fcfd7f0d836cecf367a04b68",
        "upstream/ProbabilityTheory/chapter_08/def_8_5.lean": "f1eabbdb8039dcb106bf5c1d2e45cb19709c5e09e1a646dd8a9ec5a7d2485963",
        "upstream/ProbabilityTheory/chapter_08/prob_8_7.lean": "e519469e0774622e346298e4302f07f3a1ecbac0ce9a0d5d3ca598f1d850d7d2",
        "upstream/ProbabilityTheory/chapter_08/thm_8_6.lean": "6bdefb8b6d56ede91290d4b5cabf2be96badb792b177178ceb9813b9ade0330a",
        "upstream/ProbabilityTheory/chapter_10/def_10_4.lean": "3a1acf25daa209a89fc590bb47e562fccd83051433688af7a1383512f637bc24",
        "upstream/ProbabilityTheory/chapter_10/def_10_5.lean": "eddf0d56154ef3104ab5fc2852c1fdae85d39da52d8baa5ce6486aba702d762a",
        "upstream/ProbabilityTheory/chapter_10/ex_10_3_1.lean": "90ec14c6ebf589763e63b7afe24ddb71d693b704ee4f82acaf1228b3f67578bb",
        "upstream/ProbabilityTheory/chapter_10/thm_10_6.lean": "2572f91885ca57222a32a058ddf665174438756581f2739ddc149ae15047d38d",
        "upstream/ProbabilityTheory/chapter_13/thm_13_5.lean": "1f873b33c7c446e3f9840896c8a4362eb1fa1757e96a8a5be39774652e4d2edc",
        "upstream/ProbabilityTheory/chapter_14/def_14_1.lean": "5f6fad3aea7270b16c5b339f2535a4d1777b72f43073ad01a32658f458144cc1",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4.lean": "921416e3fbe6525b2e87e6b88f1ab42fcb87c7757f4fda5568c74ae73dcf1f47",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_density_support.lean": "08b047e2251579d907798fbdee67e11a33a6b258cc0a4150a90b9a9460ad6ccb",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_dominating_measure.lean": "f5a1f21acd9e1a37c2f445acb4f9d64b33b1442151b6fa90f18c00a0cf43ddfe",
        "upstream/ProbabilityTheory/common_support/tv_distance_core.lean": "b05b2b4d9b460fd9be5d1a3d4327ed6642ff0aa96a88b65ff2aa577987f80881"
      }
    },
    {
      "private_source_arm": "C",
      "case": "ROOT/ep-bc-l3-c\\development-ac-r1\\cases\\5b273faa031edeeab7424ef676fb0bcb9d7040aad2c4887125328b2d5c495b2b",
      "original_decision": "ROOT/ep-bc-l3-c\\development-ac-r1\\cases\\5b273faa031edeeab7424ef676fb0bcb9d7040aad2c4887125328b2d5c495b2b\\final\\decision.json",
      "original_verdict": "pass",
      "decision_sha256": "a9584a6d9444728bca11afe8d93cd698b71f90db8e77cc7504a7ea5e6a68c08b",
      "subject_files_sha256": {
        "source/SOURCE.tex": "db9b1054cdd6029537037157fb0a187503d2ab35f9021ea9f6a61d57152cc614",
        "task_contract/COMMON_RULES.zh-CN.md": "640e3fe538afea156b97e1766290be0b662486e5ff247af69c9f587f0a2a7949",
        "task_contract/TASK.zh-CN.md": "b0c4dd2ccfb79f00537b98c83af82810a1fb78cac3bbaa09b37f719081acfb16",
        "tool_fact/technical-validation.json": "7fb7cfa779396568c328ead65819e39ba52e75b753244e795610eb9bcb0bf98c",
        "candidate/ProbabilityTheory/chapter_07/prob_7_6.lean": "25ac85093f03845e5588731b8e2135d9493d543280d662e22cf05549ec53c3ef",
        "candidate/ProbabilityTheory/chapter_10/ex_10_3_2.lean": "701d35d4461cefa4835b99ec60d60d9ece41411deae08bd78d5e918964eefbc3",
        "candidate/ProbabilityTheory/common_support/scheffe.lean": "e503cd27d3d2c89826bdd06415deb9c6772d9cbad91e1815b5d9d55350046bac",
        "upstream/ProbabilityTheory/chapter_07/thm_7_11.lean": "d426c39e02bb1c0021872b986bcb5efef4201f01fcfd7f0d836cecf367a04b68",
        "upstream/ProbabilityTheory/chapter_08/def_8_5.lean": "f1eabbdb8039dcb106bf5c1d2e45cb19709c5e09e1a646dd8a9ec5a7d2485963",
        "upstream/ProbabilityTheory/chapter_08/prob_8_7.lean": "e519469e0774622e346298e4302f07f3a1ecbac0ce9a0d5d3ca598f1d850d7d2",
        "upstream/ProbabilityTheory/chapter_08/thm_8_6.lean": "6bdefb8b6d56ede91290d4b5cabf2be96badb792b177178ceb9813b9ade0330a",
        "upstream/ProbabilityTheory/chapter_10/def_10_4.lean": "3a1acf25daa209a89fc590bb47e562fccd83051433688af7a1383512f637bc24",
        "upstream/ProbabilityTheory/chapter_10/def_10_5.lean": "eddf0d56154ef3104ab5fc2852c1fdae85d39da52d8baa5ce6486aba702d762a",
        "upstream/ProbabilityTheory/chapter_10/ex_10_3_1.lean": "90ec14c6ebf589763e63b7afe24ddb71d693b704ee4f82acaf1228b3f67578bb",
        "upstream/ProbabilityTheory/chapter_10/thm_10_6.lean": "2572f91885ca57222a32a058ddf665174438756581f2739ddc149ae15047d38d",
        "upstream/ProbabilityTheory/chapter_13/thm_13_5.lean": "1f873b33c7c446e3f9840896c8a4362eb1fa1757e96a8a5be39774652e4d2edc",
        "upstream/ProbabilityTheory/chapter_14/def_14_1.lean": "5f6fad3aea7270b16c5b339f2535a4d1777b72f43073ad01a32658f458144cc1",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4.lean": "921416e3fbe6525b2e87e6b88f1ab42fcb87c7757f4fda5568c74ae73dcf1f47",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_density_support.lean": "08b047e2251579d907798fbdee67e11a33a6b258cc0a4150a90b9a9460ad6ccb",
        "upstream/ProbabilityTheory/chapter_14/thm_14_4_dominating_measure.lean": "f5a1f21acd9e1a37c2f445acb4f9d64b33b1442151b6fa90f18c00a0cf43ddfe",
        "upstream/ProbabilityTheory/common_support/tv_distance_core.lean": "b05b2b4d9b460fd9be5d1a3d4327ed6642ff0aa96a88b65ff2aa577987f80881"
      }
    }
  ]
}
```

## A15 — L3_PRE_EVALUATION_SCOPE_ADDENDUM_R1.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L3_PRE_EVALUATION_SCOPE_ADDENDUM_R1.json`

原 SHA-256：`5b90a4b7fff828e42faccb797562ca4917b2d71999ff8943c0503df2380404e4`

范围：`(whole object)`

[包内摘录](sources/A15.json)；包内 SHA-256：`b542efd6fe127d730faffee9ef558b5e0d175456a132836439c9f74ccb8eb7fd`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789131485.333638,
  "rule": {
    "version": "L3-integral-domain-sensitivity-r1",
    "original_rule_quote": "合同允许采用最终尾部可积表述",
    "readings": {
      "F_finite_real_integral_sequence": "Interpret the displayed integral convergence as a real-valued sequence of finite integrals. Then individual integrability is part of that convention; assess the rest of the original theorem and density/Gaussian obligations independently.",
      "E_nonnegative_extended_integrals": "Nonnegative measurable inputs have extended integrals; convergence to a finite limit implies only eventual integrability, allowing finitely many infinite initial integrals. A source-scope public theorem must close this tail reduction rather than require all terms integrable."
    },
    "required_separation": [
      "correctness of the theorem under explicitly stated premises",
      "source-domain convention for integral sequence",
      "public interface closure or missing tail wrapper",
      "all general density and Gaussian positive/zero-variance obligations"
    ],
    "composition": "Both readings applied to all three candidates; retain original labels. Do not infer mathematical falsity from a stronger interface. If source-domain convention changes acceptance, mark criterion_dispute and retain both sensitivity labels.",
    "obligations": {
      "P1": "Scheffe定理在自身明确前提下的数学陈述和证明正确性。",
      "P2": "源积分定义域与逐项/最终尾部可积的公共接口，分别依F/E解释判断。",
      "P3": "极限函数可测、几乎处处/处处非负，源文与已交付任务书的差别；有无实际代表元或几乎处处包装。",
      "P4": "从非负性与几乎处处收敛建立负部/最小值控制并应用支配收敛。",
      "P5": "从积分收敛闭合绝对差积分趋零，不假定最终L1结论。",
      "D1": "一般概率密度，包括极限仍是密度及几乎处处收敛条件。",
      "D2": "实际由Scheffe闭合分布全变差趋零。",
      "D3": "由全变差推依分布收敛及公开接口。",
      "N1": "原正态参数收敛和参数边界，是否额外加强公共前提。",
      "N2": "极限正方差的密度/全变差或等价证明完整闭合。",
      "N3": "零方差极限到点质量的弱收敛，不误称全变差收敛。",
      "I1": "所有必需文件、端点、支持和依赖真实闭合，无循环、sorry或额外公理。"
    },
    "registration_context": "看过旧结果后的敏感性登记，发生在本批新重评前，不是原实验前预注册。",
    "source_convention_limit": "F是需要单独检验源文依据的有限积分解释。若交付源材料无该约定，必须写为回顾性敏感性假设，不能凭Lean实值积分语法推断各项可积。TASK明确允许最终尾部表述这一事实始终保留。",
    "independent_scope": "逐项可积行为相同不等于所有公开前提相同，更不预定整组标签相同。对每份候选分别核极限可测、处处/几乎处处非负及实际包装。",
    "dimension_semantics": {
      "mathematics": "定理在自身明确前提下正确性",
      "public_premises": "除P2积分定义域敏感性外的公共前提是否获交付源文/任务许可，差异须明确归因",
      "route_F_E": "对应解释的源范围与必须承担的证明义务是否闭合",
      "interface": "必需接口存在且真实接入；P2范围单列，避免机械重复归罪",
      "delivery": "完整一般密度和正态分支及允许支持"
    },
    "composition_rule": "各解释按数学、非P2公共前提、对应路线、接口、交付及全部逐义务状态合成；任何fail则该解释fail，否则有unresolved则unresolved，否则pass。解释改变标签则判据争议。F无冻结源依据必须明确其条件性，不成为唯一真实标签。"
  },
  "original_registration_sha256": "a00d1718a78295bfe7d513fe02db51db37b2ab5b82eaf7737bb26698880d39e4",
  "new_model_calls": 0
}
```

## A16 — L3_TASK_TAIL_READING_REGISTRATION_R1.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L3_TASK_TAIL_READING_REGISTRATION_R1.json`

原 SHA-256：`9f67d1317928b651ca7af1503d081378b9339717080a92b15d886963f9fdde8b`

范围：`(whole object)`

[包内摘录](sources/A16.json)；包内 SHA-256：`50d83c4e4fd6d75919cb4534fe8877dda89dd90915d23b7ed07ffcd37c273ee1`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789132828.4034493,
  "version": "L3-task-tail-sensitivity-r1",
  "registered_after_observed_original_F_E_reviews": [
    {
      "path": "ROOT/rr-l3-v1\\candidate-6d87e44415de\\executions\\reviewer-1\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "cd092248138611b3e20efb2aeeaff14089e51d99225747d8c7394a36d6d3b2bb"
    },
    {
      "path": "ROOT/rr-l3-v1\\candidate-6d87e44415de\\executions\\reviewer-2\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "9daa300077d44fef0a34d8c765ab68b8f637a2a6bd199dcd07a54644a2d3c5fa"
    },
    {
      "path": "ROOT/rr-l3-v1\\candidate-b299284a15fd\\executions\\reviewer-1\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "8d2762cfb26d36758ecaaeb1a5a4f4744ffc8621d142987fd46970b525448bc5"
    },
    {
      "path": "ROOT/rr-l3-v1\\candidate-b299284a15fd\\executions\\reviewer-2\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "68a135723e60c9a7afae33ce80a252d62e2ec8942bd137c7a00687d9a86658c2"
    },
    {
      "path": "ROOT/rr-l3-v1\\candidate-ca86a7f5709c\\executions\\reviewer-1\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "8a1db1f735002c65a97886fafb946650c8ec94092d95572334f8d6901226958f"
    },
    {
      "path": "ROOT/rr-l3-v1\\candidate-ca86a7f5709c\\executions\\reviewer-2\\attempt-01\\REVIEW_RESULT.json",
      "sha256": "0d0c860962b2b8f94e6e90f0182174840a1565f322670b5bb3549f6de0e88361"
    }
  ],
  "not_original_preregistration": true,
  "original_rules_and_reviews_unchanged": true,
  "trigger": "Initial F/E reviews exposed that E demands an extended-integral-to-eventual-integrability wrapper even when a candidate uses the eventual-integrability formulation expressly permitted by TASK. Preserve E as strict source-scope sensitivity; do not silently impose it as the only original TASK acceptance rule.",
  "quoted_original_task": "合同允许采用最终尾部可积表述",
  "interpretations": {
    "F": "Existing finite-integral-sequence convention; conditional retrospective sensitivity unless frozen source supports it.",
    "E": "Existing exact nonnegative extended-integral source scope including derivation of eventual integrability; preserve all initial results.",
    "T_task_permitted_eventual_tail": "Read the delivered TASK permission literally: explicit eventual integrability of the sequence and integrability of its limit may be used as the tail formulation of finite integral convergence, with the real integral convergence condition still required. Candidate must actually prove the negative-part/minimum control and L1 limit for that eventual-tail domain. Requiring every initial term integrable without a real eventual-tail wrapper does not cover this T domain. Never assume L1 convergence itself."
  },
  "other_scope_obligations": "Source-vs-TASK limit measurability and nonnegativity, public wrappers, general densities and Gaussian positive/zero cases remain independently assessed. Equal P2 behavior does not force equal overall labels.",
  "assessment_plan": "All four known original L3 candidates, including historical B, receive the same F/E/T scope in their at-most-one necessary fresh Sol-medium adjudication after all independent F/E reviews finish. This resolves the newly exposed rubric conflict as well as any single-case disagreements/format failures. No solver call, candidate edit, or repeated adjudication.",
  "final_reporting": "Original verdict, independent F/E results, adjudicated F/E/T results and timing of this scope revision remain separate. Comparison is criterion_dispute when acceptance depends on interpretation. No highest-pass-rate interpretation selection.",
  "new_solver_trials": 0
}
```

## A17 — L7_CONTRACT_DIAGNOSIS.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L7_CONTRACT_DIAGNOSIS.json`

原 SHA-256：`39322119f4fc1c34e9c6078b173bd94722b4a3d6a14c95228795754040e061e0`

范围：`(whole object)`

[包内摘录](sources/A17.json)；包内 SHA-256：`f1c3c567fabaa71831fc034073644a17f4a0587edc851c8a65f5f168963fd0f4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789130297.9921262,
  "status": "contract_defect_verified_on_paper; revised solver contract proposed_not_applied",
  "original_task": {
    "path": "ROOT/c-r3-inputs\\L7_thm_10_10_to_10_11\\ProbabilityTheoryFormalization\\TASK.zh-CN.md",
    "sha256": "6d89cf3fb8332d11bbd7a3908277a7d5fb13da91e5413a039335fc032bface24"
  },
  "original_source": {
    "path": "ROOT/c-r3-inputs\\L7_thm_10_10_to_10_11\\ProbabilityTheoryFormalization\\SOURCE.tex",
    "sha256": "0f54fe8e24f7b3119ed37efab39907fbea5a4b41c5de8c1f20de3b1777520c91"
  },
  "independent_method_delivery": {
    "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\diagnostics\\method_consistency_review_20260911\\DELIVERY.json",
    "sha256": "c1a18b60da9f286f52d37abb340c7bc7727edeefeefce7a24f4d4ae12265bd66",
    "all_six_files_verified": true
  },
  "separate_obligations": {
    "ambient_continuity": "ContinuousAt at each point of S, involving approaches from the full ambient space",
    "relative_continuity": "ContinuousOn restricted to S; insufficient for approaches Vn outside S",
    "input_measurability": "V and each Vn are measurable random vectors",
    "output_measurability": "Original task explicitly asks for f(V) and every f(Vn) measurable, but lacks a sufficient global f assumption",
    "convergence": "Numerical or filter convergence must be assessed separately from whether outputs are random vectors",
    "event_measurability": "Almost-everywhere membership and in-probability event/control measurability require explicit justified use, not silent identification"
  },
  "counterexample_measurability": {
    "sample_space": "[1,2] with completed Lebesgue probability measure",
    "E": "A non-Lebesgue-measurable subset of [1,2]",
    "f": "Real-domain indicator of E, zero outside E",
    "S": "{0}",
    "V": "Constant zero",
    "Vn": "V1 is identity on [1,2]; Vn=0 for n>=2",
    "verified_steps": [
      "All input random variables are measurable.",
      "Vn converges pointwise and hence almost surely to V.",
      "V lies in S everywhere.",
      "f is identically zero on a neighborhood of 0, so ContinuousAt f 0 holds in the ambient topology.",
      "The inverse image of {1} under f(V1) is E, so f(V1) is not measurable.",
      "Finite exceptional initial indices do not prevent numerical convergence but violate an every-output measurability obligation."
    ],
    "conclusion": "Original explicit conditions cannot guarantee every composite output measurable, even under ambient continuity at S.",
    "not_claimed": [
      "No new Lean counterexample was built.",
      "This example does not make f(V) nonmeasurable: f(V)=0.",
      "This does not by itself refute a correctly formulated numerical convergence theorem."
    ]
  },
  "counterexample_relative_continuity": {
    "f": "f(0)=0 and f(x)=1 for x!=0, a Borel measurable function",
    "S": "{0}",
    "Vn": "Constant 1/n for positive n",
    "V": "Constant zero",
    "conclusion": "Relative ContinuousOn f S holds, but f(Vn)=1 does not converge to f(V)=0. Adding Borel measurability alone does not fix an interpretation using only relative continuity."
  },
  "source_convention_search": {
    "frozen_target_SOURCE": "No explicit global measurability assumption for f.",
    "bounded_catalog_context": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\diagnostics\\method_consistency_review_20260911\\FROZEN_CATALOG_CONTEXT.json",
    "scope": "Independent audit searched 78 fixed plans / 655 entries and read relevant chapter 4 and 10 context; no explicit all-deterministic-functions-are-Borel-measurable convention found.",
    "limit": "Not an exhaustive search of the published book; extra context is not retroactively treated as delivered solver input."
  },
  "scoring_responsibility": {
    "original_written_delivery": "Record whether the candidate actually delivered the written output-measurability obligation; retain original fail when present.",
    "contract_realizability": "Record that the universal output guarantee is unsupported by the explicit original assumptions.",
    "mathematics": "Assess proved convergence claims under their stated conditions separately.",
    "comparison": "Original L7 is diagnostic and ineligible for configuration ranking pending a valid common contract; do not convert original fail to pass automatically."
  },
  "revision": {
    "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\L7_CONTRACT_REVISION_DRAFT.zh-CN.md",
    "sha256": "e218547d06615db7d799a73f9d641978a988d15c6f62cae7c871d71099ba6688",
    "changes": [
      {
        "old": "No global f measurability assumption",
        "new": "Explicit Borel Measurable f",
        "kind": "new_hypothesis"
      },
      {
        "old": "Continuous on S ambiguous between relative and ambient readings",
        "new": "ContinuousAt f x for every x in S in ambient topology",
        "kind": "explicit_interpretation_and_condition"
      },
      {
        "old": "Probability V belongs to S equals one, with event measurability implicit",
        "new": "Almost-everywhere membership in S",
        "kind": "explicit_probability_semantics"
      }
    ],
    "applied_to_inflight_or_queued_original_inputs": false,
    "new_condition_solver_calls": 0,
    "new_trials_need_separate_equal-condition_plan": true
  },
  "old_candidate_policy": "Keep original A partial, A repair, and original-condition B/C trials distinct; no diagnosis or other-arm answers are sent to any solver."
}
```

## A18 — L2_REASSESSMENT_PLAN.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L2_REASSESSMENT_PLAN.json`

原 SHA-256：`ebf820b88bb18bd45958cbc66ab9418c4d413ba2546adbd395822845835a7066`

范围：`(whole object)`

[包内摘录](sources/A18.json)；包内 SHA-256：`77ebe6c76f26c2e151aaa6b38f4229fd52a911155575599e99eb37440531cdef`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## A19 — L3_REASSESSMENT_PLAN.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\L3_REASSESSMENT_PLAN.json`

原 SHA-256：`e25460843cb0fba0cafa181bc6e9ce4a62ddad96936c93aaad5a40f758cd28ab`

范围：`(whole object)`

[包内摘录](sources/A19.json)；包内 SHA-256：`80e511c6496008e77d1bcc185cc86070caebf384f97f2a3b676607fa499e55e0`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## A20 — H1_REASSESSMENT_PLAN.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\H1_REASSESSMENT_PLAN.json`

原 SHA-256：`79621f191232848a7108a9ff90f6a7e1476c23456f5f0d1276d257f3a9602b80`

范围：`(whole object)`

[包内摘录](sources/A20.json)；包内 SHA-256：`ab891a9c46df13828f65b2378ecd85be4a4f7a9644c541cf094afbd974c96762`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## A21 — H1_ADJUDICATION_PLAN.json

命名空间：`consistency r1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\H1_ADJUDICATION_PLAN.json`

原 SHA-256：`fb46202d2139deccdc4881b15c76bce58d5c4887604cfa32e928235b817c737e`

范围：`(whole object)`

[包内摘录](sources/A21.json)；包内 SHA-256：`d1a9fca2f20cc9fdbce7305097e4c800456533297197298444f407656ba53a12`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## A30 — X003_ATTRIBUTION_AND_SCOPE.json

命名空间：`X003`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X003_ATTRIBUTION_AND_SCOPE.json`

原 SHA-256：`5c4fe791161e740d30b509a779f90c273cd4257842bf79c733878e206238ba22`

范围：`(whole object)`

[包内摘录](sources/A30.json)；包内 SHA-256：`626393b360e74a242195aace323b4c4d03b659b07f87fe2bf2b47ad2124bc062`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789160951.5379758,
  "A_repair_external_endpoint_reviewer_1": {
    "path": "ROOT/ep-a-l7-repair-r1\\development-ac-r1\\cases\\1726295c45eec3a9196cdc2f86afa5fbd8df79ff79284727b88e767642a6ac0f\\results\\reviewer-1.json",
    "sha256": "3b32d46275ef498a3f1a55ab2cf4739ef74aaaf2e96c273b746086e544946d3d",
    "completed_at_utc": "2026-09-11T09:05:49.116756+00:00",
    "confidence": 0.98,
    "exact_public_premise_assessment": "候选没有把复合收敛或复合可测性直接增加为公开前提，输入可测性、逐点连续性和极限落入 S 的概率为一均符合题意。然而问题并非增加前提，而是公开结论未要求复合输出可测，从而迁弱了目标。仅凭 f 在 S 中各点连续且 V 几乎处处落入 S，也不能一般推出每个 f ∘ Vn 在 Vn 可于 S 外取值时可测；候选既未补充足以推出该性质的合法路线，也未把该义务纳入结论。",
    "recognizes_original_conditions_insufficient": true
  },
  "A_internal_first_identification": "not investigated; unknown",
  "C_contribution": "Delivered explicit correction and kept almost-sure numerical core without Measurable f; not claimed first discovery across project.",
  "B_followup_source": {
    "path": "ROOT/reports\\trajectory_analysis\\team_review_v031_trajectory_v3_20260911\\followup_textbook_20260912\\B_FAILURE_REVIEW.zh-CN.md",
    "sha256": "47b49d8d1601f3e8a24a9e83e9be1afb1ba16005b45f92ac7eac9f5b8e34fdb9",
    "nature": "Integrator read-only evidence analysis; not a new valid endpoint/model re-evaluation."
  },
  "B_consistency": {
    "L7": "Same reasonable global-measurability correction standard applies to B/C. B support theorems deliver composition measurability. B additionally requires MeasurableSet S; C only preimage event measurability or ae membership.",
    "H1": "Book table 9.1 describes zero-center arbitrary scale, supporting B covered textbook context; missing arbitrary location remains separate Family limitation, not uniquely mandated original reading. r1 format unresolved preserved.",
    "L3": "All-term integrability and absent general eventual-tail wrapper are real scope/interface gap. Already proved results are not thereby mathematically false. r1 format unresolved preserved."
  },
  "new_B_model_calls": 0,
  "no_historical_label_overwrite": true
}
```

## A31 — X012_FINAL_SCOPE_CLARIFICATION.json

命名空间：`X012`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X012_FINAL_SCOPE_CLARIFICATION.json`

原 SHA-256：`621d9486769ac4c4663e67b665b9e49789dbcde8bb5068d704247fa8b6a99ca1`

范围：`(whole object)`

[包内摘录](sources/A31.json)；包内 SHA-256：`c75390420457c47a40c9c6d87f61d49147751255a5d765d17c4d08cb6ff89816`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "schema": "targeted.final.scope_clarification.v2",
  "completed_at": "2026-09-12T05:17:25.132165+08:00",
  "authorization": "Final integration clarification received after the two reviews returned; reviewer prompts and outputs unchanged. Reuse only; no new A/B evaluations.",
  "A_original": {
    "case": "ROOT/ep-a-stage-l7\\development-ac-r1\\cases\\a5ef5c2f70ca8ec650cd55ef69e1ea9bb0f37cc956f22c4dd8115aa4740df669",
    "decision_sha256": "3a03f032e3c625aa7464c14fb99c6c3903cef8240b6fe74a6fb4e733b89cc72a",
    "historical_verdict": "fail",
    "missing_thm_10_11_target_file_verified": true,
    "classification": "missing full second target; justified incomplete delivery; not re-evaluated"
  },
  "A_repair": {
    "case": "ROOT/ep-a-l7-repair-r1\\development-ac-r1\\cases\\1726295c45eec3a9196cdc2f86afa5fbd8df79ff79284727b88e767642a6ac0f",
    "sources": [
      {
        "slot": "reviewer-1",
        "path": "ROOT/ep-a-l7-repair-r1\\development-ac-r1\\cases\\1726295c45eec3a9196cdc2f86afa5fbd8df79ff79284727b88e767642a6ac0f\\results\\reviewer-1.json",
        "sha256": "3b32d46275ef498a3f1a55ab2cf4739ef74aaaf2e96c273b746086e544946d3d",
        "original_verdict": "fail",
        "summary": "thm_10_10 的两个双向等价以及 thm_10_11 的收敛事件控制均有有效证明，范数双向控制、有限坐标满测合并、概率并集界、连续点满测集与紧集一致连续路线也已落实。但完整候选没有证明或公开要求 f ∘ Vn 与 f ∘ V 的可测性，借助不含随机向量可测性条件的上游收敛谓词形成了实质性目标弱化。该缺口正中任务书明确义务，故整束任务不能共同确认完成。",
        "proof_route_assessment": {
          "assessment": "范数控制、有限并集、满测集以及紧集一致连续路线在数学上有效，且属于教材路线的等价实现。主要缺口不在收敛事件估计，而在复合函数随机向量资格完全未进入证明或结论。",
          "escape_assessment": "未见 sorry、admit、新增 axiom、私有公理或把目标结论换名封装成不透明前提的证据；但通过使用不含输出可测性的向量收敛谓词，实质上绕开了任务书的一项必要义务。",
          "new_support": [
            {
              "assessment": "合法且直接证明单坐标范数控制。",
              "declaration": "abs_apply_le_vectorEuclideanNorm"
            },
            {
              "assessment": "合法且为有限坐标到向量的控制提供充分界。",
              "declaration": "vectorEuclideanNorm_le_sum_abs"
            },
            {
              "assessment": "合法地把有限坐标的共同几乎处处收敛转为向量收敛。",
              "declaration": "coordinatewiseAETendsto_to_vector"
            },
            {
              "assessment": "从公开坐标收敛谓词推出共同满测结论，未引入额外公理。",
              "declaration": "coordinatewiseAlmostSurely_to_vector"
            },
            {
              "assessment": "合法使用有限坐标和及并集界。",
              "declaration": "coordinatewiseDeviationTendsto_to_vector"
            },
            {
              "assessment": "只是对前述充分条件的合法封装。",
              "declaration": "coordinatewiseInProbability_to_vector"
            },
            {
              "assessment": "合法连接函数空间默认上确界范数与显式欧氏范数。",
              "declaration": "piNorm_le_vectorEuclideanNorm"
            }
          ],
          "status": "partially_valid"
        }
      },
      {
        "slot": "reviewer-2",
        "path": "ROOT/ep-a-l7-repair-r1\\development-ac-r1\\cases\\1726295c45eec3a9196cdc2f86afa5fbd8df79ff79284727b88e767642a6ac0f\\results\\reviewer-2.json",
        "sha256": "c3de87d2c8a2071891fd54e46a4bea20a4ae990331f680c52e12bcdc41ea6e74",
        "original_verdict": "fail",
        "summary": "定理 10.10 的逐坐标等价及其范数、满测集和有限并集义务得到有效证明；定理 10.11 也正确处理了只在满测极限集合上连续时的数值收敛控制。然而，候选利用上游向量收敛定义不携带可测性的弱接口，既未证明也未在结论中要求复合输出是随机向量，直接遗漏任务书明确指定的复合输出可测性义务。因此完整候选不能通过共同终验。",
        "proof_route_assessment": {
          "dependencies_and_support": "新增支持均位于两个候选目标文件内，包括欧氏范数与坐标/和式控制、逐坐标几乎处处收敛合成向量收敛、逐坐标偏差合成向量依概率收敛以及上确界范数到欧氏范数的控制。路线使用了给定上游定义和 Mathlib 的测度、有限和、映射测度、紧集逼近及一致连续性结果；未见新增外部支持文件。",
          "status": "partially_valid",
          "thm_10_10": "证明路线数学上有效。两条范数控制足以替代教材中的 ε/√d 估计；有限和趋零及有限并集测度界完成依概率方向，属于合同允许的等价路线。",
          "thm_10_11": "数值收敛路线数学上有效：先把 S 包含到 f 的连续点集合 C，证明 V 落入 C 几乎处处，再以极限分布在 C 上的紧集逼近和紧集上的一致连续性控制输出偏差。这是连续映射定理的合法等价路线。但它只证明任意输出偏差集合的测度趋零，未补足输出作为随机向量的可测性。"
        }
      }
    ],
    "technical_facts_sha256": "77df541c079c3777b7938e79a8564ede7543e8ed5f88b609b48c3a5ae2fa1029",
    "target_source_identity_verified": true,
    "three_distinct_findings": {
      "numerical_convergence_under_explicit_interface": "supported_correct_by_both_existing_reviews_and_build",
      "composition_measurability_delivery": "not_delivered",
      "original_conditions": "insufficient_to_derive_every_composition_measurable"
    },
    "historical_verdict_preserved": "fail",
    "no_new_overall_pass": true
  },
  "research_interpretation": {
    "user_hypothesis": "Most models basically passed, including H1-B, leaving trajectory evaluation.",
    "status": "hypothesis constrained by evidence, not a required review verdict",
    "supported_direction": "Shift analytical attention toward trajectories, effort, diagnosis, revisions, disclosure and delivered scope, since many apparent failures concern criteria or contract defects.",
    "counterconstraints": [
      "A original L7 lacks full second target",
      "B L3 lacks general eventual-tail wrapper",
      "Invalid evaluations remain unresolved",
      "Mathematical validity, reasonable repairs and literal original contract are distinct",
      "No exhaustive all-model mathematical-success census was performed in this limited reassessment"
    ]
  },
  "new_model_calls": 0,
  "new_solver_calls": 0
}
```

## A32 — X020_NEW_RESOURCE_LEDGER.json

命名空间：`X020`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X020_NEW_RESOURCE_LEDGER.json`

原 SHA-256：`3cb2917c2361b021cb56b868573fa2cf250c5ce441db0e03bf561429d084bea7`

范围：`(whole object)`

[包内摘录](sources/A32.json)；包内 SHA-256：`3e14d1568b801d1438798f152c87b052bb3da4e90cd6c1182de2efd79c179798`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789161182.16685,
  "new_semantic_calls": 2,
  "new_solver_calls": 0,
  "L2_new_model_calls": 0,
  "L7_initial_calls": 2,
  "L7_adjudication_calls": 0,
  "max_authorized_calls": 3,
  "actual_receipts": [
    {
      "slot": "reviewer-1",
      "conceptual_role": "reviewer-1",
      "receipt_path": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-1\\attempt-01\\actor\\actor-receipt.json",
      "receipt_sha256": "3a0d484de0e7778e642783bb2beb95e5a1a709ee7f355f054dbb69134705b406",
      "dispatch_id": "f54e4fb3-cdc7-4053-9833-b5b339c310ba",
      "session_ids": [
        "01a0924c-46c3-74e0-b91c-567e4b0b36a7"
      ],
      "model": "gpt-5.6-sol",
      "reasoning_effort": "medium",
      "usage": [
        {
          "input_tokens": 551752,
          "cached_input_tokens": 478720,
          "output_tokens": 8023
        }
      ],
      "process": {
        "elapsed_seconds": 217.56300000002375,
        "exit_code": 0,
        "timed_out": false,
        "error": null
      },
      "deadline": {
        "allowance_seconds": 1800.0,
        "started_epoch": 1789160863.9467182,
        "deadline_epoch": 1789162663.9467182,
        "remaining_seconds": 1582.3791539669037
      },
      "usd": null,
      "assessment_accepted": true,
      "format_issues": []
    },
    {
      "slot": "reviewer-2",
      "conceptual_role": "reviewer-2",
      "receipt_path": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-2\\attempt-01\\actor\\actor-receipt.json",
      "receipt_sha256": "dd94b7fb4d03f3b0e3200954b93a64ca0a48ea2a3c91b4bd18ed6b93339e8f80",
      "dispatch_id": "f0df99e3-60da-42ad-8135-8c54e3aa8a69",
      "session_ids": [
        "01a0924c-46c3-7ee0-9fe0-33e83ba3c213"
      ],
      "model": "gpt-5.6-sol",
      "reasoning_effort": "medium",
      "usage": [
        {
          "input_tokens": 874005,
          "cached_input_tokens": 776192,
          "output_tokens": 9286
        }
      ],
      "process": {
        "elapsed_seconds": 263.43800000002375,
        "exit_code": 0,
        "timed_out": false,
        "error": null
      },
      "deadline": {
        "allowance_seconds": 1800.0,
        "started_epoch": 1789160862.992587,
        "deadline_epoch": 1789162662.992587,
        "remaining_seconds": 1536.4662644863129
      },
      "usd": null,
      "assessment_accepted": true,
      "format_issues": []
    }
  ],
  "usage_totals": {
    "input_tokens": 1425757,
    "cached_input_tokens": 1254912,
    "output_tokens": 17309
  },
  "usage_limitations": "Missing USD or reasoning-token counts are unavailable, not zero; cached input is a subset of input. These are actor receipt counters, not price estimates.",
  "evaluator_elapsed_sum_seconds": 481.0010000000475,
  "original_build_reused": true,
  "new_builds": 0
}
```

## A33 — X027_RESOURCE_AUDIT.json

命名空间：`X027`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X027_RESOURCE_AUDIT.json`

原 SHA-256：`ffc38c5a90e8582c0cc413942e49f3c08039e0d55289ed5c5195e8b0a56d0fe1`

范围：`(whole object)`

[包内摘录](sources/A33.json)；包内 SHA-256：`f494135105906c59ca704f6754600d2c510bce1b497a75364c2393c5732fe110`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789161182.16633,
  "successful_samples": 62,
  "monitor_errors": [],
  "max_active_observed": 2,
  "max_sample_gap_seconds": 5.520411491394043,
  "atomic_event_counts": {
    "overlay_installed": 6,
    "transition_queued": 4,
    "mutation_returned": 4
  },
  "over_limit_events": [],
  "guard_errors": [],
  "containers_stopped": true,
  "all_global_active_containers_at_cutoff": [],
  "containers": [
    {
      "slot": "reviewer-1",
      "container_id": "40d0ed8737137f160eb3b6184975f20f5dc35a348214bd436a50d7ca385e15bb",
      "image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
      "readonly_input": true,
      "image_library_unoverridden": true,
      "source": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-1\\attempt-01\\container-inspect.json",
      "sha256": "7b1912a50d73b7a1f300a0209705f8fc91d321f32690e1675afa1544991c83b7"
    },
    {
      "slot": "reviewer-2",
      "container_id": "56e0c539cd997adabba5bcf3683d55de8d8c124e1e1d4af11f1f8c851cfa4280",
      "image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
      "readonly_input": true,
      "image_library_unoverridden": true,
      "source": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-2\\attempt-01\\container-inspect.json",
      "sha256": "d63952d013996242928589ac8692ccdcfccc2234fe5c0221978b65c01160e224"
    }
  ],
  "original_technical_image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
  "subject_unchanged": true,
  "original_L7_case_all_files_unchanged": true,
  "previous_17_files_unchanged": true,
  "r1_final_bound_files_unchanged": 43,
  "reused_technical_output_hashes_verified": true,
  "limitations": [
    "Periodic samples are observations; atomic guarded transitions are separate evidence.",
    "Only this r2 evaluation is costed here; no old solver/evaluation costs are recounted."
  ]
}
```

## A34 — X053_REVIEW_RESULT.json

命名空间：`X053`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X053_REVIEW_RESULT.json`

原 SHA-256：`22cab367bfc9d3ee5892916743cdea2da87e8ff597091c717fb2886f507c880f`

范围：`(whole object)`

[包内摘录](sources/A34.json)；包内 SHA-256：`d9f11410aa816d7d68ac7c77223fd59e788dd1abee9cc0bf075558828c44b77e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789161082.1477065,
  "candidate_id": "candidate-3e81b8500999",
  "slot": "reviewer-1",
  "assessment": {
    "schema": "targeted.l7.review.v2",
    "request_id": "l7-r2-candidate-3e81b8500999-reviewer-1",
    "candidate_id": "candidate-3e81b8500999",
    "role": "reviewer",
    "confidence": 0.97,
    "dimensions": {
      "mathematics": {
        "status": "pass",
        "reason": "M1–M6均成立。10.10的双向证明包含坐标可测性推导、满测交、有限并界和零维分支；10.11的范数桥、严格/非严格阈值、零维、满测集转换及子序列—子子列证明均在其公开前提下正确。构建、公理及逃逸扫描事实与所读源码哈希一致。"
      },
      "repair_reasonableness": {
        "status": "pass",
        "reason": "原条件确实不能保证全部复合输出可测；加入函数级Borel可测性是充分而非唯一或最弱的合理修正。交付还正确区分了环境空间ContinuousAt与相对ContinuousOn，并将无函数可测性的数值收敛核心和完整随机向量陈述分开。"
      },
      "original_contract": {
        "status": "fail",
        "reason": "原教材和合同没有授予hf : Measurable f这一新增公开前提，而完整定理实际依赖该前提；无此条件仅交付不含复合可测性的几乎处处核心，且完整依概率随机向量命题未交付。合理修正和充分披露不能使原合同通过。"
      }
    },
    "obligations": [
      {
        "id": "M1",
        "status": "pass",
        "reason": "向量到坐标方向由输入可测性推出标量可测性，并在原满测事件上应用连续投影；反向从每个坐标取得可测满测事件，取有限交，再用函数空间逐坐标收敛。Fin 0时指标交为空交，证明仍成立。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 47,
            "line_end": 47,
            "quote": "    refine ⟨fun n => ((coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 70,
            "line_end": 70,
            "quote": "    refine ⟨⋂ i, E i, MeasurableSet.iInter hEmeas, ?_, ?_⟩"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 82,
            "line_end": 82,
            "quote": "      apply tendsto_pi_nhds.2"
          }
        ]
      },
      {
        "id": "M2",
        "status": "pass",
        "reason": "向量偏差控制坐标偏差；反向在d≠0时取ε/d，以欧氏范数不超过绝对值和得到有限并包含，调用有限并界并对有限和取极限；d=0有独立化简。严格偏差事件与≤反证匹配。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 102,
            "line_end": 102,
            "quote": "        (by simpa using abs_coordinate_le_vectorEuclideanNorm (Vn n ω - V ω) i)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 106,
            "line_end": 106,
            "quote": "    by_cases hd : d = 0"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 145,
            "line_end": 145,
            "quote": "          (prob_2_4_finset_union_bound μ (univ : Finset (Fin d))"
          }
        ]
      },
      {
        "id": "M3",
        "status": "pass",
        "reason": "代码证明上确界范数≤欧氏范数≤d·上确界范数。欧氏严格偏差到TendstoInMeasure非严格事件使用ε/2；反向使用ε/d并将严格不等式弱化为非严格不等式；d=0单独处理。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 15,
            "line_end": 15,
            "quote": "    ‖v‖ ≤ vectorEuclideanNorm v := by"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 23,
            "line_end": 23,
            "quote": "    vectorEuclideanNorm v ≤ d * ‖v‖ := by"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 90,
            "line_end": 90,
            "quote": "    change ε / 2 < vectorEuclideanNorm (Vn n ω - V ω)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 105,
            "line_end": 105,
            "quote": "  by_cases hd : d = 0"
          }
        ]
      },
      {
        "id": "M4",
        "status": "pass",
        "reason": "输入收敛事件和V∈S的几乎处处事件被相交；在每个极限点Vω使用环境空间ContinuousAt复合数值极限，再由零测坏集的可测上集构造接口所需满测事件。该接口本身不携带输出可测性，故结论仅是数值收敛关系，交付对此语义边界的限定准确。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 70,
            "line_end": 70,
            "quote": "    (hcontinuous : ∀ x ∈ S, ContinuousAt f x)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 75,
            "line_end": 75,
            "quote": "  filter_upwards [vectorConvergesAlmostSurely_ae μ hconv, hVS] with ω hω hωS"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 55,
            "line_end": 55,
            "quote": "  obtain ⟨N, hsub, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 61,
            "line_end": 61,
            "quote": "此声明不要求 hf : Measurable f，也不要求 hVn 或 hV。结论仅是 VectorConvergesAlmostSurely 关系；由于该向量接口本身不携带输出可测性，本声明明确不声称复合输出是随机向量。"
          }
        ]
      },
      {
        "id": "M5",
        "status": "pass",
        "reason": "修正版依概率证明先由欧氏偏差桥接到测度收敛，对任意子序列取得几乎处处收敛的子子列，在V∈S处以ContinuousAt传递极限，再由同一Mathlib判别恢复输出的测度收敛并桥接回欧氏偏差。判别所需输出序列强可测性由hf.comp hVn实际推出；最终复合可测性也在正文推出，未作为复合前提。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 138,
            "line_end": 138,
            "quote": "  have houtMeas : ∀ n, AEStronglyMeasurable (fun ω => f (Vn n ω)) μ :="
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 142,
            "line_end": 142,
            "quote": "    rw [exists_seq_tendstoInMeasure_atTop_iff houtMeas]"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 149,
            "line_end": 149,
            "quote": "    exact (hcontinuous (V ω) hωS).tendsto.comp hω"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 167,
            "line_end": 167,
            "quote": "  refine ⟨fun n => hf.comp (hVn n), hf.comp hV, ?_, ?_⟩"
          }
        ]
      },
      {
        "id": "M6",
        "status": "pass",
        "reason": "两个目标的公开证明依赖沿导入闭合：10.10显式复用允许的有限并界、向量定义和坐标可测性定理，10.11只依赖10.10及Mathlib。逐段证明未发现循环、结论偷渡、sorry、admit或新增公理；绑定技术事实报告构建、公理审核和逃逸扫描均为0，且源码哈希与实际读取文件一致。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 2,
            "line_end": 2,
            "quote": "import ProbabilityTheory.chapter_02.prob_2_4"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 2,
            "line_end": 2,
            "quote": "import ProbabilityTheory.chapter_10.thm_10_10"
          },
          {
            "path": "tool_fact/technical-validation.json",
            "line_start": 1,
            "line_end": 1,
            "quote": "\"axiom_audit_exit_code\":0,\"build_exit_code\":0"
          },
          {
            "path": "tool_fact/technical-validation.json",
            "line_start": 1,
            "line_end": 1,
            "quote": "\"escape_scan_exit_code\":0"
          }
        ]
      },
      {
        "id": "R1",
        "status": "pass",
        "reason": "交付反例成立：令V0为[0,1]上的恒等映射而其余Vn及V恒为0，则输入均可测且序列收敛；取位于[1/2,1]内的非勒贝格可测集N及f=1_N，f在0附近恒为0，故ContinuousAt f 0，但f∘V0不可测。它精确否定的是原条件保证所有复合输出可测，而没有错误声称全局Measurable f是所有修正中的必要条件。",
        "evidence": [
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 97,
            "line_end": 97,
            "quote": "严谨反例如下。取 Ω=[0,1]，配备勒贝格概率测度；取一个非勒贝格可测集合 N⊂[1/2,1]。在一维空间中令 S={0}、V恒等于0，令 V0(ω)=ω，且对所有 n≥1 令 Vn恒等于0。所有输入 Vn 和 V 都可测，Vn 处处收敛到 V，并且 P(V∈S)=1。令 f=1_N。因为 f 在0的一个邻域内恒等于0，所以 ContinuousAt f 0；但是 f∘V0=1_N 不可测。因此原条件不能推出所有复合输出可测，也不能满足携带可测性字段的标量随机变量收敛接口。"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 91,
            "line_end": 91,
            "quote": "hf : Measurable f 是一个充分的补充条件；原题给出的局部连续性与 P(V∈S)=1 不足以保证复合输出可测。不能由反例进一步声称全局 Measurable f 在所有可能的修正方案中都是必要条件，因为也可能采用其他足以推出相关复合可测性的更弱或不同条件。"
          }
        ]
      },
      {
        "id": "R2",
        "status": "pass",
        "reason": "函数级Borel可测性与输入可测性经复合直接充分推出全部输出可测，不是把复合结论换名作为前提；代码仍单列无hf的几乎处处核心。交付明确称该条件仅为充分条件。ContinuousAt比相对ContinuousOn更强但为极限序列可从S外接近时所需；所给单点反例正确说明ContinuousOn不足。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 158,
            "line_end": 158,
            "quote": "    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 167,
            "line_end": 167,
            "quote": "  refine ⟨fun n => hf.comp (hVn n), hf.comp hV, ?_, ?_⟩"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 99,
            "line_end": 99,
            "quote": "此外，若只采用相对拓扑意义的 ContinuousOn f S，连收敛核心也不成立。例如 S={0}、Vn恒等于1/(n+1)、V恒等于0，并令 f(0)=0、f(x)=1（x≠0）。f 在单点集合 S 上 ContinuousOn，但 f(Vn) 恒等于1，不收敛到 f(V)=0。因此源码使用逐点全空间连续性条件：对所有 x∈S，ContinuousAt f x。"
          }
        ]
      },
      {
        "id": "T1",
        "status": "fail",
        "reason": "合同要求在f只于S上连续且V几乎必然落入S的条件下证明两种保持性，并明确要求处理复合输出可测性；最终完整声明却新增hf : Measurable f，且事件版本还显式要求满测事件可测。无hf版本只给不含随机向量可测性的几乎处处核心，没有原范围内的完整依概率定理，因此不与原文字/合同范围等价。",
        "evidence": [
          {
            "path": "task_contract/TASK.zh-CN.md",
            "line_start": 5,
            "line_end": 5,
            "quote": "继而设 f 从有限维实空间到有限维实空间，只在集合 S 上连续，且极限向量落入 S 的概率为一。证明 f 保持几乎处处收敛和依概率收敛。须处理满测集相交、连续性只在 S 上、复合输出可测性和依概率事件控制；不得把复合后的收敛或可测性直接作为公开前提。允许不用前一题的现成接口而给出等价证明。"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 177,
            "line_end": 177,
            "quote": "    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 93,
            "line_end": 93,
            "quote": "vectorContinuousMapping_almostSurely_core 是原条件下已经形式化的收敛关系核心，但不提供复合输出可测性。thm_10_11 和 thm_10_11_ae 仅是公开加入 hf 后的修正版支持成果。原合同要求的复合可测性，以及不增加条件的完整依概率随机向量命题，仍未交付；因此整组应按部分成果表述，不能宣称完整解决原始 thm_10_11。"
          }
        ]
      },
      {
        "id": "T2",
        "status": "pass",
        "reason": "实际交付逐项列出了公开声明及前提，明确标注hf是补充的充分条件、无hf核心不提供复合可测性，并直言原合同的复合可测性和无新增条件的完整依概率命题未交付；披露清楚且没有把修正版冒充原题完成。",
        "evidence": [
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 8,
            "line_end": 8,
            "quote": "- 新建数学目标与支持文件 ProbabilityTheory/chapter_10/thm_10_11.lean：给出第二题在原条件下可证明的几乎处处核心、范数及测度收敛桥，以及增加 Measurable f 后的修正版支持成果。"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 91,
            "line_end": 91,
            "quote": "hf : Measurable f 是一个充分的补充条件；原题给出的局部连续性与 P(V∈S)=1 不足以保证复合输出可测。不能由反例进一步声称全局 Measurable f 在所有可能的修正方案中都是必要条件，因为也可能采用其他足以推出相关复合可测性的更弱或不同条件。"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 93,
            "line_end": 93,
            "quote": "vectorContinuousMapping_almostSurely_core 是原条件下已经形式化的收敛关系核心，但不提供复合输出可测性。thm_10_11 和 thm_10_11_ae 仅是公开加入 hf 后的修正版支持成果。原合同要求的复合可测性，以及不增加条件的完整依概率随机向量命题，仍未交付；因此整组应按部分成果表述，不能宣称完整解决原始 thm_10_11。"
          }
        ]
      }
    ],
    "summary": "数学维度通过：10.10及加入精确显式前提后的10.11修正版均正确，且无hf的几乎处处数值收敛核心成立。修正合理性通过：原条件不能保证所有复合输出可测，加入Measurable f是充分但非唯一或最弱的修正，ContinuousAt与ContinuousOn的差别也处理正确。原合同维度失败：新增hf未获原教材或合同许可，原范围内要求的复合可测性和完整依概率随机向量命题没有交付，尽管这一边界已被清楚披露。",
    "limitations": [
      "教材原书页属于事后补充，仅用于独立比较，没有作为原求解许可依据。",
      "两个反例只在交付中给出普通数学论证，未在Lean中形式化；其论证本身经独立核验成立。",
      "构建、公理审核和逃逸扫描结论复用了绑定技术事实；本评价读取并核对了目标源码及其哈希，但未修改文件或进行新求解。"
    ]
  },
  "assessment_accepted": true,
  "issues": [],
  "actor_receipt": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-1\\attempt-01\\actor\\actor-receipt.json",
  "actor_receipt_sha256": "3a0d484de0e7778e642783bb2beb95e5a1a709ee7f355f054dbb69134705b406",
  "raw_events_sha256": "e286c15eb4600e31bdbdd81ac95af17a26b0b431c045ccbaf6147b4f83c24292",
  "subject_manifest_unchanged": true,
  "source_exposure_verified": true,
  "host_elapsed_seconds": 218.42923951148987,
  "no_model_retry": true,
  "original_results_unchanged": true
}
```

## A35 — X058_REVIEW_RESULT.json

命名空间：`X058`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\X058_REVIEW_RESULT.json`

原 SHA-256：`f41d996d0cb262ec74396aa4006e36084911511f2ce442c2ed63cfc3f86b71b1`

范围：`(whole object)`

[包内摘录](sources/A35.json)；包内 SHA-256：`1d862ca045effe44b2d07a591b5e24f52f9856577829e0cf1e4610873d18bf36`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789161127.2802029,
  "candidate_id": "candidate-3e81b8500999",
  "slot": "reviewer-2",
  "assessment": {
    "schema": "targeted.l7.review.v2",
    "request_id": "l7-r2-candidate-3e81b8500999-reviewer-2",
    "candidate_id": "candidate-3e81b8500999",
    "role": "reviewer",
    "confidence": 0.98,
    "dimensions": {
      "mathematics": {
        "status": "pass",
        "reason": "M1–M6 均通过。10.10 的双向证明、有限满测集交、有限并界和零维分支成立；10.11 的范数桥、满测集转换、子序列—子子列论证及在新增函数可测前提下的复合可测性均闭合。候选在 candidate/ProbabilityTheory/chapter_10/thm_10_11.lean:167 明确以“refine ⟨fun n => hf.comp (hVn n), hf.comp hV, ?_, ?_⟩”从基础前提推导复合可测性。"
      },
      "repair_reasonableness": {
        "status": "pass",
        "reason": "R1–R2 均通过。无函数可测性时，原条件不能保证全部复合输出可测；增加函数级可测性是充分但非唯一、非最弱的合理修正。交付在 delivery/DELIVERY.zh-CN.md:91 准确限定：“hf : Measurable f 是一个充分的补充条件；原题给出的局部连续性与 P(V∈S)=1 不足以保证复合输出可测。”"
      },
      "original_contract": {
        "status": "fail",
        "reason": "原任务只给出在 S 上的连续性和极限落入 S 的满概率条件，并要求处理复合可测性；候选完整定理另加无法由这些条件推出的 hf : Measurable f，因此不是原合同范围内的完整交付。task_contract/TASK.zh-CN.md:5 原文为“继而设 f 从有限维实空间到有限维实空间，只在集合 S 上连续，且极限向量落入 S 的概率为一。”"
      }
    },
    "obligations": [
      {
        "id": "M1",
        "status": "pass",
        "reason": "向量到坐标方向由输入向量可测性推出标量强可测性，并在原满测事件上用连续坐标投影传递极限；反向为每个有限坐标选取可测满测事件，取交后用补集零测并证明其仍满测，再以逐坐标极限构造函数空间极限。d=0 时 Fin 0 上的交自动为全集，证明仍成立。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 47,
            "line_end": 47,
            "quote": "refine ⟨fun n => ((coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 70,
            "line_end": 70,
            "quote": "refine ⟨⋂ i, E i, MeasurableSet.iInter hEmeas, ?_, ?_⟩"
          }
        ]
      },
      {
        "id": "M2",
        "status": "pass",
        "reason": "向量到坐标使用 |坐标差|≤欧氏范数给出偏差事件包含。反向在 d≠0 时取正阈值 ε/d；若所有坐标偏差不超过该阈值，则绝对值之和不超过 ε，继而欧氏范数不超过 ε。有限并界和有限和趋零完成概率控制；d=0 被单独化简。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 102,
            "line_end": 102,
            "quote": "(by simpa using abs_coordinate_le_vectorEuclideanNorm (Vn n ω - V ω) i)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 145,
            "line_end": 145,
            "quote": "(prob_2_4_finset_union_bound μ (univ : Finset (Fin d))"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 109,
            "line_end": 109,
            "quote": "simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]"
          }
        ]
      },
      {
        "id": "M3",
        "status": "pass",
        "reason": "候选证明上确界范数≤欧氏范数及欧氏范数≤d·上确界范数。由欧氏严格偏差接口到 TendstoInMeasure 的非严格事件时采用 ε/2，保证 ε≤上确界范数推出 ε/2<欧氏范数；反向以 ε/d 将欧氏严格偏差包含到上确界非严格事件。d=0 有独立分支，严格与非严格边界处理正确。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 15,
            "line_end": 15,
            "quote": "‖v‖ ≤ vectorEuclideanNorm v := by"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 23,
            "line_end": 23,
            "quote": "vectorEuclideanNorm v ≤ d * ‖v‖ := by"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 90,
            "line_end": 90,
            "quote": "change ε / 2 < vectorEuclideanNorm (Vn n ω - V ω)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 108,
            "line_end": 108,
            "quote": "simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]"
          }
        ]
      },
      {
        "id": "M4",
        "status": "pass",
        "reason": "核心定理在输入几乎处处收敛与 V 几乎处处属于 S 的交上，只调用 V(ω) 处的环境空间 ContinuousAt，得到复合值逐点收敛，再将几乎处处形式转换为可测满测事件。它没有要求 f 可测，但其结论所用 VectorConvergesAlmostSurely 定义本身不携带输出可测性，所以只能解释为数值收敛关系核心，不能宣称复合输出已成为随机向量。相对拓扑 ContinuousOn 不足，因为 Vn(ω) 无须留在 S。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 70,
            "line_end": 70,
            "quote": "(hcontinuous : ∀ x ∈ S, ContinuousAt f x)"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 75,
            "line_end": 75,
            "quote": "filter_upwards [vectorConvergesAlmostSurely_ae μ hconv, hVS] with ω hω hωS"
          },
          {
            "path": "upstream/ProbabilityTheory/chapter_10/def_10_6.lean",
            "line_start": 34,
            "line_end": 34,
            "quote": "∃ E : Set Ω, MeasurableSet E ∧ μ E = 1 ∧"
          }
        ]
      },
      {
        "id": "M5",
        "status": "pass",
        "reason": "修正版依概率定理先由 hf 与每个 hVn 推出复合序列的几乎处处强可测性，再使用有限测度空间中的子序列—子子列判别：任取输入子序列，从输入的测度收敛抽取几乎处处收敛的子子列，在 V∈S 的满测集上以 ContinuousAt 复合，随后用同一判别得到输出测度收敛并桥回欧氏依概率收敛。完整定理另由 hf.comp hV 推出极限复合可测性，未把复合收敛或复合可测性当前提。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 139,
            "line_end": 139,
            "quote": "fun n => (hf.comp (hVn n)).aestronglyMeasurable"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 142,
            "line_end": 142,
            "quote": "rw [exists_seq_tendstoInMeasure_atTop_iff houtMeas]"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 149,
            "line_end": 149,
            "quote": "exact (hcontinuous (V ω) hωS).tendsto.comp hω"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 167,
            "line_end": 167,
            "quote": "refine ⟨fun n => hf.comp (hVn n), hf.comp hV, ?_, ?_⟩"
          }
        ]
      },
      {
        "id": "M6",
        "status": "pass",
        "reason": "两个目标沿公开导入链使用允许的上游定义、坐标可测性定理和有限并界；正文证明已逐段核验，未发现循环、结论换名前提、私有公理或证明逃逸。绑定技术事实中的源码哈希与所读目标一致，构建、外逸扫描和公理审计退出码均为零。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_10.lean",
            "line_start": 2,
            "line_end": 2,
            "quote": "import ProbabilityTheory.chapter_02.prob_2_4"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 2,
            "line_end": 2,
            "quote": "import ProbabilityTheory.chapter_10.thm_10_10"
          },
          {
            "path": "tool_fact/technical-validation.json",
            "line_start": 1,
            "line_end": 1,
            "quote": "\"axiom_audit_exit_code\":0"
          }
        ]
      },
      {
        "id": "R1",
        "status": "pass",
        "reason": "候选反例成立：在带勒贝格概率测度的 [0,1] 上，令 V0 为恒等映射、其余 Vn 与 V 恒为 0，取远离 0 的非勒贝格可测集 N 并令 f=1_N。所有输入可测且序列处处收敛，f 在 0 的环境邻域恒为 0，故 ContinuousAt f 0；但 f∘V0=1_N 不可测。它精确否定的是“原前提推出全部复合输出可测”，并不证明全局函数可测性是所有修正中必要的。",
        "evidence": [
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 97,
            "line_end": 97,
            "quote": "但是 f∘V0=1_N 不可测。"
          },
          {
            "path": "upstream/ProbabilityTheory/chapter_10/def_10_2.lean",
            "line_start": 33,
            "line_end": 33,
            "quote": "(∀ n : ℕ, Measurable (Xn n)) ∧"
          }
        ]
      },
      {
        "id": "R2",
        "status": "pass",
        "reason": "新增 hf : Measurable f 足以通过可测函数复合推出所有 f∘Vn 与 f∘V 的可测性，同时支持子序列判别所需的输出强可测性；它不是复合结论本身，故无目标偷渡。候选还明确将无 hf 的几乎处处数值核心与含 hf 的完整修正版分开，并承认 hf 不是唯一或最弱修正。以 ∀x∈S, ContinuousAt f x 而非相对 ContinuousOn 保证来自 S 外的 Vn 也可向 V∈S 传递极限，是合理的必要区分。",
        "evidence": [
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 158,
            "line_end": 158,
            "quote": "(hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 93,
            "line_end": 93,
            "quote": "thm_10_11 和 thm_10_11_ae 仅是公开加入 hf 后的修正版支持成果。"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 99,
            "line_end": 99,
            "quote": "f 在单点集合 S 上 ContinuousOn，但 f(Vn) 恒等于1，不收敛到 f(V)=0。"
          }
        ]
      },
      {
        "id": "T1",
        "status": "fail",
        "reason": "10.10 与原教材和合同实质一致，包括两方向及零维扩展。但原 10.11/合同没有 hf : Measurable f，且共同规则禁止把无法从题目条件推出的新增支持前提用于替代目标。候选的完整 thm_10_11 明确增加 hf，故虽是数学正确的修正版，却不与原文字逐字范围等价，也未获合同许可；无 hf 的核心又不交付合同要求的复合可测性和完整随机向量命题。",
        "evidence": [
          {
            "path": "task_contract/TASK.zh-CN.md",
            "line_start": 5,
            "line_end": 5,
            "quote": "须处理满测集相交、连续性只在 S 上、复合输出可测性和依概率事件控制；不得把复合后的收敛或可测性直接作为公开前提。"
          },
          {
            "path": "task_contract/COMMON_RULES.zh-CN.md",
            "line_start": 7,
            "line_end": 7,
            "quote": "新增支持的前提必须从题目条件或白名单公共结果在正文中推出。"
          },
          {
            "path": "candidate/ProbabilityTheory/chapter_10/thm_10_11.lean",
            "line_start": 177,
            "line_end": 177,
            "quote": "(hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)"
          }
        ]
      },
      {
        "id": "T2",
        "status": "pass",
        "reason": "交付说明逐项列出公开声明、精确前提和义务绑定，清楚区分原条件下的几乎处处数值核心与增加 hf 后的完整修正版，并明确声明原合同的复合可测性和无新增条件的完整依概率随机向量命题尚未交付，没有把合理修正冒充原合同完成。",
        "evidence": [
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 91,
            "line_end": 91,
            "quote": "不能由反例进一步声称全局 Measurable f 在所有可能的修正方案中都是必要条件"
          },
          {
            "path": "delivery/DELIVERY.zh-CN.md",
            "line_start": 93,
            "line_end": 93,
            "quote": "原合同要求的复合可测性，以及不增加条件的完整依概率随机向量命题，仍未交付"
          }
        ]
      }
    ],
    "summary": "显式公开前提下，10.10 全部双向结论及零维处理正确，10.11 的无函数可测性几乎处处数值核心和加入 hf 后的完整修正版也正确。原条件确实不足以保证全部复合输出可测；增加函数级可测性是充分且合理但非唯一的修正。由于该前提超出原教材声明与合同且无 hf 的完整 10.11 未交付，数学维度通过、修正合理性通过、原合同维度失败。",
    "limitations": [
      "交付中的两个反例未在 Lean 中形式化；本评价依据其普通数学构造独立核验，二者均成立。",
      "教材原书页属于事后补充，仅用于交叉核对语境，未被追认为原求解许可。",
      "未重新构建或发起新求解；构建、公理审计和外逸扫描结论复用与候选源码哈希绑定的只读技术事实。"
    ]
  },
  "assessment_accepted": true,
  "issues": [],
  "actor_receipt": "ROOT/rr-l7-r2\\candidate-3e81b8500999\\executions\\reviewer-2\\attempt-01\\actor\\actor-receipt.json",
  "actor_receipt_sha256": "dd94b7fb4d03f3b0e3200954b93a64ca0a48ea2a3c91b4bd18ed6b93339e8f80",
  "raw_events_sha256": "cbf111eeb787ca316821b979ddfcefa59cb5b66fa5839838af210529a557b6b3",
  "subject_manifest_unchanged": true,
  "source_exposure_verified": true,
  "host_elapsed_seconds": 264.52454137802124,
  "no_model_retry": true,
  "original_results_unchanged": true
}
```

## B04 — FROZEN_LIBRARY_BINDING.json

命名空间：`Z frozen library`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\FROZEN_LIBRARY_BINDING.json`

原 SHA-256：`1b0474f8f206f32ef89525039a96c96f0dcd3e4a4bed49b77fbe473df950aa28`

范围：`(whole object)`

[包内摘录](sources/B04.json)；包内 SHA-256：`df4827aaec2cd8859716b3dbcc46edc24e355b60a8067357de297b05a77c2dde`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "epoch": 1789129269.5656438,
  "status": "verified",
  "original_solver_containers": [
    {
      "arm": "A",
      "original_solver_container": "c5751da00f57204affae3df528b7a756b2a0baeeac4a4bcc7db51c261222bcc7",
      "source_receipt": "ROOT/fw_pilot_20260910_staging\\coverage-runs-r1\\L2_thm_11_4_to_11_5\\A\\setup-result.json",
      "source_receipt_sha256": "adc1945faf1e27106a2f2b93e38c42f009614e134b5baba3dbb5619a1f43af58",
      "image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
      "readonly_rootfs": true,
      "no_override_mount_under_image_library": true,
      "container_was_not_started": true,
      "inspect_sha256": "712325f1757f45b933f796d4dfc7848ce5dc5c931affe137bc46dce5d63f4a30",
      "files": {
        "Variance.lean": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\Variance.lean",
          "sha256": "f848104c3a63f3f9727ac5bffdd3a426edbb22b46b42fe9fe085fdfa19a73900"
        },
        "image-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\image-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        },
        "mathlib-HEAD": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\mathlib-HEAD",
          "sha256": "b5017ae798c1946ebd517271aeaa1d44720270b74e96ea9b73222061b945ad55"
        },
        "solver-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\solver-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        }
      },
      "commands": [
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "c5751da00f57204affae3df528b7a756b2a0baeeac4a4bcc7db51c261222bcc7:/opt/cacheproject/.lake/packages/mathlib/Mathlib/Probability/Moments/Variance.lean",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\Variance.lean"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "c5751da00f57204affae3df528b7a756b2a0baeeac4a4bcc7db51c261222bcc7:/opt/cacheproject/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\image-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "c5751da00f57204affae3df528b7a756b2a0baeeac4a4bcc7db51c261222bcc7:/opt/cacheproject/.lake/packages/mathlib/.git/HEAD",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\mathlib-HEAD"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "c5751da00f57204affae3df528b7a756b2a0baeeac4a4bcc7db51c261222bcc7:/work/ProbabilityTheoryFormalization/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\A\\solver-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        }
      ]
    },
    {
      "arm": "B",
      "original_solver_container": "f7456be2f8cb6fc8841265255496c93095c909ab53374a595986d9ca9fa8b5ed",
      "source_receipt": "ROOT/bcap-r4-runs\\coverage-L2-B-r4-001\\RESULT.json",
      "source_receipt_sha256": "9b0edbb47e9305f7a92800219a50b28d5ef8c863e744df447ac1f4e9200348da",
      "image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
      "readonly_rootfs": true,
      "no_override_mount_under_image_library": true,
      "container_was_not_started": true,
      "inspect_sha256": "de5725ad466f0f61c40508d60c0de102f0cdefbef47567e5ba9fdb0f3c6fbdfc",
      "files": {
        "Variance.lean": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\Variance.lean",
          "sha256": "f848104c3a63f3f9727ac5bffdd3a426edbb22b46b42fe9fe085fdfa19a73900"
        },
        "image-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\image-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        },
        "mathlib-HEAD": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\mathlib-HEAD",
          "sha256": "b5017ae798c1946ebd517271aeaa1d44720270b74e96ea9b73222061b945ad55"
        },
        "solver-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\solver-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        }
      },
      "commands": [
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "f7456be2f8cb6fc8841265255496c93095c909ab53374a595986d9ca9fa8b5ed:/opt/cacheproject/.lake/packages/mathlib/Mathlib/Probability/Moments/Variance.lean",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\Variance.lean"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "f7456be2f8cb6fc8841265255496c93095c909ab53374a595986d9ca9fa8b5ed:/opt/cacheproject/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\image-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "f7456be2f8cb6fc8841265255496c93095c909ab53374a595986d9ca9fa8b5ed:/opt/cacheproject/.lake/packages/mathlib/.git/HEAD",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\mathlib-HEAD"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "f7456be2f8cb6fc8841265255496c93095c909ab53374a595986d9ca9fa8b5ed:/work/ProbabilityTheoryFormalization/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\B\\solver-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        }
      ]
    },
    {
      "arm": "C",
      "original_solver_container": "1e674d7bc2e10af10a2f2672b99b982f2949ff3a6294e4213350723b5cadca39",
      "source_receipt": "ROOT/c-r3-runs\\c-r3-l2-001\\run\\actors\\writer-001\\worker-config.json",
      "source_receipt_sha256": "017aee9d7b87651b8d15027a9c7e07ee5c6ad3d165739f12a1b733379bd2fcde",
      "image": "sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c",
      "readonly_rootfs": true,
      "no_override_mount_under_image_library": true,
      "container_was_not_started": true,
      "inspect_sha256": "9f07f7804247898d834b2ee042b285f8c206aa44dfaf10ef65f591c3917f04ca",
      "files": {
        "Variance.lean": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\Variance.lean",
          "sha256": "f848104c3a63f3f9727ac5bffdd3a426edbb22b46b42fe9fe085fdfa19a73900"
        },
        "image-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\image-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        },
        "mathlib-HEAD": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\mathlib-HEAD",
          "sha256": "b5017ae798c1946ebd517271aeaa1d44720270b74e96ea9b73222061b945ad55"
        },
        "solver-lake-manifest.json": {
          "path": "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\solver-lake-manifest.json",
          "sha256": "b583e42a8c5434792e7b5e04865a354710a9aa3b8f7c90665cf862d300c33c4d"
        }
      },
      "commands": [
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "1e674d7bc2e10af10a2f2672b99b982f2949ff3a6294e4213350723b5cadca39:/opt/cacheproject/.lake/packages/mathlib/Mathlib/Probability/Moments/Variance.lean",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\Variance.lean"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "1e674d7bc2e10af10a2f2672b99b982f2949ff3a6294e4213350723b5cadca39:/opt/cacheproject/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\image-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "1e674d7bc2e10af10a2f2672b99b982f2949ff3a6294e4213350723b5cadca39:/opt/cacheproject/.lake/packages/mathlib/.git/HEAD",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\mathlib-HEAD"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "argv": [
            "C:/Program Files/Docker/Docker/resources/bin/docker.exe",
            "cp",
            "1e674d7bc2e10af10a2f2672b99b982f2949ff3a6294e4213350723b5cadca39:/work/ProbabilityTheoryFormalization/lake-manifest.json",
            "ROOT/review_history_retro_20260901\\research_framework\\full_workflow_eval_codesign_20260910\\evaluation_consistency_r1_20260911\\frozen-library\\C\\solver-lake-manifest.json"
          ],
          "exit_code": 0,
          "stderr_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        }
      ]
    }
  ],
  "variance_file_identical_across_all_three": true,
  "solver_manifest_identical_across_all_three": true,
  "locations": [
    {
      "line": 287,
      "text": "lemma variance_sum' [IsFiniteMeasure μ] (hX : ∀ i ∈ s, MemLp (X i) 2 μ) :"
    },
    {
      "line": 297,
      "text": "  variance_sum' (fun _ _ ↦ hX _)"
    },
    {
      "line": 299,
      "text": "lemma variance_fun_sum' [IsFiniteMeasure μ] (hX : ∀ i ∈ s, MemLp (X i) 2 μ) :"
    },
    {
      "line": 301,
      "text": "  convert! variance_sum' hX"
    },
    {
      "line": 443,
      "text": "  rw [variance_sum' hs]"
    }
  ],
  "binding_argument": "Actual original solver containers point to the same immutable image. Their root filesystems are read-only and no mount overrides /opt/cacheproject. The library bytes were copied from each retained stopped container, not inferred from the current host checkout.",
  "model_calls": 0,
  "containers_started_or_unpaused": 0
}
```

## B05 — FULL_SOURCE_CONTRACT_SCAN_11_R2.json

命名空间：`consistency full contract scan`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\evaluation_consistency_r1_20260911\FULL_SOURCE_CONTRACT_SCAN_11_R2.json`

原 SHA-256：`37b8605df0ae8d0ea154a0f79afa1183afd8819c305b3c8359e51f993858875d`

范围：`(whole object)`

[包内摘录](sources/B05.json)；包内 SHA-256：`d528707390f21acf79c9ec5d374d83e27a5289279ba20fe92053a6ed51d70006`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## B06 — SETTINGS_INPUTS.json

命名空间：`I settings manifest`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\evidence\SETTINGS_INPUTS.json`

原 SHA-256：`d3d89e75edba3b2ecc5fecfceaecf3d0f4986bf6a6729b951a7466d3de0ac5ec`

范围：`(whole object)`

[包内摘录](sources/B06.json)；包内 SHA-256：`c5f4661927d14cc0b3ce286411fc3f188e60b29b549918caff3432e6cfceeb3e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## B09 — M2 原始四阶矩条件（最小教材片段）

命名空间：`I18088 frozen M2 source`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\I18088`

原 SHA-256：`48e82a58dfca3b39e242569236511a22175652b659614688af33baed5b5e4804`

范围：`lines 1-20; lines 173-181`

[包内摘录](sources/B09.txt)；包内 SHA-256：`8ec56879d812501720f9c4b48db54aabcc0c860b988750ba5dcc60c62a3703cd`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-20]
% BEGIN EXACT CATALOG SOURCE: thm_11_7
\begin{thmbox}{11.7 (4th-moment Strong Law of Large Numbers)}
\end{thmbox}

Suppose Xi ,f o r i\geq 1 , are independent random variables with mean \mu and

E[X4

i ]\leq c< \infty for all i Then Sn

n \to \mu almost surely.

\textit{Proof} Without loss of generality, we assume that \mu= 0 . (We can consider Yi =

Xi -\mu if the mean of Xi is not zero.)

The expectation of S4

n can be expanded as


[original lines 173-181]
we can apply the first Borel-Cantelli lemma (Theorem 5.8) to conclude that the

event .{\vertSn\vert/n > \epsilon io. } has probability 0. Therefore, by Theorem 10.1, Sn/n

converges to 0 almost surely. \hfill $\square$

Note that Theorem 11.7 does not assume that the random variables Xi are

identically distributed, but it requires that the 4th moments are uniformly bounded.
```

## B10 — M2 准备摘要的中心化四阶矩条件

命名空间：`I18089 frozen M2 task`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\combined_revision_v7_20260912\ev\I18089`

原 SHA-256：`b201c33e97aa82661c80f4a71128713af16d2be46217c98e1eeb5c8678075cab`

范围：`lines 1-5`

[包内摘录](sources/B10.txt)；包内 SHA-256：`5e7765873fc9234d66b25e5a890bc52dbe798a52bd4da37bb300190832340dfb`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
# M2：一致四阶矩界下的强大数定律

对相互独立、具有共同有限均值但不要求同分布的实随机变量序列，假设中心化变量的四阶矩一致有界，证明样本平均几乎处处收敛到共同均值。

交付须包含中心化后独立性与矩控制、有限部分和四次方展开、利用零均值/独立性消去奇次和混合项、得到四阶部分和界、使偏差概率可求和、应用第一 Borel–Cantelli，并从适当子列扩展到完整序列。不得预给四阶展开结论、可求和尾界或最终几乎处处收敛作为支持前提；也不能强化为同分布。

```

## B12 — L7 上游清单额外项：空白目标注释

命名空间：`original A-L7 endpoint input`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-l7\development-ac-r1\cases\a5ef5c2f70ca8ec650cd55ef69e1ea9bb0f37cc956f22c4dd8115aa4740df669\subject\upstream\ProbabilityTheory\chapter_10\thm_10_11.lean`

原 SHA-256：`abc34446bcbc153ec31f949eda0a618671a072ad0b13789211f49045a057354e`

范围：`lines 1-1`

[包内摘录](sources/B12.txt)；包内 SHA-256：`a81e6c1b50afa699ccc704607f45ce85657c0c2809d83189df0745f1bf10d627`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
-- Blank experimental target for thm_10_11; implementation belongs in the task pack.

```

## A06 — 原终验实际绑定程序：输入、格式、会话与裁决

命名空间：`original endpoint; hash matches pinned execution manifest`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\full_workflow_eval_codesign_20260910\formal_endpoint_20260911\endpoint.py`

原 SHA-256：`95acef5cc3987c4d587797c178d7c3a1cd89f8de103563d28855b08866c4b9e6`

范围：`lines 245-360; lines 507-575; lines 605-744`

[包内摘录](sources/A06.txt)；包内 SHA-256：`777d18304c1d0705f3939393d9dfbd2cfe3cdb514c03d72d12a2c1ab70055f5e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## BASE-report — report.en.md

命名空间：`user revision9 exact baseline`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\Revisions from 913\report.en.md`

原 SHA-256：`18cb3a22934efe74c248e73612c38368984d34272b9991123331699c82f9b423`

范围：`lines 1-24`

[包内摘录](sources/BASE-report.txt)；包内 SHA-256：`a910ab56c9089975930204183c9886da401fa1c2f174bbb70894f7ffd245bad7`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-24]
# How probability proofs are completed: workflow history and three organizational trajectories

<!-- English substantive revision 9. Editorial revision only. Experimental acceptance remains frozen at 09:22 Beijing time, 12 September 2026. -->

## Abstract

ProbabilityTheoryFormalization uses AI agents to turn textbook statements and arguments into Lean proofs, with separate controls for building, source-faithfulness review and acceptance of the reviewed artifact. This report evaluates both mathematical delivery and the processes behind it. It combines eleven probability-proof task groups attempted by three deployed configurations with historical proof histories, reconstruction of review records and checks of saved code. These sources answer different questions: what the selected configurations delivered, how particular repairs and failures occurred, and which apparent improvements in the archive survive closer examination.

Under the corrected acceptance criteria, 30 of 33 main-panel submissions pass: A, the existing controlled workflow, passes 9/11; B, organized by a lead author, passes 10/11; and C, with a separate coordinator, passes 11/11. A/B omit the task-permitted eventual-integrability formulation of Scheffé's lemma, and original A-L7 omits continuous mapping. B/C deliver complete, disclosed repairs to insufficient continuous-mapping assumptions. Across nine groups with comparable time records, median solver spans are 58.9, 33.2 and 28.7 minutes. These are observations of actual configurations, including their model, version and host-intervention differences, rather than isolated effects of coordination. [12-14,22,23]

The trajectories explain distinctions that these totals conceal. A-L1 produces acceptable mathematics and several passing opinions, but review delivery blocks acceptance until host recovery; initial C-L1 submits while explicitly lacking its checking opinions. M2 closes a source obligation by deriving a centered-moment bound internally rather than requesting it from the caller. H1 incorporates support into inversion, uniqueness and a Cauchy application, whereas L5 produces substantial support without an established adoption chain. Evaluation correction changes both erroneous rejections and overly broad acceptances, including withdrawing A-L3's original pass. [17-19,22,23,25,27]

Historical analysis adds more than caution about labels. It reconstructs judgment identities, identifies changes outside identical main files, and retains 128 comparisons with affirmative target and object qualification. A first-versus-later-revision contrast is examined against the tasks entering later follow-up, exposing selection that prevents a diminishing-returns interpretation. Saved-code checks and a formal definition witness distinguish compilation, removal of a direct defect and source meaning. The resulting assessment is that the system can complete substantial proof work, but whole-task closure, information delivery, control decisions and evaluation validity must be examined separately. Detailed cases establish specific mechanisms; an overall valid-feedback adoption or mathematical-repair rate remains unavailable. [8-11,16]

## Main text

## 1 How the tested system organizes proofs

### 1.1 The object of evaluation is a mathematical delivery, not just a compiling file

ProbabilityTheoryFormalization, formerly ToyApollo, develops AI-assisted formalization of a probability textbook. In the task groups studied here, the agent receives the textbook claim and proof, a fixed general mathematical library and designated upstream material. It must deliver public declarations, their proof bodies and the dependencies needed to use them. A conclusion assigned to the task cannot simply be renamed as a public assumption and returned to the caller. The experiment therefore concerns implementation and delivery of supplied mathematics, not proof discovery without a textbook argument. [12,26]

The historical inversion task `thm_9_5` shows why this distinction matters. Its early candidate already contained substitution, pointwise cases, dominated convergence and rescaling. An assumption called `h_spine` still supplied integrability, justification for exchanging integrals and the Dirichlet-integral limit. Successive candidates moved those duties into the proof. [1]

```

## BASE-appendix — appendix.en.md

命名空间：`user revision9 exact baseline`；状态：已核对原记录。

原路径：`ROOT/reports\trajectory_analysis\team_review_v031_trajectory_v3_20260911\Revisions from 913\appendix.en.md`

原 SHA-256：`340b34847164855d6dc670a5b66bbc13448d9be767fb5c62fac05fe7f88c6f80`

范围：`lines 1-24`

[包内摘录](sources/BASE-appendix.txt)；包内 SHA-256：`77eb96c1c013789a01f2e305474c60c94131e679100ea53d31891724e84344f4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-24]
# Technical appendix: probability-proof workflows and trajectories

<!-- English substantive revision 9. Experimental acceptance remains frozen at 09:22 Beijing time, 12 September 2026. -->

## Abstract

This appendix supports the substantive English revision 9. Experimental acceptance remains frozen at 09:22 Beijing time on 12 September 2026, with the selected candidates and current labels retained from revision 7. It includes the historical reconstruction, selection checks, saved-code measurements and methodological negative result needed to inspect the main report, alongside detailed mathematical and operational trajectories. C and D reproduce essential methods and results rather than replacing them with links to older editions; G.1-G.4 restore the earlier assistance investigations; K.8 retains the original outcome tables; L preserves the historical proof arguments. M and N retain the recorded measurements, version distinctions and acceptance boundaries. No solver runs or model evaluations were added for this edit.

## Main text

## Appendix A Provenance and chronology

This appendix explains what each source establishes and how event dates are located.

### A.1 What each source can establish

| Material | Supported observation | Interpretation limit |
|---|---|---|
| Code and documentation in commits | Interfaces, rules, and execution paths present in a version | A commit date need not mark first implementation or use; one commit may consolidate several changes |
| Candidates, support files, and diffs | Changes to statements, premises, proof bodies, imports, and calls | A shorter file need not contain less proof; identical main files can have different dependencies |
| Review, build, and application receipts | What was checked, the recorded judgment, and the program result | Model review is not human ground truth; review acceptance differs from successful state application |
| Operating instructions and handoffs | Actions requested of a person or agent | A request does not establish execution; a retrospective summary may omit the original motivation |
| Frozen analyses and case investigations | Counts under stated inclusion rules, code identity, and mathematical interpretation | Purposive cases are not random samples; recheck compatibility is not a new mathematical review |

```

## AP01 — ('original_common_endpoint', '{"protocol_epoch": "development-common-endpoint-v1", "prompt_template_version": "formal-common-endpoint-dual-blind.v1"}', False) 原始实际请求

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-l1\development-ac-r1\cases\5ce512ef66be196cea4e6ebb9c882c4f2aa87697f0524cc604b88d0de6a7bae1\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`e3c52f8a748a35fbf95d5c7a4b2f2446596403fc84d4eb0c1d1bd941d688287a`

范围：`lines 1-40`

[包内摘录](sources/AP01.txt)；包内 SHA-256：`210657f4723e2fff6d848ea12fbe4cdf1c606b2be61df312dab70126273ba427`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP02 — ('original_common_endpoint', '{"protocol_epoch": "development-common-endpoint-v1", "prompt_template_version": "formal-common-endpoint-dual-blind.v1"}', True) 原始实际请求

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-l7\development-ac-r1\cases\a5ef5c2f70ca8ec650cd55ef69e1ea9bb0f37cc956f22c4dd8115aa4740df669\executions\adjudicator\attempt-01\actor\prompt.txt`

原 SHA-256：`9e6122ed9874935c570bf33a40e1c22b44e2752592622a1874327e68d31fe0bc`

范围：`lines 1-7`

[包内摘录](sources/AP02.txt)；包内 SHA-256：`10152f9c2df5a783c618e42c00413e06907f4476d7ac4274e6ab991b3606dbc4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP03 — ('original_common_endpoint', '{"protocol_epoch": "development-common-endpoint-v1", "prompt_template_version": "formal-common-endpoint-dual-blind.v2-scope"}', True) 原始实际请求

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-h1-b\development-b-r4\cases\47e738ffc037453d4d24ee76143fbc98dfd6102041a2fa1daaa60e3c28726722\executions\adjudicator\attempt-01\actor\prompt.txt`

原 SHA-256：`07905caaa1bebd77024955e27b619c2f2e9becab5a8b2027807591e723294d6f`

范围：`lines 1-7`

[包内摘录](sources/AP03.txt)；包内 SHA-256：`73851be125f51ece07e9762b111e3b266e6323479a0b9a3f0c5eb7eaaeb4e5da`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX01 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-h1-b\development-b-r4\cases\47e738ffc037453d4d24ee76143fbc98dfd6102041a2fa1daaa60e3c28726722\executions\adjudicator\attempt-01\trusted-evaluation.json`

原 SHA-256：`bce5b2c1af70e138460ac07765ce8f629499759121a109a6ac636102e7d6e3f5`

范围：`(whole object)`

[包内摘录](sources/AX01.json)；包内 SHA-256：`72134fc9b142834d1d91b390aaa3ec8b3d0f2f0159905d69e14b3631597823aa`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP04 — ('original_common_endpoint', '{"protocol_epoch": "development-common-endpoint-v1", "prompt_template_version": "formal-common-endpoint-dual-blind.v2-scope"}', False) 原始实际请求

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-h1-b\development-b-r4\cases\47e738ffc037453d4d24ee76143fbc98dfd6102041a2fa1daaa60e3c28726722\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`976b7ae56c6e2726a35040dbeec97d9d1314ec399db695dea41ad9546cdfbe5b`

范围：`lines 1-26`

[包内摘录](sources/AP04.txt)；包内 SHA-256：`cd19479c259261c6e2f412cf797480ebd1c484fdc3a7ecb9cadfe89eaf6972b2`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX02 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-m3-b\development-b-r4\cases\587d4ca06e08dc859acc76c3812ac40f5ffc788fff48f85af471cf6492b0481c\executions\reviewer-1\attempt-01\trusted-evaluation.json`

原 SHA-256：`87d98b061077448710b8ba018472615c0c6566b1ab5048dcd7237e40cdb3c1d8`

范围：`(whole object)`

[包内摘录](sources/AX02.json)；包内 SHA-256：`7faa54c845db4cff58bc15a4ea4b66ce4cc08ace994ceb8903f1946a90e018a9`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX03 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-m3-b\development-b-r4\cases\587d4ca06e08dc859acc76c3812ac40f5ffc788fff48f85af471cf6492b0481c\executions\reviewer-2\attempt-01\trusted-evaluation.json`

原 SHA-256：`3ad9b0b8ac81ed640d50e5d1e58c9ff4547937551f584ae02c16dd7f96d526fe`

范围：`(whole object)`

[包内摘录](sources/AX03.json)；包内 SHA-256：`5662617bbffb8f6d1488107ccbe8c0990438f00b9c9e01ba40ca645b20708de8`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX04 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-m3-c\development-ac-r1\cases\6a08818a69f91ce30338d49bacb220a83524911b845d4d46010106f84d57ac93\executions\reviewer-1\attempt-01\trusted-evaluation.json`

原 SHA-256：`52b75a8da59364c525165f246372db2bffc594abfdfd08e33144f777928e431f`

范围：`(whole object)`

[包内摘录](sources/AX04.json)；包内 SHA-256：`64c9e83ef4de726b2d7e3fe06faa425710001d36d9d6634aa0fdb448e85deee2`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX05 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-bc-m3-c\development-ac-r1\cases\6a08818a69f91ce30338d49bacb220a83524911b845d4d46010106f84d57ac93\executions\reviewer-2\attempt-01\trusted-evaluation.json`

原 SHA-256：`233fc20ee4228e2228777da98fc11235fafd9de9b241c12ec0677bd9d8f45fb2`

范围：`(whole object)`

[包内摘录](sources/AX05.json)；包内 SHA-256：`ec744bba3445327c19a68e24c32b70fe590d84e9b2eb39413f437f51d42a7219`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX06 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-h1-cont-r4\development-ac-r1\cases\bbf0b1df57367d2af03356e67a418abc99e4b428621f3c16764c8b75ca9aac8f\executions\adjudicator\attempt-01\trusted-evaluation.json`

原 SHA-256：`e35cfebfdf2910912b2eb4eaad8dfce242d4cff5aa52b0cd3b35d42f98a50658`

范围：`(whole object)`

[包内摘录](sources/AX06.json)；包内 SHA-256：`44b98376c5a1cd54294fff7cf1b398ed656edf381530f31ce2fd2aaf535aec7f`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX07 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-m3\development-ac-r1\cases\03ca44ff6112c2a452d83b998985c2aa22bdeb3d40524939c786d403cce8dc1e\executions\adjudicator\attempt-01\trusted-evaluation.json`

原 SHA-256：`996fc9c2dc47634d5f092a06374854ee06f697a65045098390f36c94d16acc59`

范围：`(whole object)`

[包内摘录](sources/AX07.json)；包内 SHA-256：`262133a7f2308f895b7b4845916d5e29cc7c184a34818dad759a19d945cc4e96`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX08 — trusted-evaluation.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-m3\development-ac-r1\cases\03ca44ff6112c2a452d83b998985c2aa22bdeb3d40524939c786d403cce8dc1e\executions\reviewer-1\attempt-01\trusted-evaluation.json`

原 SHA-256：`eb58268ec7ba1a103534e878709200fd8b067f6eb065c2d301d034cf4b8e4ec2`

范围：`(whole object)`

[包内摘录](sources/AX08.json)；包内 SHA-256：`56512327d5c322df9d77da6c5d6f071591ef771d99ed7230c463b5f3be4444f7`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX09 — trusted-execution-failure.json

命名空间：`original_common_endpoint`；状态：已核对原记录。

原路径：`ROOT/ep-a-stage-m3\development-ac-r1\cases\03ca44ff6112c2a452d83b998985c2aa22bdeb3d40524939c786d403cce8dc1e\executions\reviewer-2\attempt-01\trusted-execution-failure.json`

原 SHA-256：`7b3f951d22b9f51aa0709af9d431fcebf40f9dfc5333e0d6e7646509ea3059f3`

范围：`(whole object)`

[包内摘录](sources/AX09.json)；包内 SHA-256：`bb028ff9296cf7c0ab867281822f07c5c704cb4fe99ec00ec7609a97cc5c9962`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP05 — ('consistency_reevaluation', 'H1', False) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-ad3cbe004a3a\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`d1611be13727eaf58e86560fcbeeeacefe0d3cf955edf2501ed1fb55eaf414f3`

范围：`lines 1-244`

[包内摘录](sources/AP05.txt)；包内 SHA-256：`ffb089104e7584f62f2e6bd5ca628f5c6d4582321a260dcf33f513447e7c705f`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP06 — ('consistency_reevaluation', 'H1', True) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-ad3cbe004a3a-adjud\executions\adjudicator\attempt-01\actor\prompt.txt`

原 SHA-256：`eb5ab16ab0e0b41ffc4f01884c67cfbb3fb5b505c2e599d2ccb572c6c8d4fe8d`

范围：`lines 1-245`

[包内摘录](sources/AP06.txt)；包内 SHA-256：`7c7df7ed97025c72ad6d225b5da91f66e3378f1748e964bc908759a09c3872c2`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX10 — REVIEW_RESULT.json

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-ad3cbe004a3a-adjud\executions\adjudicator\attempt-01\REVIEW_RESULT.json`

原 SHA-256：`79e7daf0aeec1e1478fdbcedf0af20ddca107035701231b0d7775b3826d71d2a`

范围：`(whole object)`

[包内摘录](sources/AX10.json)；包内 SHA-256：`5b01d6bdf1f6d5925f33883f2c6038c930edc69f49b4673b7fda04b92fc3de32`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX11 — REVIEW_RESULT.json

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-c47950c412e8-adjud\executions\adjudicator\attempt-01\REVIEW_RESULT.json`

原 SHA-256：`acdcdb9ca3bb90577238b5c6a0ebc31b812834d80aa32c1b40a8e0a0e1f69919`

范围：`(whole object)`

[包内摘录](sources/AX11.json)；包内 SHA-256：`7938c0ab6c960f3b375ce617b47251e3651aadd747220f9aca623d997361cfa8`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX12 — REVIEW_RESULT.json

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-dfce8b6cb8f4\executions\reviewer-2\attempt-01\REVIEW_RESULT.json`

原 SHA-256：`b9d168673c83911edb5eb488927b0866533692ea913289649c702c2ef3bd6f50`

范围：`(whole object)`

[包内摘录](sources/AX12.json)；包内 SHA-256：`ca9e6107dc0fbc2d932a8aa10d538fb9d23ebeab7adc9d749dac569cf6c7bb7d`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AX13 — REVIEW_RESULT.json

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-h1-v1\candidate-dfce8b6cb8f4-adjud\executions\adjudicator\attempt-01\REVIEW_RESULT.json`

原 SHA-256：`c9beafd8febef19d9677cba98e1932b6c6ea8097d499ac00fbf2a1ca49c8b98d`

范围：`(whole object)`

[包内摘录](sources/AX13.json)；包内 SHA-256：`0bbaa4f0f082b4d641ac12b973b13e134fd96fb121c8925ad8da2f3254b3e076`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP07 — ('consistency_reevaluation', 'L2', False) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-l2-v1\candidate-67c83c8b4bf7\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`54476fb3126f47f2c93d66c430997daed1bca11c2636ba4a55271f655237eac8`

范围：`lines 1-235`

[包内摘录](sources/AP07.txt)；包内 SHA-256：`4759afed6b568314e7808ee8fe27a0f34e54832fbfd3d781370cd51d24d0a6e4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP08 — ('consistency_reevaluation', 'L2', True) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-l2-v1\candidate-67c83c8b4bf7-adjud\executions\adjudicator\attempt-02\actor\prompt.txt`

原 SHA-256：`11370a1e9ce955331e81fda7974aff70e00f17e26c3bf51201246bf80b939b9d`

范围：`lines 1-235`

[包内摘录](sources/AP08.txt)；包内 SHA-256：`d1684cacb301b84336dadc68b384e3a86048d689f7e2b2e6e67bca482f522db8`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP09 — ('consistency_reevaluation', 'L3', False) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-l3-v1\candidate-2ec562216bc6\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`4fdce8092cbb085e2fc67a4c0072429381dc6adcd3f974b282fd4643a2e8a47c`

范围：`lines 1-247`

[包内摘录](sources/AP09.txt)；包内 SHA-256：`b6a38f7bbd327ac1cc21f5adbc128cf2d6717f2ad02e4af3b0d6faa971e32dc9`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP10 — ('consistency_reevaluation', 'L3', True) 原始实际请求

命名空间：`consistency_reevaluation`；状态：已核对原记录。

原路径：`ROOT/rr-l3-v1\candidate-2ec562216bc6-adjud\executions\adjudicator\attempt-01\actor\prompt.txt`

原 SHA-256：`e56a48cbc7b20002a9f1533075c4b51ba2507037bbc7f3f65fb711e679d4ffb8`

范围：`lines 1-265`

[包内摘录](sources/AP10.txt)；包内 SHA-256：`3bc4a9467eb5e442d6a9a6504264a2a0bf36083949cff31cb072c273858e4318`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## AP11 — ('L7_supplement_0517', 'L7', False) 原始实际请求

命名空间：`L7_supplement_0517`；状态：已核对原记录。

原路径：`ROOT/rr-l7-r2\candidate-3e81b8500999\executions\reviewer-1\attempt-01\actor\prompt.txt`

原 SHA-256：`136c304d9361f07bb09c12e8f69e04a242363c2c03d8339e8331f19cb49c67ff`

范围：`lines 1-5`

[包内摘录](sources/AP11.txt)；包内 SHA-256：`bb4191ff269fd724878fb5d71905caa94cb32af90b61674b05f1244f2015cdf5`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## C01 — 10_projection_receipt.json

命名空间：`E19/10`；状态：已核对原记录。

原路径：`ROOT/reports\pipeline_evolution\releases\v0.3.1\evidence\E19\10_projection_receipt.json`

原 SHA-256：`63e8437e4c75e6cdc2c1b3c734d952b7f6f2f03784850343804d08714a8e1e48`

范围：`/analysis_revision, /investigation_sources, /decision_validation/status, /decision_validation/scope, /decision_validation/target_decisions, /decision_validation/positive, /decision_validation/registered_subject_binding_conflicts, /decision_validation/positive_and_registered_object_eligible, /decision_validation/confirmed_boundaries, /decision_validation/unknown_decisions, /main_exclusions, /coverage, /limitations`

[包内摘录](sources/C01.json)；包内 SHA-256：`e42492e193a41fe25aaf742b426c38045c4509c47bdf24cd12a78a847cbeb8a4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## C02-map — rel_1cc426169a021d9dd54961c8

命名空间：`E19 frozen v0.7.1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\main_relation_qualification_map.jsonl`

原 SHA-256：`8e3632dfe81a9e23ad6f30a5d048564c5d896d5e8f4e7b5dcd12d70e76dbdbae`

范围：`lines 457-457`

[包内摘录](sources/C02-map.txt)；包内 SHA-256：`2ce88108578e70588a53471f615494f9c3ffb8f755b04cc340547d88e1dca924`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 457-457]
{"a": "ff19977648701abe220440bf07a3d36441d853acb1e34aca204cf6c5a2dcbfee", "at_utc": "2026-09-07T06:35:00.297840+00:00", "b": "f6a3419bc82dffa6532a6e2fe397de9d859e67760f159fdaab1b73e879cb34b0", "constructibility_action": "no_coupon_initial_row_caveat", "constructibility_affected_endpoints": [], "count_as_independent_reviewer_replication": false, "directed_lineage_action": "retain as same-target individually read relation; keep review-condition caveats and the explicit per-edge outcome", "fixed_target_process_action": "retain_relation_subject_to_other_gates", "historical_label_action": "retain", "in_fixed_329_risk_steps": true, "in_original_1018_queue": true, "labels": ["fail", "fail"], "original_queue_archival_eligibility": "retain_as_individually_read_same_target_relation_with_explicit_outcome", "original_queue_relation_class": "candidate_primary_change", "original_queue_relation_id": "adjacent_transition_v3_03c7da9b5fae6e9da3dee9aec94112e30dd3b6d2d9757f82ba0029d0f33f5ba5", "relation_id": "rel_1cc426169a021d9dd54961c8", "target_decision_id": "v0.7.1:rel_1cc426169a021d9dd54961c8", "target_note": "Hash-verified endpoint inputs/results and full candidate code preserve the same task objective; observed changes concern route, support, debt or review policy.", "target_status": "same_source_mathematical_objective_confirmed", "task_id": "prob_14_11"}
```

## C02-decision — rel_1cc426169a021d9dd54961c8

命名空间：`E19 frozen v0.7.1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\target_change_adjudications.jsonl`

原 SHA-256：`778240d3284a3ee8c514c4625610dbf776a5e088dd917f91c922857577242657`

范围：`lines 90-90`

[包内摘录](sources/C02-decision.txt)；包内 SHA-256：`5897fb4a4e4f2b7437ed0e3370d925020862741e5cdb63e8d97fd051c205bf31`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 90-90]
{"a": "ff19977648701abe220440bf07a3d36441d853acb1e34aca204cf6c5a2dcbfee", "at_utc": "2026-09-07T04:26:14.311565+00:00", "b": "f6a3419bc82dffa6532a6e2fe397de9d859e67760f159fdaab1b73e879cb34b0", "decision_id": "v0.7.1:rel_1cc426169a021d9dd54961c8", "disposition": "same_source_mathematical_objective_confirmed", "evidence_references": [{"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\e6\\e656eb934dddc11b0f032795eaf3559ed5a368599445ea972735643f4d2e0218", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/e6/e656eb934dddc11b0f032795eaf3559ed5a368599445ea972735643f4d2e0218", "review_id": "ff19977648701abe220440bf07a3d36441d853acb1e34aca204cf6c5a2dcbfee", "role": "a_input", "scope": "archived endpoint; not a current environment certification", "sha256": "e656eb934dddc11b0f032795eaf3559ed5a368599445ea972735643f4d2e0218"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\a3\\a36988df6071eed4e7be27cb512b3a731fcecd744130d777f81fcbd62ff06240", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/a3/a36988df6071eed4e7be27cb512b3a731fcecd744130d777f81fcbd62ff06240", "review_id": "ff19977648701abe220440bf07a3d36441d853acb1e34aca204cf6c5a2dcbfee", "role": "a_result", "scope": "archived endpoint; not a current environment certification", "sha256": "a36988df6071eed4e7be27cb512b3a731fcecd744130d777f81fcbd62ff06240"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\76\\76985b158dfbb377d4024d03be25f68d786625e89d38127dd99d31fe566fa6a4", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/76/76985b158dfbb377d4024d03be25f68d786625e89d38127dd99d31fe566fa6a4", "review_id": "f6a3419bc82dffa6532a6e2fe397de9d859e67760f159fdaab1b73e879cb34b0", "role": "b_input", "scope": "archived endpoint; not a current environment certification", "sha256": "76985b158dfbb377d4024d03be25f68d786625e89d38127dd99d31fe566fa6a4"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\27\\27e17c37b71966670bf68420e355ccaf039564c5a24cbfee9ffed771d0e7e092", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/27/27e17c37b71966670bf68420e355ccaf039564c5a24cbfee9ffed771d0e7e092", "review_id": "f6a3419bc82dffa6532a6e2fe397de9d859e67760f159fdaab1b73e879cb34b0", "role": "b_result", "scope": "archived endpoint; not a current environment certification", "sha256": "27e17c37b71966670bf68420e355ccaf039564c5a24cbfee9ffed771d0e7e092"}, {"disposition": "same_source_mathematical_objective_confirmed", "path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\report_source\\analysis\\qualified_20260907\\source_decisions\\target_change_adjudications.jsonl", "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/report_source/analysis/qualified_20260907/source_decisions/target_change_adjudications.jsonl", "relation_id": "rel_1cc426169a021d9dd54961c8", "role": "frozen_explicit_target_decision", "sha256": "b080161d7602953b8aa21a6ddab458727effb63e0d7c91c249b58d381a229319"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\report_source\\analysis\\qualified_20260907\\source_decisions\\case_assessments.jsonl", "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/report_source/analysis/qualified_20260907/source_decisions/case_assessments.jsonl", "relation_id": "adjacent_transition_v3_03c7da9b5fae6e9da3dee9aec94112e30dd3b6d2d9757f82ba0029d0f33f5ba5", "role": "frozen_relation_reading", "sha256": "e7137b902709a8c8cd2914e789928edfc4b86beb6053859b80a0c3a141219f87"}, {"original_source": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/investigation/promote_risk_batch_2.py", "path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\report_source\\analysis\\revisions\\v0.7.1\\before\\0093.py", "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/report_source/analysis/revisions/v0.7.1/before/0093.py", "role": "pre_revision_authored_decision_code", "sha256": "b7e49156651a816fedf7f1dd87a0b2bf5df86ae839721dd18bb52c3a9a2044ef"}], "fixed_source_target_comparable": true, "in_fixed_329_risk_steps": true, "in_original_1018_queue": true, "labels": ["fail", "fail"], "note": "Hash-verified endpoint inputs/results and full candidate code preserve the same task objective; observed changes concern route, support, debt or review policy.", "queue_relation_id": "adjacent_transition_v3_03c7da9b5fae6e9da3dee9aec94112e30dd3b6d2d9757f82ba0029d0f33f5ba5", "reader": "AI archival reader; unblinded; not independent expert ground truth", "reading_basis": "exact source text, both raw endpoint inputs/results, full embedded candidate Lean, exact diff and review obligations", "relation_id": "rel_1cc426169a021d9dd54961c8", "review_scope": "target_comparability_and_relation_progress_read", "scope": "Whether the accepted source mathematical objective is preserved; not code correctness, fixed review policy, or current project completion.", "screen_flags": ["target_header_text_differs"], "source_kind": "frozen_explicit_ai_adjudication", "statistical_action": "retain_subject_to_other_eligibility_gates", "task_id": "prob_14_11"}
```

## C03-map — rel_371ecb44ba45170919976d80

命名空间：`E19 frozen v0.7.1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\main_relation_qualification_map.jsonl`

原 SHA-256：`8e3632dfe81a9e23ad6f30a5d048564c5d896d5e8f4e7b5dcd12d70e76dbdbae`

范围：`lines 77-77`

[包内摘录](sources/C03-map.txt)；包内 SHA-256：`b5a41ef90f71b218ecb506481e9561a9777bca5de635dc9536b2bb5dbfcedd2e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 77-77]
{"a": "27d7634d48839e3a32a2700c93c0b837802cac43a265fe01b61dfb07a519f619", "at_utc": "2026-09-07T06:35:00.297840+00:00", "b": "d9d537fae420ce4cd17703d1b67bb79d5fbb5dc57cfd046131825d8ae8df2dc0", "constructibility_action": "no_coupon_initial_row_caveat", "constructibility_affected_endpoints": [], "count_as_independent_reviewer_replication": false, "directed_lineage_action": "use_main_relation_order; no original-queue adjacency qualification", "fixed_target_process_action": "stop_before_relation", "historical_label_action": "retain", "in_fixed_329_risk_steps": true, "in_original_1018_queue": false, "labels": ["fail", "pass"], "original_queue_archival_eligibility": null, "original_queue_relation_class": null, "original_queue_relation_id": null, "relation_id": "rel_371ecb44ba45170919976d80", "target_decision_id": "v0.7.1:rel_371ecb44ba45170919976d80", "target_note": "The literal task omits independence of X and Y and is false for an arbitrary coupling. The failed law-level endpoint already assumes the target convolution directly, while the passing endpoint exposes hLimitIndep after an explicit source-decision correction. The boundary is the changed accepted source/statement contract, not merely one additional Lean parameter.", "target_status": "necessary_limit_independence_acceptance_contract_boundary", "task_id": "prob_14_7"}
```

## C03-decision — rel_371ecb44ba45170919976d80

命名空间：`E19 frozen v0.7.1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\target_change_adjudications.jsonl`

原 SHA-256：`778240d3284a3ee8c514c4625610dbf776a5e088dd917f91c922857577242657`

范围：`lines 5-5`

[包内摘录](sources/C03-decision.txt)；包内 SHA-256：`8d219c210c8fac8b8f5b0a84bd1508020e0290d5d29ade7c3704e24df30856ae`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 5-5]
{"a": "27d7634d48839e3a32a2700c93c0b837802cac43a265fe01b61dfb07a519f619", "at_utc": "2026-09-07T06:35:00.297840+00:00", "b": "d9d537fae420ce4cd17703d1b67bb79d5fbb5dc57cfd046131825d8ae8df2dc0", "decision_id": "v0.7.1:rel_371ecb44ba45170919976d80", "disposition": "necessary_limit_independence_acceptance_contract_boundary", "evidence_detail": {"boundary_reason": "the accepted source/statement contract changed from literal-source rejection to an explicitly corrected theorem; this is not inferred merely from an added formal parameter", "counterexample": "Independent standard-normal pairs have N(0,2) sums, while choosing the marginal limits as X=Y=Z gives X+Y=2Z with N(0,4) law.", "decision_artifact": "toy-apollo-artifacts/snapshots/2026-07-17/worktree-evidence-rescue/original-main-reconcile-ledger-441/phase2_prompt_packs/prob_14_7/source_decision_resolution.json", "failed_endpoint_contract": "prob_14_7_IndependentSumSetup exposes target_sum_law_is_convolution as a public field.", "literal_task": "The task states independence of X_n and Y_n for each n, but does not state independence of the displayed limits X and Y.", "passing_endpoint_contract": "prob_14_7 exposes hLimitIndep : X independent of Y."}, "evidence_references": [{"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\9e\\9e8415f718d08133d853a57077897adad31af12699d59e079458a7eb0547deca", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/9e/9e8415f718d08133d853a57077897adad31af12699d59e079458a7eb0547deca", "review_id": "27d7634d48839e3a32a2700c93c0b837802cac43a265fe01b61dfb07a519f619", "role": "a_input", "scope": "archived endpoint; not a current environment certification", "sha256": "9e8415f718d08133d853a57077897adad31af12699d59e079458a7eb0547deca"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\32\\32891023254e639aa9a75471c778289b3521831cf066f80910befcfa4922d244", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/32/32891023254e639aa9a75471c778289b3521831cf066f80910befcfa4922d244", "review_id": "27d7634d48839e3a32a2700c93c0b837802cac43a265fe01b61dfb07a519f619", "role": "a_result", "scope": "archived endpoint; not a current environment certification", "sha256": "32891023254e639aa9a75471c778289b3521831cf066f80910befcfa4922d244"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\e6\\e6b4f57174945e4f689ea311cc2812465089d3c92a7dad40339ec61acff1d47d", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/e6/e6b4f57174945e4f689ea311cc2812465089d3c92a7dad40339ec61acff1d47d", "review_id": "d9d537fae420ce4cd17703d1b67bb79d5fbb5dc57cfd046131825d8ae8df2dc0", "role": "b_input", "scope": "archived endpoint; not a current environment certification", "sha256": "e6b4f57174945e4f689ea311cc2812465089d3c92a7dad40339ec61acff1d47d"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\raw_snapshot\\history\\objects\\sha256\\0d\\0d164c6dda02596ff8e2b3d92fb7db4a634ea84198e3966fd9365586a44835d8", "path_relative_to_formalization": "review_history_retro_20260901/raw_snapshot/history/objects/sha256/0d/0d164c6dda02596ff8e2b3d92fb7db4a634ea84198e3966fd9365586a44835d8", "review_id": "d9d537fae420ce4cd17703d1b67bb79d5fbb5dc57cfd046131825d8ae8df2dc0", "role": "b_result", "scope": "archived endpoint; not a current environment certification", "sha256": "0d164c6dda02596ff8e2b3d92fb7db4a634ea84198e3966fd9365586a44835d8"}, {"path": "D:\\Grad_Study\\Practimum\\Formalization\\review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\report_source\\analysis\\qualified_20260907\\source_decisions\\target_change_adjudications.jsonl", "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/report_source/analysis/qualified_20260907/source_decisions/target_change_adjudications.jsonl", "relation_id": "rel_371ecb44ba45170919976d80", "role": "frozen_explicit_target_boundary", "sha256": "b080161d7602953b8aa21a6ddab458727effb63e0d7c91c249b58d381a229319"}], "fixed_source_target_comparable": false, "in_fixed_329_risk_steps": true, "in_original_1018_queue": false, "labels": ["fail", "pass"], "note": "The literal task omits independence of X and Y and is false for an arbitrary coupling. The failed law-level endpoint already assumes the target convolution directly, while the passing endpoint exposes hLimitIndep after an explicit source-decision correction. The boundary is the changed accepted source/statement contract, not merely one additional Lean parameter.", "reader": "AI archival reader; unblinded; not independent expert ground truth", "reading_basis": "target-specific reading of source task text and recovered endpoint declarations/reports; dedicated probes reused where present. This does not certify the full relation case.", "relation_id": "rel_371ecb44ba45170919976d80", "review_scope": "target_comparability_only", "scope": "Whether the accepted source mathematical objective is preserved; not code correctness, fixed review policy, or current project completion.", "screen_flags": ["explicit_target_or_scope_change_language", "target_header_text_differs"], "source_kind": "frozen_explicit_ai_adjudication", "statistical_action": "exclude_as_target_boundary_and_rebuild", "task_id": "prob_14_7"}
```

## C04-map — rel_7b7d8c2be77fd84f07915a2b

命名空间：`E19 frozen v0.7.1`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\main_relation_qualification_map.jsonl`

原 SHA-256：`8e3632dfe81a9e23ad6f30a5d048564c5d896d5e8f4e7b5dcd12d70e76dbdbae`

范围：`lines 130-130`

[包内摘录](sources/C04-map.txt)；包内 SHA-256：`a04b5fd1abf00c500db778a82eb1e6bc8d454641d05c5d8bf6418ca5e3c793cb`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 130-130]
{"a": "46dabd6f73513f8af177228a8467e8ac5da33e0ff9aaea60be55ad1988306e87", "at_utc": "2026-09-07T06:35:00.297840+00:00", "b": "cfdb3f45c1b1a98af892ea1e642d6e1ab162c475230080817e18ed6e0c30eed5", "constructibility_action": "no_coupon_initial_row_caveat", "constructibility_affected_endpoints": [], "count_as_independent_reviewer_replication": false, "directed_lineage_action": "use_main_relation_order; no original-queue adjacency qualification", "fixed_target_process_action": "target_question_not_substantively_adjudicated", "historical_label_action": "retain", "in_fixed_329_risk_steps": true, "in_original_1018_queue": false, "labels": ["fail", "pass"], "original_queue_archival_eligibility": null, "original_queue_relation_class": null, "original_queue_relation_id": null, "relation_id": "rel_7b7d8c2be77fd84f07915a2b", "target_decision_id": null, "target_note": "No target-specific substantive adjudication exists for this relation; rule screening alone cannot establish fixed-target comparability.", "target_status": "not_substantively_adjudicated", "task_id": "def_3_6"}
```

## C05 — rebuild_v071_decisions.py

命名空间：`E19 historical decision projection code`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\rebuild_v071_decisions.py`

原 SHA-256：`755fce58373cb9f16ddd8693c1317afa6536f50f956ab8e5b09ddabb27e5433a`

范围：`lines 1-36; lines 126-175; lines 240-285; lines 310-346`

[包内摘录](sources/C05.txt)；包内 SHA-256：`fb7d68ee7a61c21ab5674e41bea332122ddd098cc1f1cdb1f84098622e38c97e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-36]
"""Rebuild v0.7.1 decisions from frozen v0.7.0 and explicit reading records.

This script verifies and projects authored decisions. It does not independently
decide mathematical equivalence. All writes are restricted to the new revision.
"""
from __future__ import annotations

import argparse
from collections import Counter
from copy import deepcopy
import hashlib
import json
from pathlib import Path

I = Path(__file__).resolve().parent
V = I.parent
F = V.parents[2]
REVISION = I / "revisions/v0.7.1"
BASE = V / "report_source/analysis/qualified_20260907/source_decisions"
BASELINE = V / "report_source/analysis/revisions/v0.7.1/REVISION_BASELINE.json"
OUTPUT = REVISION / "source_decisions"
CORRECTION_ID = "v0.7.1:thm95-support-extraction"
CORRECTED_RELATION = "adjacent_transition_v3_f6df6087647b51fea01daedfee89c9ef4827e31d8ed21dc4c75b486d928f31ea"
EXPLICIT_POSITIVE = {
    "same_source_mathematical_objective_confirmed", "same_riesz_fischer_target_confirmed",
    "source_target_restoration", "canonical_alias_and_proof_elaboration_maintenance",
    "partial_source_contract_restoration", "closed_interval_derivative_restoration",
    "source_model_construction_repair", "same_public_target_partial_helper_progress",
    "source_model_assembly_repair", "moment_interface_repair_with_remaining_route_debt",
    "equivalent_hypothesis_repackaging", "whitespace_and_import_maintenance",
}


def read(path: Path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


[original lines 126-175]
def validate_decision_bundle(root: Path | str, verify_sources: bool = True) -> dict:
    """Check explicit decision provenance, source bytes, mappings, and corrections.

    Mechanical validation cannot certify the semantic judgment made by a reader.
    """
    root = Path(root)
    targets = jl(root / "target_change_adjudications.jsonl")
    cases = jl(root / "case_assessments.jsonl")
    main = jl(root / "main_relation_qualification_map.jsonl")
    issues = jl(root / "new_issue_assessments.jsonl")
    exclusions = read(root / "endpoint_eligibility_exclusions.json")
    index = {x["relation_id"]: x for x in targets}
    if len(index) != len(targets) or len(main) != 462 or len(cases) != 1018:
        raise ValueError("Decision identity/coverage mismatch")
    verified_paths = set()
    for target in targets:
        value = target["fixed_source_target_comparable"]
        if value is not None and type(value) is not bool:
            raise ValueError("Target eligibility must be true, false, or null")
        if value is True and target["disposition"] not in EXPLICIT_POSITIVE:
            raise ValueError("A screening status cannot establish positive eligibility")
        for field in ("decision_id", "source_kind", "reader", "scope", "evidence_references"):
            if not target.get(field):
                raise ValueError(f"Missing explicit target provenance: {field}")
        if target["source_kind"] == "v071_substantive_ai_reading":
            if not target.get("target_before") or not target.get("target_after") or not target.get("reason"):
                raise ValueError("A new reading requires its actual target comparison")
            if not target.get("reading_record_reference"):
                raise ValueError("A new reading must bind its saved decision")
            authored = read(Path(target["reading_record_reference"]["path"]))
            authored_rows = authored if isinstance(authored, list) else authored["decisions"]
            matching = [x for x in authored_rows if x["relation_id"] == target["relation_id"]]
            if len(matching) != 1 or any(matching[0].get(k) != target.get(k) for k in
                                        ("fixed_source_target_comparable", "target_before", "target_after", "reason")):
                raise ValueError("Projected target differs from its explicit authored decision")
        elif target["source_kind"] == "frozen_explicit_ai_adjudication":
            frozen_ref = next((r for r in target["evidence_references"] if r["role"] in
                               {"frozen_explicit_target_decision", "frozen_explicit_target_boundary"}), None)
            if frozen_ref is None:
                raise ValueError("Inherited target has no frozen decision reference")
            inherited = next(x for x in jl(Path(frozen_ref["path"])) if x["relation_id"] == target["relation_id"])
            if any(inherited[k] != target[k] for k in ("a", "b", "disposition", "fixed_source_target_comparable")):
                raise ValueError("Inherited target differs from frozen explicit adjudication")
        else:
            raise ValueError("Unrecognized target decision source")
        refs = target["evidence_references"] + ([target["reading_record_reference"]] if target.get("reading_record_reference") else [])
        roles = {r["role"] for r in refs}
        if not {"a_input", "a_result", "b_input", "b_result"} <= roles:
            raise ValueError("Both endpoint inputs and results must be bound")
        if verify_sources:

[original lines 240-285]
        raise ValueError("Decision outputs must stay inside the new revision directory")
    original_hashes = {p.name: sha(p) for p in BASE.iterdir() if p.is_file()}
    old_targets = jl(BASE / "target_change_adjudications.jsonl")
    cases = jl(BASE / "case_assessments.jsonl")
    issues = jl(BASE / "new_issue_assessments.jsonl")
    main = jl(BASE / "main_relation_qualification_map.jsonl")
    screen = read(I / "target_change_screen.json")
    readings, reading_files = load_readings()
    weak = {x["relation_id"] for x in old_targets if x["disposition"] == "no_material_target_change_found"}
    if set(readings) != weak or len(weak) != 12:
        raise ValueError(f"All 12 weak decisions must be substantively reviewed; missing={sorted(weak - set(readings))}")
    targets = []
    for old in old_targets:
        target = deepcopy(old)
        target.update({"decision_id": f"v0.7.1:{old['relation_id']}", "reader": "AI archival reader; unblinded; not independent expert ground truth",
                       "scope": "Whether the accepted source mathematical objective is preserved; not code correctness, fixed review policy, or current project completion."})
        if old["relation_id"] in readings:
            reading = readings[old["relation_id"]]
            value = reading["fixed_source_target_comparable"]
            if (reading.get("a", old["a"]), reading.get("b", old["b"])) != (old["a"], old["b"]):
                raise ValueError("Reading endpoints do not match the frozen relation")
            target.update(reading)
            target.update({"source_kind": "v071_substantive_ai_reading", "supersedes": {"revision": "v0.7.0", "relation_id": old["relation_id"], "disposition": old["disposition"]},
                           "disposition": ("same_source_mathematical_objective_confirmed" if value is True else "confirmed_target_change" if value is False else "target_question_not_substantively_adjudicated"),
                           "note": reading["reason"], "review_scope": "source_task_full_candidates_and_review_results_substantively_read",
                           "reading_basis": reading["reading_scope"]})
            target["evidence_references"] = frozen_endpoint_refs(old, screen) + reading.get("evidence_references", [])
        else:
            target["source_kind"] = "frozen_explicit_ai_adjudication"
            target["evidence_references"] = frozen_endpoint_refs(old, screen)
            if old["fixed_source_target_comparable"] is True:
                target["evidence_references"] += explicit_original_source(old, cases)
            else:
                target["evidence_references"].append(reference(BASE / "target_change_adjudications.jsonl", "frozen_explicit_target_boundary", relation_id=old["relation_id"]))
        value = target["fixed_source_target_comparable"]
        target["statistical_action"] = ("retain_subject_to_other_eligibility_gates" if value is True else "exclude_as_target_boundary_and_rebuild" if value is False else "stop_before_target_unknown_relation")
        targets.append(target)
    target_by_pair = {(x["a"], x["b"]): x for x in targets}
    for case in cases:
        pair = (case["sources"]["a"]["review_id"], case["sources"]["b"]["review_id"])
        target = target_by_pair.get(pair)
        if target and target["relation_id"] in weak:
            case["target_qualification"] = {"status": target["disposition"], "fixed_source_target_comparable": target["fixed_source_target_comparable"],
                                             "note": target["reason"], "decision_id": target["decision_id"], "review_scope": target["review_scope"]}
    correction = read(REVISION / "readings/thm95_correction.json")
    binding = read(REVISION / "readings/registered_subject_binding_decision.json")

[original lines 310-346]
                      "progress_kind": "support_extraction_and_dct_interface_maintenance", "relation_class": "support_extraction_and_official_reassessment",
                      "new_mathematical_proof_at_this_relation": False, "structural_engineering_contribution": True,
                      "correction_evidence": correction["evidence_references"], "historical_note": correction["scope"],
                      "correction_record_reference": reference(REVISION / "readings/thm95_correction.json", "authored_relation_correction")})
    corrected["statistical_handoff"].update({"count_as_author_code_change": True, "count_as_new_mathematical_proof": False,
                                            "action": "retain structural support extraction and DCT-interface maintenance; do not describe this edge as adding a mathematical proof"})
    issue = next(x for x in issues if x["id"] == "thm95_late_procedural_and_support_migration_sequence")
    issue.update({"correction_id": CORRECTION_ID, "supersedes": {"path": str(BASE / "new_issue_assessments.jsonl"), "id": issue["id"]},
                  "coordinated_relation_decision": CORRECTED_RELATION, "relation_correction": correction["corrected_conclusion"], "correction_evidence": correction["evidence_references"]})
    issues.append({"id": "thm97_registered_subject_v3_reviewed_override_v4", "decision_id": binding["decision_id"],
                   "task_id": "thm_9_7", "issue_class": "registered_subject_binding_conflict", "finding": binding["reason"],
                   "historical_label_override": None, "mathematical_review_retained": True,
                   "registered_object_comparison_eligible": False, "evidence_references": binding["evidence_references"]})
    by_id = {x["relation_id"]: x for x in targets}
    for row in main:
        target = by_id.get(row["relation_id"])
        value = target["fixed_source_target_comparable"] if target else None
        row.update({"target_status": target["disposition"] if target else "not_substantively_adjudicated",
                    "target_note": target["note"] if target else row["target_note"],
                    "target_decision_id": target["decision_id"] if target else None,
                    "fixed_target_process_action": "retain_relation_subject_to_other_gates" if value is True else "stop_before_relation" if value is False else "target_question_not_substantively_adjudicated"})
        if row["relation_id"] in binding["affected_main_relation_ids"]:
            row.update({"registered_object_comparison_eligible": False,
                        "registered_subject_binding_decision_id": binding["decision_id"],
                        "registered_subject_binding_reason": binding["reason"],
                        "directed_lineage_action": "stop_before_registered_subject_binding_conflict"})
    completion = read(BASE / "evidence_qualification_completion.json")
    completion.update({"revision": "v0.7.1", "revision_source_hashes": original_hashes,
                       "target_revision_readings": len(readings), "new_readings_are_independent_expert_ground_truth": False,
                       "registered_subject_binding_conflicts": 1,
                       "relation_class_counts": dict(Counter(x["relation_class"] for x in cases)),
                       "confirmed_target_boundaries": [x["relation_id"] for x in targets if x["fixed_source_target_comparable"] is False]})
    for action in ("stop_before_relation", "retain_relation_subject_to_other_gates", "target_question_not_substantively_adjudicated"):
        completion["main_relation_machine_map"][action] = sum(x["fixed_target_process_action"] == action for x in main)
    completion["files"] = {"relation_ledger": str(output / "case_assessments.jsonl"), "target_adjudications": str(output / "target_change_adjudications.jsonl"),
                           "main_relation_map": str(output / "main_relation_qualification_map.jsonl"), "new_issues": str(output / "new_issue_assessments.jsonl"), "endpoint_eligibility": str(output / "endpoint_eligibility_exclusions.json")}
    save(output / "case_assessments.jsonl", cases, jsonl=True)
```

## C06 — revision_provenance.json

命名空间：`E19 v0.7.1 history`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\revision_provenance.json`

原 SHA-256：`1a95cde11a123e604e778060e092294d944bf3777dcb7eae269aa3f999b7ebc4`

范围：`(whole object)`

[包内摘录](sources/C06.json)；包内 SHA-256：`babeb97f2441cb848b4139313083478d4f03bd9d10eaad97920271b56f4349c3`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "baseline_decision_hashes": {
    "EVIDENCE_INVESTIGATION_COMPLETE_2026-09-07.md": "c1dce7042fd2763cb37a4a683a6c40442e12699c29c426b07efb071874f93226",
    "case_assessments.jsonl": "e7137b902709a8c8cd2914e789928edfc4b86beb6053859b80a0c3a141219f87",
    "endpoint_eligibility_exclusions.json": "2ab67e8afb0fba03e0a2ab5fc611d600bca9b7c6db76470a73a8505fa349c8e5",
    "evidence_qualification_completion.json": "f440f9de94148a7babecaab6ab1512a5ba43b44115f552b05b3d9b64cdea30e2",
    "main_relation_qualification_map.jsonl": "ec375c8b51dc4d3b9c80d0987222ed2ebb424f018c088551582d70c86d223454",
    "new_issue_assessments.jsonl": "3159a560df9fd3453f9a426f6b4860b712feec04074cd442ebcf547d89adc5cc",
    "target_change_adjudications.jsonl": "b080161d7602953b8aa21a6ddab458727effb63e0d7c91c249b58d381a229319"
  },
  "path_base": "ROOT",
  "reading_files": [
    {
      "path": "ROOT/review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\investigation\\revisions\\v0.7.1\\readings\\target_reading_a.json",
      "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/investigation/revisions/v0.7.1/readings/target_reading_a.json",
      "role": "v071_substantive_reading_record",
      "sha256": "269a509bca3259a09731285f77e9a2f0f0f7891d23418a477c4d855b7bb35ee7"
    },
    {
      "path": "ROOT/review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\investigation\\revisions\\v0.7.1\\readings\\target_reading_b.json",
      "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/investigation/revisions/v0.7.1/readings/target_reading_b.json",
      "role": "v071_substantive_reading_record",
      "sha256": "038e2783011ed0a03ccba6b8b75cc2a181ee765e82f37ff3a97fac20f1024343"
    },
    {
      "path": "ROOT/review_history_retro_20260901\\research_framework\\evaluation_rebuild_v2_20260907\\investigation\\revisions\\v0.7.1\\readings\\target_reading_primary.json",
      "path_relative_to_formalization": "review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907/investigation/revisions/v0.7.1/readings/target_reading_primary.json",
      "role": "v071_substantive_reading_record",
      "sha256": "3d9ad1775d4b7d026583ccfc4d92c3eb6410172f1269977b4fca90377da5b4f1"
    }
  ],
  "revision": "v0.7.1",
  "scope": "Explicit target review and one relation interpretation correction; historical labels unchanged."
}
```

## C07 — qualification_validation.json

命名空间：`E19 v0.7.1 validation`；状态：已核对原记录。

原路径：`ROOT/review_history_retro_20260901\research_framework\evaluation_rebuild_v2_20260907\investigation\revisions\v0.7.1\source_decisions\qualification_validation.json`

原 SHA-256：`e0547002446f68157179b27557305129cfd3acf0016feac837a998021b8413d1`

范围：`(whole object)`

[包内摘录](sources/C07.json)；包内 SHA-256：`3c715e2bd72e0490064c41639bf72309d4374c85094db96d0498aa77ff11cd76`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## E01 — 16_selection_rule.py.txt

命名空间：`E19/16`；状态：已核对原记录。

原路径：`ROOT/reports\pipeline_evolution\releases\v0.3.1\evidence\E19\16_selection_rule.py.txt`

原 SHA-256：`b1776d4656bf09471fe89a7c383417d9837e10a543059e05b8fad9cc2c7d53ac`

范围：`lines 1-190`

[包内摘录](sources/E01.txt)；包内 SHA-256：`93ac1a709c1f797f9391cb550b5ffc17e820d55507ebc1ec381b6d0811936e8f`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
[original lines 1-174]
FRAME = AUDIT.parents[1]
ROUND = AUDIT / 'continuation/round3'
SEED = 'astra-cross-evaluation-prototype-20260906-task-isolation-v1'
DEVELOPMENT = {
    'thm_14_3': 'existing_development_explicit_no_review',
    'def_12_1': 'existing_development_partial_progress',
    'thm_14_7': 'existing_development_partial_progress',
    'thm_14_8': 'existing_development_completion_target_change',
    'prob_5_6': 'existing_development_requirement_interface_change',
    'def_10_5': 'existing_development_explicit_response',
}
QUOTAS = {'definition_example|recorded_change': 2,
          'definition_example|no_recorded_change': 2,
          'theorem_problem|recorded_change': 2,
          'theorem_problem|no_recorded_change': 2}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def digest(obj):
    return sha(json.dumps(obj, ensure_ascii=False, sort_keys=True,
                          separators=(',', ':')).encode('utf-8'))


def read_jsonl(path):
    return [json.loads(line) for line in path.read_text(encoding='utf-8').split('\n') if line.strip()]


def write_json(path, obj):
    path = path.resolve()
    if not path.is_relative_to(HERE):
        raise ValueError('Refusing write outside new data_selection directory')
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def metadata():
    edges = read_jsonl(ROUND / 'edge_view.jsonl')
    events = {r['review_event_id']: r for r in read_jsonl(ROUND / 'review_events.jsonl')}
    annotations = read_jsonl(ROUND / 'case_annotations.jsonl')
    return edges, events, annotations


def rank(kind, identifier):
    return sha(f'{SEED}|{kind}|{identifier}'.encode('utf-8'))


def freeze():
    if (HERE / 'selection.json').exists():
        raise SystemExit('selection.json already exists; frozen IDs will not be overwritten')
    edges, events, annotations = metadata()
    by_pair = {e['raw_pair_id']: e for e in edges}
    sources = {}
    exclusions = collections.defaultdict(list)

    def register(path):
        sources[str(path)] = {'sha256': sha(path.read_bytes()), 'bytes': path.stat().st_size}

    def exclude(task, reason, path, row):
        exclusions[task].append({'reason': reason, 'source_path': str(path), 'row_or_id': row})

    for name in ('edge_view.jsonl', 'review_events.jsonl', 'case_annotations.jsonl'):
        register(ROUND / name)
    for a in annotations:
        exclude(by_pair[a['raw_pair_id']]['task_id'], 'continuation_existing_14_development_edges',
                ROUND / 'case_annotations.jsonl', a['annotation_id'])
    pipeline = AUDIT / 'attachments/pipeline_cases.json'
    register(pipeline)
    for case in json.loads(pipeline.read_text(encoding='utf-8'))['cases']:
        exclude(case['transition']['task_id'], 'prior_audit_explicit_case_reading', pipeline, case['case'])
    ledger = FRAME / 'stage5_review_content/execution_v1/results/pair_semantic_ledger.csv'
    register(ledger)
    with ledger.open(encoding='utf-8-sig', newline='') as f:
        for rownum, row in enumerate(csv.DictReader(f), 2):
            if row['encoding_method'] == 'manual_semantic_review_of_registered_structured_content':
                exclude(row['task_id'], 'stage5_29_explicit_manual_cases', ledger, rownum)
    for v in (1, 2):
        path = FRAME / f'stage6_repair_trajectory/execution_v{v}/results/astra_blind_package_v{v}/stage6_finding_alignment_blind_cases.csv'
        register(path)
        with path.open(encoding='utf-8-sig', newline='') as f:
            for row in csv.DictReader(f):
                exclude(row['task_id'], 'conservative_exclusion_prior_case_review_package_not_proof_each_was_read',
                        path, row['blind_case_id'])
    # First choose one representative edge per eligible task using metadata only.
    # This makes strata task-disjoint even when a task has several edge types.
    by_task = collections.defaultdict(list)
    for e in edges:
        if e['task_id'] not in exclusions:
            by_task[e['task_id']].append(e)
    population = []
    for task, task_edges in sorted(by_task.items()):
        e = min(task_edges, key=lambda x: (rank('edge', x['raw_pair_id']), x['raw_pair_id']))
        prefix = task.split('_', 1)[0]
        family = ('definition_example' if prefix in ('def', 'ex') else
                  'theorem_problem' if prefix in ('thm', 'prob') else 'other')
        comparisons = {k: e[k] for k in ('task_content_comparison', 'spine_contract_comparison')}
        change = 'recorded_change' if 'different_recorded_value' in comparisons.values() else 'no_recorded_change'
        population.append({'task_id': task, 'raw_pair_id': e['raw_pair_id'],
                           'stratum': f'{family}|{change}', 'task_rank_sha256': rank('task', task),
                           'edge_rank_sha256': rank('edge', e['raw_pair_id']),
                           'eligible_task_edge_count': len(task_edges), 'comparisons': comparisons})
    heldout = []
    strata = {}
    for group, quota in QUOTAS.items():
        ordered = sorted((p for p in population if p['stratum'] == group),
                         key=lambda x: (x['task_rank_sha256'], x['task_id']))
        strata[group] = {'planned_quota': quota, 'eligible_tasks': len(ordered),
                         'selected_tasks': min(quota, len(ordered))}
        heldout.extend(ordered[:quota])
    dev = []
    annotated_pairs = {a['raw_pair_id'] for a in annotations}
    for task, reason in DEVELOPMENT.items():
        options = [by_pair[p] for p in annotated_pairs if by_pair[p]['task_id'] == task]
        if len(options) != 1:
            raise ValueError(f'Expected one annotated edge for development task {task}, got {len(options)}')
        dev.append({'task_id': task, 'raw_pair_id': options[0]['raw_pair_id'], 'selection_reason': reason})

    selected = []
    # Only hash bytes here; selected raw input JSON is not parsed until package().
    for split, rows in (('development', dev), ('task_isolated_holdout', heldout)):
        for row in rows:
            e = by_pair[row['raw_pair_id']]
            result = dict(row, split=split, adjacent_transition_id=e['adjacent_transition_id'], endpoints={})
            for side in ('from', 'to'):
                ev = events[e[side + '_review_event_id']]
                ip = Path(ev['input_snapshot'])
                try:
                    data = ip.read_bytes()
                    actual = sha(data)
                    state = 'sha_matches_expected' if actual == ev['input_expected_sha256'] else 'sha_mismatch'
                except OSError as err:
                    actual, state = None, f'read_error:{type(err).__name__}'
                result['endpoints'][side] = {
                    'review_event_id': ev['review_event_id'], 'input_snapshot': str(ip),
                    'input_expected_sha256': ev['input_expected_sha256'],
                    'input_frozen_actual_sha256': actual, 'freeze_state': state,
                    'registered_candidate_sha256': ev['candidate_sha256']}
            selected.append(result)
    assert len({s['task_id'] for s in selected}) == len(selected)
    assert not ({s['task_id'] for s in heldout} & set(exclusions))
    frozen = {
        'schema_version': 1, 'frozen_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'selection_method': 'predeclared_metadata_strata_then_stable_sha256_task_selection',
        'seed': SEED, 'units': 'one preselected candidate-repair edge per task',
        'not_gold_standard': True,
        'isolation_limit': 'Excluded documented prior case tasks; no proof of never-seen across all history, model training, or undocumented human/agent review.',
        'selection_inputs_used': ['task_id', 'raw_pair_id', 'task_content_comparison', 'spine_contract_comparison',
                                  'prior exposure identifiers', 'input snapshot path and registered hashes'],
        'selection_inputs_not_used': ['recorded verdict', 'finding meaning', 'candidate code content',
                                      'successful execution', 'apparent quality improvement'],
        'rule_order': ['exclude whole tasks', 'select minimum seeded edge hash per task',
                       'assign 2x2 metadata strata', 'take two smallest seeded task hashes per stratum',
                       'freeze event/input/candidate identities and byte hashes', 'only then parse selected raw inputs'],
        'stratum_semantics': 'recorded_change means a recorded task/content or spine field differs; no_recorded_change includes noncomparable fields and does not prove identical historical requirements.',
        'failure_policy': 'Retain selected missing, malformed, mismatched, or inapplicable inputs; never replace based on restoration or evaluation results.',
        'strata': strata, 'source_files': sources,
        'excluded_tasks': dict(sorted(exclusions.items())),
        'eligible_task_metadata': population, 'selected': selected}
    frozen['selection_content_sha256'] = digest(frozen)
    write_json(HERE / 'selection.json', frozen)
    print(json.dumps({'selection_path': str(HERE / 'selection.json'), 'content_sha256': frozen['selection_content_sha256'],
                      'excluded_task_count': len(exclusions), 'eligible_task_count': len(population),
                      'strata': strata, 'selected': [{k: s[k] for k in ('split', 'task_id', 'raw_pair_id')} for s in selected]},
                     ensure_ascii=False, indent=2))


def pointer(obj, path):
    current = obj
    try:
        for part in path.strip('/').split('/'):
            key = part.replace('~1', '/').replace('~0', '~')
            current = current[int(key)] if isinstance(current, list) else current[key]
```

## E02 — 15_selection.json

命名空间：`E19/15`；状态：已核对原记录。

原路径：`ROOT/reports\pipeline_evolution\releases\v0.3.1\evidence\E19\15_selection.json`

原 SHA-256：`23c15ed668c153c1113d77c7c520d6492abbdf6a5150bc6a3754143fa4811224`

范围：`/seed, /selection_inputs_used, /selection_inputs_not_used, /rule_order, /stratum_semantics, /projection_note`

[包内摘录](sources/E02.json)；包内 SHA-256：`b1ead6c506364c6136ced4768ca8acaa120e680ff5afc59710dfcae88dcb6a09`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "/seed": "astra-cross-evaluation-prototype-20260906-task-isolation-v1",
  "/selection_inputs_used": [
    "task_id",
    "raw_pair_id",
    "task_content_comparison",
    "spine_contract_comparison",
    "prior exposure identifiers",
    "input snapshot path and registered hashes"
  ],
  "/selection_inputs_not_used": [
    "recorded verdict",
    "finding meaning",
    "candidate code content",
    "successful execution",
    "apparent quality improvement"
  ],
  "/rule_order": [
    "exclude whole tasks",
    "select minimum seeded edge hash per task",
    "assign 2x2 metadata strata",
    "take two smallest seeded task hashes per stratum",
    "freeze event/input/candidate identities and byte hashes",
    "only then parse selected raw inputs"
  ],
  "/stratum_semantics": "recorded_change means a recorded task/content or spine field differs; no_recorded_change includes noncomparable fields and does not prove identical historical requirements.",
  "/projection_note": "Original frozen selection with local paths made relative or omitted; original content hash is provenance, not the hash of this projection."
}
```

## D01 — reviewer-result-recovery.json

命名空间：`N02`；状态：已核对原记录。

原路径：`ROOT/fw_pilot_20260910_staging\pilot-runs-r1\pilot-prob_13_9-A-r1\reviewer-result-recovery.json`

原 SHA-256：`2d1b6ff4de8b3a1e52f98436eee6b74f3f4d4fe6aeaccb3a7e7dbce14f80c8d3`

范围：`(whole object)`

[包内摘录](sources/D01.json)；包内 SHA-256：`2d1b6ff4de8b3a1e52f98436eee6b74f3f4d4fe6aeaccb3a7e7dbce14f80c8d3`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "schema_version": "pilot.reviewer_result_recovery.v1",
  "recorded_at": "2026-09-10T16:08:03.2141265Z",
  "run_id": "pilot-prob_13_9-A-r1",
  "dispatch_id": "a8eee636-20ec-4f4a-abd8-21254581e629",
  "reviewer_session_id": "01a08bf3-acd6-7623-b4a3-23311bf5a423",
  "reason": "The fresh independent reviewer completed successfully, but the helper dispatcher rejected the return during its post-run immutability check because the trusted restore changed only public-build-cache.tar ownership. Runtime development_checks/reviewer_manifest_projection_v1 proves the 789-entry content projection is identical. This receipt records exact-byte recovery of the already-produced raw reviewer result; no verdict field was edited.",
  "source": "help/a8eee636-20ec-4f4a-abd8-21254581e629/recovered-raw-review.json",
  "source_sha256": "2731c4841276dd72e6148bfb65d8cd56c9a6027623e5ae66c3b62bafd48bac8e",
  "destination_container": "pilot-prob_13_9-A-r1-author-002",
  "destination": "/work/artifacts/phase2_prompt_packs/prob_13_9/semantic_review_result_v1.json",
  "destination_sha256": "2731c4841276dd72e6148bfb65d8cd56c9a6027623e5ae66c3b62bafd48bac8e",
  "byte_identical": true,
  "runtime_fix_evidence": "pilot_20260910/runtime/development_checks/reviewer_manifest_projection_v1/result.json",
  "root_deadline_reset": false
}
```

## D02 — actor-receipt.json

命名空间：`N11`；状态：已核对原记录。

原路径：`ROOT/fw_pilot_20260910_staging\pilot-runs-r1\pilot-prob_13_9-A-r1\help\a8eee636-20ec-4f4a-abd8-21254581e629\actor\actor-receipt.json`

原 SHA-256：`840b97634c99f58f74d453142006e1484d9fd5e685deeaa192d2369d7399302b`

范围：`/schema, /run_id, /dispatch_id, /parent_dispatch_id, /session_ids, /source_session, /model, /reasoning_effort, /deadline, /raw_public_events_sha256`

[包内摘录](sources/D02.json)；包内 SHA-256：`cfe39c217c876a08efef5e00a112da4e61e3b9e0b1a35b0a540ec99fa4530c1e`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "/schema": "pilot.actor-receipt.v1",
  "/run_id": "pilot-prob_13_9-A-r1",
  "/dispatch_id": "9d390ba0-5b05-4483-ac5f-fc6dddcb00d1",
  "/parent_dispatch_id": "2ad8d4e6-0248-488c-b48e-445137c5d5c4",
  "/session_ids": [
    "01a08c05-c5e1-7390-848d-7071e21a4878"
  ],
  "/source_session": null,
  "/model": "gpt-5.6-sol",
  "/reasoning_effort": "medium",
  "/deadline": {
    "allowance_seconds": 5400.0,
    "started_epoch": 1789051916.5959792,
    "deadline_epoch": 1789057316.5959792,
    "remaining_seconds": 1319.1072826385498
  },
  "/raw_public_events_sha256": "8defaa13268eac8a88e74597c449f93fdf76ba25041bc5df0c366e1820dd1229"
}
```

## D03 — recovered-raw-review.json

命名空间：`N02`；状态：已核对原记录。

原路径：`ROOT/fw_pilot_20260910_staging\pilot-runs-r1\pilot-prob_13_9-A-r1\help\a8eee636-20ec-4f4a-abd8-21254581e629\recovered-raw-review.json`

原 SHA-256：`2731c4841276dd72e6148bfb65d8cd56c9a6027623e5ae66c3b62bafd48bac8e`

范围：`(whole object)`

[包内摘录](sources/D03.json)；包内 SHA-256：`f694b93f7d0a7ea0004e7f69f25765aaf5668f20a5ee9d46627308f0b8adc3d4`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。

## D04 — result.json

命名空间：`N02`；状态：已核对原记录。

原路径：`ROOT/fw_pilot_20260910_staging\pilot-runs-r1\pilot-prob_13_9-A-r1\a-controller\result.json`

原 SHA-256：`3fa17ab4c93ba6380405e276e6c8da15421d36a8b04dcc5d94d619a24058c1bb`

范围：`/schema, /run_id, /status, /blocker, /turns, /author_session, /deadline, /workflow_claim`

[包内摘录](sources/D04.json)；包内 SHA-256：`a9fa870bca9a8e8f3b251928e0b7454868302c5447cc2cee17de1bc72ca546e6`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

```
{
  "/schema": "pilot.a-controller-result.v1",
  "/run_id": "pilot-prob_13_9-A-r1",
  "/status": "completed",
  "/blocker": "",
  "/turns": 2,
  "/author_session": "01a08bcd-d233-7231-9106-2c0066dcfd53",
  "/deadline": {
    "allowance_seconds": 5400.0,
    "started_epoch": 1789051916.5959792,
    "deadline_epoch": 1789057316.5959792,
    "remaining_seconds": 248.71977519989014
  },
  "/workflow_claim": "complete_A"
}
```

## D05 — 仅会话起始标识和最后公开回复；未摘取私有推理

命名空间：`N02 pointed public log`；状态：已核对原记录。

原路径：`ROOT/fw_pilot_20260910_staging\pilot-runs-r1\pilot-prob_13_9-A-r1\help\a8eee636-20ec-4f4a-abd8-21254581e629\actor\raw-public-events.bin`

原 SHA-256：`8defaa13268eac8a88e74597c449f93fdf76ba25041bc5df0c366e1820dd1229`

范围：`lines 1-1; lines 64-64`

[包内摘录](sources/D05.txt)；包内 SHA-256：`bfb4c372e9ad4f56393f1a3111b2611add4b1063317a35c0cb830c91a2ffc2aa`。转换：摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本。

较长结构化对象保存在上述包内文件；无需访问原电脑。


## B11 — 本次机械比较

[所选原终验输入清单的 A/B/C 比较](sources/B11-input-comparison.json)，来源 B07 /roots/*/input_files；这是打包时比较原哈希，不是新实验或原实验产物。
