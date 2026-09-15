# Selected passages: `docs/dependency_decision_trail.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/dependency_decision_trail.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## Purpose

The workspace state database records the current task projection, including
which hard dependencies and soft imports are active. The frozen legacy
`project_ledger.json` remains compatibility/history evidence.

The dependency decision trail records why an import was chosen.  It is an audit
log, not a replacement for workspace state.

## Phase responsibilities

- Phase 1 records hard dependencies from operator declarations and explicit
  textbook references.
- Phase 1 plans are source-unit scoped.  A source unit is one numbered
  subsection, optionally with chapter intro for the first subsection, or one
  Problems section.  Do not use a whole-chapter plan as dependency authority.
- Phase 2 `soft-apply` records problem soft imports.
- Phase 2 consumes the final import union and writes
  `dependency_decision_context.*` into each prompt pack.
- Phase 2 `build-check` records undeclared local imports as violations.
- The current CLI does not materialize external offload manifests. Old `materialized` records, if present, are legacy audit data.
