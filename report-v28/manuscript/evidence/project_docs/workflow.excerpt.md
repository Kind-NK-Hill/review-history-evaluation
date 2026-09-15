# Selected passages: `docs/phase2/workflow.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/phase2/workflow.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## Repair loop: unchanged candidates and diagnosis

After a semantic review failure, `auto-loop` will not send the same candidate
hash back to semantic review. If build succeeds but the candidate is unchanged,
the loop returns to authoring; the agent must modify `draft.lean` or the
related Lean proof artifact before continuing. This counts against the current
round's build budget, not as a new review round.

A precise missing lemma, bridge theorem, or source-route gap is not a terminal
success condition. It is the next repair target for the loop unless the current
goal explicitly asks only for diagnosis.

Semantic review failures are triaged before ordinary repair. If the failed
review reads as a route/source/statement problem, such as a Mathlib-backed
adapter, public-premise relocation, private axiom, open math debt, source
mismatch, statement mismatch, or unclear semantic route failure, Phase2 writes:

```text
semantic_fail_triage_vN.json
prepared_diagnoser_prompt_vN.txt
```

and pauses ordinary `auto-loop` repair with `diagnoser_required`. The diagnoser
is read-only route diagnosis, not a second semantic reviewer and not an author.
It must not edit Lean files, official output, or the ledger. If the review only
reports a missing small/medium lemma inside an accepted route, Phase2 continues
ordinary repair without generating another diagnoser prompt.

## Batch planning

`batch-plan` reads the ledger and existing Phase2 metadata, then tells the
operator which tasks need fresh existing review, which should enter `auto-loop`,
which need Math Review Gate evidence, and which are blocked by upstream tasks.
It is a scheduler/report only. It does not execute repair and cannot land
completion.

When `batch-plan` is run with `--batch-limit`/`--batch-workers`, its visible
table is an executable worker queue. It filters out `reviewer_required` and
`diagnoser_required`, and `math_review_gate_required` rows. An empty table
therefore means there are no ordinary author actions; it does not mean the goal
is blocked for user input. Inspect the underlying task states and dispatch
reviewer/diagnoser/math-review subagents as needed.

This keeps Problem tasks out of the first queue, ranks candidates by downstream
fanout after dependency analysis, and prints worker slots plus conflict groups.
The default queue should be parent-facing failed/blocked tasks first; legacy
child obligations are not worker assignments unless `--batch-include-legacy` is
explicitly requested.
The worker slots are for subagent coordination only. They do not create
subagents, bypass review independence, or make batch planning a completion
authority.

## Existing-output review

Failed or inconclusive existing-output review preserves official output by
default and records repair-required evidence. Quarantine is explicit
maintenance after downstream/import checks, not the default apply outcome.
