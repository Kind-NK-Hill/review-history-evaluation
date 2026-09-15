# Frozen statistical projections

These files are exact copies of the selected version 0.2.0 analysis materials. The source-to-copy hashes are recorded in `../evidence/SOURCE_MAP.json`. No statistical model was re-estimated for this writing edition.

`inputs/edge/` supplies the 465 selected revision edges and endpoint records used by `edge_statistics.py`. `inputs/process/episodes.json` supplies all 262 complete high-confidence segments; `process_analysis.py` selects the 230 explicit failure origins and observes them to first pass or boundary. Its 329 rows belong to 182 task groups.

Run either script with a separate `--output-root`, as documented in `../README.md`, to preserve the supplied results. The scripts need their frozen projections and companion manifests, not the original database. Machine-local source manifests are excluded. Full-history source paths recorded as provenance in manifests are not runtime input paths.

Interpretation remains conditional: recorded pass is not semantic truth, task clustering does not prove independence between tasks, and first-versus-later associations do not estimate the causal value of another revision. Reference intervals and tests apply only under the stated task model. Full raw experiment evidence is outside this selected statistical package.
