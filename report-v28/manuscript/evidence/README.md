# Evidence sources for English revision 11

The manuscripts explain the methods and the consequences of the recorded decisions. This directory retains the lower-level source correspondence for checking those explanations; its run IDs, session IDs and fingerprints are not additional experimental results.

`r9_rewrite_evidence/` is an unchanged copy of the targeted evidence package introduced in revision 10. The package's own [README](r9_rewrite_evidence/README.md), [source index](r9_rewrite_evidence/sources/SOURCE_INDEX.json), [excerpt collection](r9_rewrite_evidence/EVIDENCE.md) and [checksum list](r9_rewrite_evidence/SHA256SUMS.txt) retain its provenance. The A/B/C/D/E source codes below belong to that package, not to the experimental configuration names.

## Reference 30 — post-submission evaluation

The principal procedural source is the [archived endpoint-program excerpt](r9_rewrite_evidence/sources/A06.txt). It specifies frozen subject inputs, the two-result decision rule, the single-adjudication branch, identity validation and read-only requirements. Actual request text is retained in AP01–AP11: [original reviewer](r9_rewrite_evidence/sources/AP01.txt), [original adjudicator](r9_rewrite_evidence/sources/AP02.txt), [H1 initial review](r9_rewrite_evidence/sources/AP05.txt), [H1 adjudication](r9_rewrite_evidence/sources/AP06.txt), [L2 initial review](r9_rewrite_evidence/sources/AP07.txt), [L2 adjudication](r9_rewrite_evidence/sources/AP08.txt), [L3 initial review](r9_rewrite_evidence/sources/AP09.txt), [L3 adjudication](r9_rewrite_evidence/sources/AP10.txt) and [targeted L7 review](r9_rewrite_evidence/sources/AP11.txt).

The [114-call index](r9_rewrite_evidence/EVALUATION_INDEX.csv) and [retained call evidence](r9_rewrite_evidence/sources/A40-call-evidence.json) distinguish requests, local receipts, raw model results, host-generated result states, candidate mappings and subsequent decisions. The revision-10 inspection checked those recorded fields and their consistency; it does not obtain a provider-returned model identity or re-evaluate all mathematical opinions. All indexed requests and local receipts record `gpt-5.6-sol`, medium; all 114 session IDs are distinct, and their source-session fields are empty. The 11 earlier provisional evaluations are outside this index.

The stage-specific sources are [L2 rules](r9_rewrite_evidence/sources/A10.json), [H1 rules](r9_rewrite_evidence/sources/A11.json), [H1 delivery-input addition](r9_rewrite_evidence/sources/A12.json), [original delivery provenance](r9_rewrite_evidence/sources/A13.json), [L3 readings](r9_rewrite_evidence/sources/A14.json), [L3 dimension rules](r9_rewrite_evidence/sources/A15.json), [L3 tail clarification](r9_rewrite_evidence/sources/A16.json), and the A18–A21 review plans. [A34](r9_rewrite_evidence/sources/A34.json) and [A35](r9_rewrite_evidence/sources/A35.json) retain the two targeted L7 opinions. [A01](r9_rewrite_evidence/sources/A01.txt) gives the adopted criteria, [A02](r9_rewrite_evidence/sources/A02.json) the current outcomes, [A03](r9_rewrite_evidence/sources/A03.json) processing corrections, and [A04](r9_rewrite_evidence/sources/A04.json) the already recorded regressions. Those regressions were not rerun for either editorial revision.

## Reference 31 — runs, inputs and missing usage

The [run index](r9_rewrite_evidence/RUN_INDEX.csv) retains all 41 roots and identifies the 33 main-panel selections. [B03](r9_rewrite_evidence/sources/B03.txt) is the original aggregation-code excerpt: it selects the first complete candidate with a common decision in each bound list, otherwise the first common-evaluated delivery, and then applies the version filter. [B01](r9_rewrite_evidence/sources/B01.json) records version denominators; [B07](r9_rewrite_evidence/sources/B07-root-bindings.json) retains candidate, implementation, model and allowance fields. This is evidence of the saved retrospective selection, not of a pre-solve registration.

[B11](r9_rewrite_evidence/sources/B11-input-comparison.json) compares source, task and upstream manifests in the selected common-evaluation bundles for all three arms. The vector-convergence exception is explained by the [empty target file](r9_rewrite_evidence/sources/B12.txt). [B04](r9_rewrite_evidence/sources/B04.json) records the bounded L2 container/library investigation. The original-versus-centered-moment wording remains in [B09](r9_rewrite_evidence/sources/B09.txt) and [B10](r9_rewrite_evidence/sources/B10.txt).

[B08](r9_rewrite_evidence/sources/B08-missing-usage.json) identifies the 11 calls with missing usage, allowing the manuscripts to locate the affected tasks without printing the call IDs. [B02](r9_rewrite_evidence/sources/B02.json) retains the metric definitions and common-group membership. No missing usage was replaced with zero, and the existing time and token denominators were not changed.

## Reference 32 — historical qualification and saved-code sampling

[C05](r9_rewrite_evidence/sources/C05.txt) records the decision-validation and projection rules; [C01](r9_rewrite_evidence/sources/C01.json) the 131 explicit target decisions and 462-relation coverage; [C06](r9_rewrite_evidence/sources/C06.json) the historical revision provenance; and [C07](r9_rewrite_evidence/sources/C07.json) the retained decision records. The source-reader role is explicitly AI-assisted and unblinded to the historical outcomes. Mechanical validation of decision sources is distinct from the semantic judgments they contain.

The three examples in Appendix C.4 use the [affirmative coupon relation](r9_rewrite_evidence/sources/C02-decision.txt) with its [frame-membership row](r9_rewrite_evidence/sources/C02-map.txt), the [independent-sum target boundary](r9_rewrite_evidence/sources/C03-decision.txt) with its [frame-membership row](r9_rewrite_evidence/sources/C03-map.txt), and the [unknown compactness relation](r9_rewrite_evidence/sources/C04-map.txt). They are reproduced historical decisions, not three new semantic assessments.

[E01](r9_rewrite_evidence/sources/E01.txt) and [E02](r9_rewrite_evidence/sources/E02.json) specify the saved-code sampling rule. A recorded task/content or proof-spine difference assigns the changed stratum; the remaining stratum includes noncomparable fields. That metadata screen is not affirmative semantic target qualification.

## Reference 33 — innovation review recovery

[D01](r9_rewrite_evidence/sources/D01.json) is the recovery receipt; [D02](r9_rewrite_evidence/sources/D02.json) the referenced actor receipt; [D03](r9_rewrite_evidence/sources/D03.json) the retained review JSON; [D04](r9_rewrite_evidence/sources/D04.json) the controller state; and [D05](r9_rewrite_evidence/sources/D05.txt) the session-opening and final-public-output excerpts. They support the retained content and observed controller state while preserving the conflicting session field. They do not independently re-read the recovery destination in the historical container or establish the unique cause of the field mismatch.

## References 34–36 — public project documentation

[The documentation guide](project_docs/README.md) identifies the seven public files read for revision 11. Their selected passages describe the task lifecycle, repair and scheduling decisions, staged and canonical work, evidence coverage, textbook–Mathlib interfaces and the isolated workflow demonstration. [The manifest](project_docs/manifest.json) retains the fixed public revision and the original document identities separately from the checksums of the extracted passages. These source documents describe the operating design; they do not replace the instructions, candidates or receipts of the experimental runs.

## Earlier archive locators

The manuscripts retain the substantive methods, tables and mathematical arguments derived from the earlier archive. That wider archive is not included in this targeted package. Its original relative entry points are listed here as locators, not as working links within this delivery:

```text
historical E: ../../../pipeline_evolution/releases/v0.3.1/evidence/manifest.json
R: ../../revision_v3_20260911/baseline/REPORT_SOURCES.json
N: ../../increment_v2_20260911/REPORT_EVIDENCE.v2.json
U: ../../revision_v3_20260911/evidence/U_MAPPING.json
U claims: ../../revision_v3_20260911/evidence/latest/CLAIMS.json
Q/X/Y/Z/I: ../combined_revision_v7_20260912/source_manifest.json
```

The evidence copy preserves the supplied local archive references and excerpts. It is a working research supplement, not a claim that the full private corpus has been cleared or packaged for public distribution.
