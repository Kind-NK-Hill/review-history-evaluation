# Selected passages: `docs/workflow_demo.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/workflow_demo.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## What the demonstration provides

The [teaching fixture](../examples/workflow-demo/) runs the **production** Python
pack, Lean build, review request, review-result validation, freshness check, and
apply functions against a new, isolated runtime and SQLite database. Compilation
is real. The default semantic opinions are recorded teaching reviews.

The fixture is newly authored, outside the 452-task textbook catalog. It uses
Lean's standard library to avoid downloading Mathlib for a tiny example. It
defines a rounded per-thousand frequency on valid counts. This is an interface
example, not a new probability theorem or an accuracy benchmark.

## Repair and stale-review steps

5. The interface-only repair adds the conditions. The **real Lean build fails**
   because the old caller supplies too few arguments.
6. The complete repair supplies the caller's conditions. It builds and receives
   a passing teaching opinion.
7. A newly built candidate intentionally reintroduces the old interface. The
   previously passing review is rejected by the production freshness gate.
   Existing candidate and review receipts are preserved.
8. The complete repair is rebuilt and gets a newly bound review request. Only
   its corresponding result reaches the production apply gate, which builds
   and writes the isolated canonical file.

The caller is a declaration in the same Lean file. This deliberately small
example demonstrates call-interface migration, not an atomic transaction across
multiple catalog tasks. The original public historical cases remain separate.

## Replay and external review

The demo mechanically fills a **simulated protocol envelope** with each new
temporary request's hashes and evidence fields. Every replay result states that
no reviewer inspected that new runtime. The independence-shaped schema fields
inside that envelope demonstrate the gate protocol; they are not a fresh
independence attestation. Rebinding cannot convert a recorded opinion into new
mathematical authority, and these results must never be imported into the live
catalog. No runtime acceptance rule is weakened for this example.

Use an existing independent reviewer runner. This script starts no new service
and assumes no provider. Its command is supplied as an argument array, without a
shell. For example, adapt the paths and arguments to your actual runner:
