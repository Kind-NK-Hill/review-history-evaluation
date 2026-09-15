# Selected passages: `docs/architecture.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/architecture.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## Opening and source lifecycle

ProbabilityTheoryFormalization develops AI-assisted textbook formalization
through separate build, independent review, and apply gates. Python coordinates
the workflow; Lean checks the formal code; SQLite indexes retained evidence.

Source ingestion and planning require source material supplied by the operator.
The public release includes code and a build manifest, while the owner's source
corpus, plans, catalog policy, upstream snapshots, and operational database remain
private. A public clone can compile the corpus and run the isolated demonstration;
it cannot reconstruct the owner's completion verdict from the build manifest.

## Review preparation and application

`review-now` prepares the request and exposes the next action. The outer agent or
operator invokes an independent reviewer; preparation alone does not run a model
or complete the task. Failed reviews lead to repair, and a changed subject or
review basis rejects stale evidence before acceptance. Application restores prior
canonical bytes on failure.

## Demonstration

The [complete workflow demonstration](workflow_demo.md) exercises these production
functions with real Lean builds and an isolated SQLite database. Its default
recorded teaching opinions are replayed in an explicitly simulated protocol
envelope. They are not new model judgments or textbook-catalog authority. The
same runner can invoke a separately configured, independent external reviewer.
