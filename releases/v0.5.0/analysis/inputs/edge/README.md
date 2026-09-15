# Frozen inputs for edge statistics

These two JSONL tables retain all 465 candidate-change edges and all 783 referenced endpoint records from round 3, using an exact field whitelist. No row is sampled or removed. They support the recorded-decision statistics in `../../edge_statistics.py` and do not contain full review texts, candidate files, or absolute snapshot paths.

`manifest.json` records the retained fields, row counts, original full-source SHA-256 values, and the frozen-table SHA-256 values. The full source files were read only and were hash-checked unchanged while freezing. The source names are relative to the original Formalization workspace; those original files are not required to run the portable analysis.

The stored pass indicator has one narrow meaning: a record says pass. Fail, inconclusive, and partial remain separate original labels; none is a mathematical correctness label. Preserved document/hash/binding status fields are inherited audit metadata, not a new validation of original artifacts or actual independent execution. The high/medium confidence labels are inherited process-classification labels, not reviewer reliability grades.

`local_source_manifest.json` contains absolute local provenance paths. It is not a runtime input and must be excluded from a public package. The portable script reads only the two JSONL tables and `manifest.json`.

From the analysis directory, run:

```console
python -B edge_statistics.py --input-root inputs/edge --output-root .
```

Both options may point to another directory. Only the three result files are written. Existing NumPy and SciPy are required; the script installs nothing.
