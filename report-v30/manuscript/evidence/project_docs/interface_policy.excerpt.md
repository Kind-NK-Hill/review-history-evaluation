# Selected passages: `docs/interface_dependency_policy.md`

[Original document](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/interface_dependency_policy.md)

The headings below are editorial locators. Text under each heading is excerpted verbatim; intervening sections may be omitted. Original relative links are preserved as source text and are not package navigation.

## Representations and the interface problem

The problem is that the same mathematical idea can often be written in Lean in
two different ways:

1. using a project definition introduced from the textbook
2. using the standard Mathlib definition or notation

If an earlier theorem uses one way and a later theorem uses the other way,
importing the earlier theorem may not be enough to use it directly. A separate
translation lemma may be needed.

## Rule for new shared concepts

Use this order for a new important concept:

1. When the concept is first introduced, define it in the textbook style.
2. Prove the first few basic properties in that textbook style.
3. If Mathlib already has the same idea, or a more general version of it, prove
   a theorem connecting the textbook version to the Mathlib version.
4. After that connection is available, later files should usually use the
   Mathlib version.

This policy is for shared mathematical interfaces and recurring textbook
notation. It is not a requirement that every local lemma go through a full
textbook-definition, bridge, and Mathlib cycle.

## Existing files

Do not rewrite existing runnable Lean files only to make every file use one
style.

Keep the current Chapter 1-8 output unless a specific reuse problem appears.

When a later task needs to use an earlier theorem but the two statements use
different ways of writing the same idea, add a translation lemma.

If there are duplicate local definitions, do not do a large cleanup only for
neatness. Record the issue, and fix it when it blocks reuse.

## Common notation and dependency reasons

Common notation such as `E[X]`, integrals, distributions, and Stieltjes
integrals should be recorded as mathematical context.

It should not automatically become a Lean import.

For example, a task that mentions `E[X]` should not automatically import
`def_6_7` only because expectation appears in the textbook text. The Lean file
should import `def_6_7` only if it actually uses the project `expectation`
definition or a theorem stated with that definition.

When a common notation does become a Lean dependency, record the reason in the
dependency decision trail.  The record should say whether the import was needed
because of an explicit text reference, a theorem stated with the project
definition, or an interface translation between the textbook interface and
Mathlib.
