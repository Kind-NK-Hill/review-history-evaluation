# Selected passages: `docs/phase2/review_criteria.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/phase2/review_criteria.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## Source review

Semantic review is an independent textbook-fidelity review. It is not a build
check, audit pass, classification check, or ledger check.

A valid review must:

- be performed by an independent read-only reviewer;
- bind to the current review request, prompt version, rubric version,
  candidate hash, review-basis hash, and review subject;
- inspect the source TeX and the Lean subject directly;
- map source claims to Lean declarations, assumptions, and conclusions;
- preserve the source proof spine at an appropriate abstraction level;
- inspect proof obligations as checklist/context when present;
- inspect audit, classification, dependency, downstream/import, ledger, and
  hash evidence without letting any one of them decide completion;
- check direct downstream consumers when listed;
- reject missing, weakened, public-premise, private-axiom, adapter-only, or
  open-debt routes as clean proof completion;
- state `proof_class` and `completion_class`.

## Mathlib and bridges

For shared mathematical interfaces, follow
[textbook-first, bridge-then-Mathlib](../interface_dependency_policy.md).

Textbook fidelity does not forbid Mathlib. Mathlib may be used as reusable
infrastructure or through reviewed equivalence bridges.

A valid bridge must be more general than the current task, reusable outside it,
and mapped by review to the specific source proof step it discharges.

If a bridge has the same mathematical payload as the current task, review it as
the task proof itself. It is not infrastructure.
