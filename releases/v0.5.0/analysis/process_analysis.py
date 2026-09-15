"""Post-hoc recorded-review process analysis, using bundled minimal inputs."""
from __future__ import annotations
import argparse, csv, hashlib, json, platform, sqlite3
from pathlib import Path
import numpy as np
import scipy
import statsmodels.api as sm
import statsmodels
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE=Path(__file__).resolve().parent
SEED=20260906
BOOTSTRAPS=20000
METRICS=["first_pass_rate","later_pass_rate","later_minus_first","later_vs_first_odds_ratio",
         "within_chain_pass_fraction","observed_steps_to_pass_or_exit_mean"]

def digest(path):
    h=hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda:f.read(2**20),b""):
            h.update(chunk)
    return h.hexdigest()

def write_json(path,obj):
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(obj,indent=2,ensure_ascii=False,allow_nan=False)+"\n",encoding="utf-8")

def derive(episodes):
    cohort,rows=[],[]
    for e in episodes:
        if e["verdict_path"][0]!="fail": continue
        terminal=next((j for j,v in enumerate(e["verdict_path"][1:],1) if v=="pass"),None)
        length=terminal if terminal is not None else len(e["edge_ids"])
        cohort.append(dict(episode_id=e["episode_id"],task_id=e["task_id"],length=length,
                           pass_event=int(terminal is not None),exit_event=int(terminal is None)))
        for j in range(1,length+1):
            rows.append(dict(episode_id=e["episode_id"],task_id=e["task_id"],adjacent_transition_id=e["edge_ids"][j-1],
                             attempt_index=j,later_attempt=int(j>=2),
                             from_recorded_verdict=e["verdict_path"][j-1],
                             to_recorded_verdict=e["verdict_path"][j],
                             next_recorded_review_is_pass=int(e["verdict_path"][j]=="pass")))
    return cohort,rows

def freeze(framework,target):
    db=framework/"stage6_repair_trajectory/execution_v3/review_repair_analysis_v3.sqlite3"
    results=framework/"stage7_repair_process_analysis/execution_v1/results"
    summary=results/"high_confidence_episode_summary.csv"
    risk=results/"fail_origin_discrete_time_risk_set.csv"
    before={str(p.relative_to(framework)).replace("\\","/"):digest(p) for p in (db,summary,risk)}
    conn=sqlite3.connect(db.resolve().as_uri()+"?mode=ro",uri=True);conn.row_factory=sqlite3.Row
    episodes=[]
    for row in conn.execute("SELECT * FROM repair_episode_v3 ORDER BY repair_episode_v3_id"):
        assert row["all_edges_high_confidence_candidate_repair"]==1
        verdicts,edges=json.loads(row["recorded_verdict_path_json"]),json.loads(row["edge_ids_json"])
        assert len(verdicts)==len(edges)+1==row["attempt_n"]+1
        for j,edge_id in enumerate(edges):
            edge=conn.execute("SELECT * FROM adjacent_review_transition_v3 WHERE adjacent_transition_id=?",(edge_id,)).fetchone()
            assert edge["task_id"]==row["task_id"]
            assert edge["high_confidence_candidate_repair"]==1
            assert [edge["from_recorded_verdict"],edge["to_recorded_verdict"]]==verdicts[j:j+2]
        episodes.append(dict(episode_id=row["repair_episode_v3_id"],task_id=row["task_id"],
                             verdict_path=verdicts,edge_ids=edges))
    conn.close()
    source_summary=list(csv.DictReader(summary.open(encoding="utf-8-sig",newline="")))
    assert len(source_summary)==len(episodes)==262
    indexed={e["episode_id"]:e for e in episodes}
    for r in source_summary:
        e=indexed[r["episode_id"]]
        assert r["task_id"]==e["task_id"]
        assert json.loads(r["recorded_verdict_path_json"])==e["verdict_path"]
        assert json.loads(r["edge_ids_json"])==e["edge_ids"]
    _,rebuilt=derive(episodes)
    source_risk=[r for r in csv.DictReader(risk.open(encoding="utf-8-sig",newline="")) if r["scenario"]=="high_confidence"]
    def key(r):
        return (r["episode_id"],r["task_id"],r["adjacent_transition_id"],int(r["attempt_index"]),
                r["from_recorded_verdict"],r["to_recorded_verdict"],int(r["next_recorded_review_is_pass"]))
    assert sorted(map(key,source_risk))==sorted(map(key,rebuilt))
    after={str(p.relative_to(framework)).replace("\\","/"):digest(p) for p in (db,summary,risk)}
    assert before==after
    target.mkdir(parents=True,exist_ok=True)
    frozen=target/"episodes.json";write_json(frozen,episodes)
    write_json(target/"manifest.json",dict(schema_version=1,source_root_label="research_framework",source_sha256=before,
        frozen_files={"episodes.json":digest(frozen)},
        extraction="262 high-confidence chains; task/episode/edge identifiers and recorded verdict path only",
        validation=dict(sqlite_chain_edges_checked=True,stage7_summary_matches=True,stage7_high_confidence_risk_rows_match=True,source_hashes_unchanged=True),
        limitation="Path consistency is checked; repair-role classification and semantic correctness are not certified."))
    write_json(target/"local_source_manifest.json",{"source_root":str(framework.resolve()),"source_paths":[str(x.resolve()) for x in (db,summary,risk)]})

def metrics(v):
    first=v[...,1]/v[...,0];later=v[...,3]/v[...,2]
    odds=(later/(1-later))/(first/(1-first))
    return np.stack([first,later,later-first,odds,v[...,5]/v[...,4],v[...,6]/v[...,4]],axis=-1)

def calculate(episodes):
    cohort,rows=derive(episodes)
    assert len(episodes)==262 and len(cohort)==230 and len(rows)==329
    tasks=sorted({e["task_id"] for e in cohort});assert len(tasks)==182
    task_index={t:i for i,t in enumerate(tasks)}
    counts=np.zeros((len(tasks),7),dtype=int)
    for e in cohort:
        counts[task_index[e["task_id"]],4:]+=np.array([1,e["pass_event"],e["length"]])
    for r in rows:
        k=2*r["later_attempt"]
        counts[task_index[r["task_id"]],k:k+2]+=np.array([1,r["next_recorded_review_is_pass"]])
    total=counts.sum(axis=0);assert total.tolist()==[230,167,99,39,230,206,329]
    x=np.array([[1,r["later_attempt"]] for r in rows],dtype=float)
    y=np.array([r["next_recorded_review_is_pass"] for r in rows],dtype=float)
    groups=np.array([r["task_id"] for r in rows])
    fitted=sm.GEE(y,x,groups=groups,family=sm.families.Binomial(),
                  cov_struct=sm.cov_struct.Independence()).fit(cov_type="robust")
    p1,p2=167/230,39/99
    expected=np.array([np.log(p1/(1-p1)),np.log(p2/(1-p2))-np.log(p1/(1-p1))])
    np.testing.assert_allclose(fitted.params,expected,rtol=1e-10,atol=1e-10)
    mu=fitted.fittedvalues
    inv=np.linalg.inv(x.T@((mu*(1-mu))[:,None]*x))
    scores=np.array([(x[groups==t]*(y[groups==t]-mu[groups==t])[:,None]).sum(axis=0) for t in tasks])
    manual_cov=inv@(scores.T@scores)@inv
    np.testing.assert_allclose(manual_cov,fitted.cov_params(),rtol=1e-9,atol=1e-10)
    rng=np.random.default_rng(SEED);bs=[]
    for start in range(0,BOOTSTRAPS,1000):
        idx=rng.integers(0,len(tasks),(min(1000,BOOTSTRAPS-start),len(tasks)))
        bs.append(metrics(counts[idx].sum(axis=1)))
    boot=np.concatenate(bs);assert np.isfinite(boot).all()
    point=metrics(total);ci=np.quantile(boot,[.025,.975],axis=0);leave=metrics(total-counts)
    estimates={name:dict(estimate=float(point[k]),task_bootstrap_percentile_95=ci[:,k].tolist(),
                       leave_one_task_out_range=[float(leave[:,k].min()),float(leave[:,k].max())]) for k,name in enumerate(METRICS)}
    first_cum=exit_cum=0;curve=[]
    for j in range(1,max(e["length"] for e in cohort)+1):
        n=sum(e["length"]>=j for e in cohort)
        d=sum(e["length"]==j and e["pass_event"] for e in cohort)
        c=sum(e["length"]==j and e["exit_event"] for e in cohort)
        first_cum+=d;exit_cum+=c;active=n-d-c
        curve.append(dict(attempt_index=j,at_risk=n,recorded_pass_events=d,chain_exit_events=c,
                          next_step_at_risk=active,conditional_recorded_pass_rate=d/n,
                          cumulative_within_chain_pass=first_cum/len(cohort),
                          cumulative_chain_exit=exit_cum/len(cohort),still_active_fraction=active/len(cohort)))
    assert all(curve[k]["next_step_at_risk"]==curve[k+1]["at_risk"] for k in range(len(curve)-1))
    assert curve[-1]["next_step_at_risk"]==0
    later_tasks={r["task_id"] for r in rows if r["later_attempt"]}
    continued={e["episode_id"] for e in cohort if e["length"]>=2}
    def first_summary(selected):
        rr=[r for r in rows if r["attempt_index"]==1 and selected(r)]
        return {"pass":sum(r["next_recorded_review_is_pass"] for r in rr),"n":len(rr)}
    selection=dict(tasks_contributing_later=len(later_tasks),
        all_first=first_summary(lambda r:True),
        first_in_later_contributing_tasks=first_summary(lambda r:r["task_id"] in later_tasks),
        first_in_actually_continued_episodes=first_summary(lambda r:r["episode_id"] in continued),
        first_in_other_episodes_of_later_contributing_tasks=first_summary(lambda r:r["task_id"] in later_tasks and r["episode_id"] not in continued))
    assert selection["first_in_actually_continued_episodes"]=={"pass":0,"n":45}
    assert selection["first_in_other_episodes_of_later_contributing_tasks"]=={"pass":12,"n":16}
    gee=dict(model="logit P(next recorded pass | observed risk row)=alpha+beta*1(attempt>=2)",
        task_cluster_n=len(tasks),working_correlation="independence",covariance="robust task sandwich",
        parameters=fitted.params.tolist(),robust_standard_errors=fitted.bse.tolist(),
        wald_95=fitted.conf_int().tolist(),nominal_two_sided_p=fitted.pvalues.tolist(),
        later_odds_ratio=float(np.exp(fitted.params[1])),later_odds_ratio_wald_95=np.exp(fitted.conf_int()[1]).tolist(),
        converged=bool(fitted.converged),design_rank=int(np.linalg.matrix_rank(x)),
        manual_sandwich_max_abs_error=float(np.max(np.abs(manual_cov-fitted.cov_params()))),
        interpretation="Observed risk-row marginal association; covariance adjustment is not task fixed effects, causal adjustment, or independence verification.")
    return dict(schema_version=1,analysis_status="post-hoc exploratory",
        cohort=dict(all_high_confidence_chains=262,fail_origin_chains=len(cohort),tasks=len(tasks),risk_rows=len(rows),
            within_chain_first_passes=206,chain_exits_without_pass=24,
            endpoint="First recorded pass within the fixed original chain, or observed end of that chain before recorded pass.",
            later_task_passes_outside_chain="Not appended. Process exit is terminal for this endpoint; hypothetical continued repair remains unobserved."),
        estimates=estimates,gee=gee,process_curve=curve,future_selection_diagnostic=selection,
        constant_observed_hazard_reference=dict(pooled_observed_rate=206/329,
            working_likelihood="The common-rate maximizer of an independent-Bernoulli working likelihood; not a full joint-likelihood MLE under unspecified within-task dependence.",
            restriction="beta=0 equates the two observed risk-row marginal means. Full-history constant conditional hazard is a stronger assumption, not tested here.",
            note="For first-pass stopping time T, I(T>=j) is a predictable at-risk indicator under the natural history; T itself need not be predictable. Post-hoc graph selection does not certify this observation property."),
        bootstrap=dict(seed=SEED,replicates=BOOTSTRAPS,unit="182 whole tasks, retaining all original episodes and risk rows",
            estimand="Ratios of pooled task totals (row- or episode-weighted), not task-equal averages.",
            uncertainty="Reference uncertainty under independent exchangeable task clusters and the same history selection mechanism; not sampling error of the enumerated archive.",
            finite_replicates=int(np.isfinite(boot).all(axis=1).sum())),
        checks=dict(stage7_counts_match=True,gee_equals_closed_form=True,gee_covariance_equals_manual_sandwich=True,
                    competing_terminal_counts_conserve_cohort=True,source_semantics_not_validated_by_these_checks=True)),cohort,rows

def write_outputs(out,result,cohort,rows,input_root):
    out.mkdir(parents=True,exist_ok=True)
    result["inputs"]={"root_label":"inputs/process","manifest_sha256":digest(input_root/"manifest.json"),"episodes_sha256":digest(input_root/"episodes.json")}
    result["runtime"]={"python":platform.python_version(),"numpy":np.__version__,"scipy":scipy.__version__,"statsmodels":statsmodels.__version__,"matplotlib":matplotlib.__version__}
    write_json(out/"process_statistics.json",result)
    for name,data in [("process_cohort.csv",cohort),("process_risk_rows.csv",rows),("process_curve.csv",result["process_curve"])]:
        with (out/name).open("w",newline="",encoding="utf-8") as f:
            writer=csv.DictWriter(f,fieldnames=list(data[0]));writer.writeheader();writer.writerows(data)
    e=result["estimates"];g=result["gee"];curve=result["process_curve"]
    def pct(v):return f"{100*v:.2f}%"
    def ci(v):return f"[{100*v[0]:.2f}, {100*v[1]:.2f}]%"
    table="\n".join(f"| {r['attempt_index']} | {r['at_risk']} | {r['recorded_pass_events']} | {r['chain_exit_events']} | {r['next_step_at_risk']} |" for r in curve)
    english=f"""# Recorded-review process analysis (post-hoc exploratory)

## Question and endpoint

In the fixed 262-chain high-confidence graph, 230 chains from 182 tasks start with a recorded failure. Reconstructing their paths up to the first recorded pass gives 329 risk rows, 206 within-chain passes, and 24 chains ending before a recorded pass. A step is a transition between submitted candidate versions, not an internal edit, an API call, or wall-clock time.

We ask when a first recorded pass occurs within this original chain. Ending the chain without a pass is a terminal process outcome for this definition, not a claim of irreparable failure. A chain exit records the boundary of the fixed high-confidence graph; it does not establish that work on the task ceased. Later same-task passes outside the chain are not appended. For a different target—the hypothetical time to pass if editing continued—these exits remain potentially informative censoring, and its survival curve is not identified here.

## Model and reference inference

For task s, episode e and observed at-risk step j, let Y_sej indicate that the next recorded review is pass. Fit

    logit E[Y_sej | observed risk row, L_j] = alpha + beta L_j,
    L_j = 1{{j >= 2}}.

We used binomial generalized estimating equations with working independence and a robust task-cluster sandwich covariance. This is a marginal contrast between two observed risk-row groups. Clustering changes covariance estimation; it does not adjust for task difficulty, eliminate selection into later steps, or establish independent task clusters. Shared requirements, dependencies, models and collection batches may link tasks. No population sampling design or confirmatory preregistration is available. All p-values and intervals below are reference-model summaries under an independent exchangeable task-cluster interpretation.

The two-column design has rank {g['design_rank']}; fitted mean parameters equal the log-odds of the two empirical rates. An independent cluster-score sandwich reconstruction agrees with the covariance (maximum absolute discrepancy {g['manual_sandwich_max_abs_error']:.3g}). This model is estimable; possible separation in richer fixed-effect models is not a reason to reject this fit.

## Results

The first-step rate was 167/230 = {pct(e['first_pass_rate']['estimate'])}, compared with 39/99 = {pct(e['later_pass_rate']['estimate'])} at later observed steps. Whole-task resampling (20,000 draws, seed {SEED}) gave respective 95% percentile intervals {ci(e['first_pass_rate']['task_bootstrap_percentile_95'])} and {ci(e['later_pass_rate']['task_bootstrap_percentile_95'])}. The later-minus-first difference was {100*e['later_minus_first']['estimate']:.2f} percentage points; its interval was [{100*e['later_minus_first']['task_bootstrap_percentile_95'][0]:.2f}, {100*e['later_minus_first']['task_bootstrap_percentile_95'][1]:.2f}] percentage points.

The later-step coefficient was beta = {g['parameters'][1]:.6f} (robust SE {g['robust_standard_errors'][1]:.6f}), giving an odds ratio of {g['later_odds_ratio']:.4f}, Wald 95% interval [{g['later_odds_ratio_wald_95'][0]:.4f}, {g['later_odds_ratio_wald_95'][1]:.4f}], and nominal two-sided p = {g['nominal_two_sided_p'][1]:.7f}. This quantifies heterogeneity of recorded-pass rates across observed process positions. It does not show that another edit reduces success, identify a within-task effect, or establish a difficulty mechanism.

A common recorded-pass probability across observed risk rows is a simple working benchmark. Maximizing the independent-Bernoulli working likelihood gives 206/329 = {206/329:.6f}; this is not a full joint-likelihood maximum under unspecified within-task dependence. In the two-regime model beta = 0 equates only the first and later marginal means. Full-history constant conditional hazard is a stronger assumption. The comparison is a coarse observed-association diagnostic, not a test of constant hazard given every past history, latent task homogeneity, or causal diminishing returns.

For a first-pass stopping time T, the at-risk indicator I(T >= j) is predictable with respect to the natural past-outcome history; T itself need not be predictable. Such outcome stopping does not by itself invalidate a constant conditional-hazard model. The historical graph classifier uses candidate and record information, so its post-hoc selected risk set does not automatically satisfy the observation assumptions of the mathematical proposition. The proposition and this marginal fit have distinct roles.

## Explicit process exits

The finite-history within-chain pass fraction is 206/230 = {pct(e['within_chain_pass_fraction']['estimate'])}; the complementary 24/230 = {100*24/230:.2f}% terminate without a within-chain pass. Mean observed length to either terminal outcome is 329/230 = {e['observed_steps_to_pass_or_exit_mean']['estimate']:.4f} submitted-version transitions. It is not expected edits until eventual success. Whole-task reference intervals are {ci(e['within_chain_pass_fraction']['task_bootstrap_percentile_95'])} for the within-chain pass fraction and [{e['observed_steps_to_pass_or_exit_mean']['task_bootstrap_percentile_95'][0]:.4f}, {e['observed_steps_to_pass_or_exit_mean']['task_bootstrap_percentile_95'][1]:.4f}] for observed length.

At each step n_j = d_j + c_j + n_(j+1), where d is a pass and c an observed chain exit. Cumulative within-chain pass incidence is sum(d_k, k<=j)/230; cumulative exit incidence is sum(c_k, k<=j)/230. These finite-cohort quantities require no independent-censoring assumption: exit is part of the endpoint, not an imputed pass or failure.

| Step | At risk | Recorded passes | Chain exits | Continue |
|---|---:|---:|---:|---:|
{table}

## Selection diagnostic and sensitivity

There are 39 tasks contributing later risk rows. Restricting first steps to those tasks gives 12/61 passes. However, these 61 first steps comprise 45 episodes that actually continue (0/45 first-step passes, by construction of stopping at first pass) and 16 other episodes (12/16 first-step passes). The apparent reversal from selecting tasks with later observations is not a demonstrated within-task improvement or an established Simpson's-paradox mechanism. Later-step availability is a future-dependent selection variable.

Across leave-one-task-out reconstructions, the later-minus-first difference ranges from {100*e['later_minus_first']['leave_one_task_out_range'][0]:.2f} to {100*e['later_minus_first']['leave_one_task_out_range'][1]:.2f} percentage points and the odds ratio from {e['later_vs_first_odds_ratio']['leave_one_task_out_range'][0]:.4f} to {e['later_vs_first_odds_ratio']['leave_one_task_out_range'][1]:.4f}. This bounded influence check does not verify cross-task independence or remove archive selection.

Adding medium-confidence edges reconnects processes and changes the fail-origin cohort. That is a different-cohort sensitivity analysis, not fixed-cohort robustness. We retain the original high-confidence cohort.

## Reproduction and sources

Run python process_analysis.py --output-root recomputed from the analysis directory. Default input is the bundled minimal inputs/process/episodes.json, checked against its manifest. The --input-root option accepts another directory with the same frozen schema. Frozen paths were checked against the read-only stage-six graph and stage-seven summary/risk rows; source hashes were unchanged. This consistency check does not certify the inferred graph roles or semantic correctness.

The [statsmodels GEE documentation](https://www.statsmodels.org/stable/gee.html) specifies within-cluster correlation and between-cluster independence. The accompanying mathematical insert gives stopped-process equations and assumptions. These standard methods sharpen an auditable process question; no new statistical estimator is claimed.
"""
    (out/"process_statistics_en.md").write_text(english,encoding="utf-8")
    fig,axes=plt.subplots(1,2,figsize=(9.4,3.2),layout="constrained")
    step=np.array([0]+[r["attempt_index"] for r in curve])
    axes[0].step(step,[0]+[r["cumulative_within_chain_pass"] for r in curve],where="post",label="Within-chain recorded pass")
    axes[0].step(step,[0]+[r["cumulative_chain_exit"] for r in curve],where="post",label="Chain exit before pass")
    axes[0].set(xlabel="Submitted-version transition",ylabel="Fraction of 230 original chains",ylim=(0,1))
    axes[0].legend(fontsize=8,loc="center right");axes[0].grid(alpha=.2)
    rates=np.array([e["first_pass_rate"]["estimate"],e["later_pass_rate"]["estimate"]])
    cis=np.array([e["first_pass_rate"]["task_bootstrap_percentile_95"],e["later_pass_rate"]["task_bootstrap_percentile_95"]])
    axes[1].errorbar([0,1],rates,yerr=np.vstack((rates-cis[:,0],cis[:,1]-rates)),fmt="o",capsize=5,color="#225ea8")
    axes[1].set(xticks=[0,1],xticklabels=["First (167/230)","Later (39/99)"],ylabel="Recorded pass / observed risk rows",ylim=(0,1))
    axes[1].set_title("Task-cluster reference intervals",fontsize=10);axes[1].grid(axis="y",alpha=.2)
    fig.savefig(out/"process_profile.pdf",metadata={"CreationDate":None,"ModDate":None})
    fig.savefig(out/"process_profile.png",dpi=180);plt.close(fig)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--input-root",type=Path,default=HERE/"inputs/process")
    p.add_argument("--output-root",type=Path,default=HERE)
    p.add_argument("--freeze-from-framework",type=Path)
    args=p.parse_args()
    if args.freeze_from_framework:freeze(args.freeze_from_framework,args.input_root)
    manifest=json.loads((args.input_root/"manifest.json").read_text(encoding="utf-8"))
    assert digest(args.input_root/"episodes.json")==manifest["frozen_files"]["episodes.json"]
    episodes=json.loads((args.input_root/"episodes.json").read_text(encoding="utf-8"))
    result,cohort,rows=calculate(episodes)
    write_outputs(args.output_root,result,cohort,rows,args.input_root)
    print(json.dumps({k:result[k] for k in ["cohort","estimates","gee","checks"]},indent=2))
if __name__=="__main__":main()
