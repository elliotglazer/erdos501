# Flypitch4 Validation 2

This is the second validation pass for the Lean 4 `flypitch4` port. The first
pass in `VALIDATION.md` checked that `independence_of_CH` builds, has the
expected axiom profile, and does not depend on active proof holes. This pass
focused on the mathematical risk that a port can compile while proving a weaker
statement than the Lean 3 source.

## Main Question

The validation question was:

> Do the Lean 4 CH-independence endpoints and the deeper forcing predicates
> still match the Lean 3 mathematical statements?

The answer from this pass is: no weakening was found in the checked theorem
statements or cardinal-comparison predicates.

## What Was Added

The detailed material lives in `validation/`:

- `validation/statement-comparison.md`
- `validation/predicate-comparison.md`
- `validation/axiom-audit.md`
- `validation/AxiomAudit.lean`
- `validation/StatementShape.lean`

These files compare the Lean 3 sources under `../src/` against the Lean 4 port
under `Flypitch4/`.

## Statement Comparison

The checked Lean 4 endpoints preserve the Lean 3 theorem shapes for:

- `independence_of_CH`
- `CH_unprovable`
- `neg_CH_unprovable`
- `ZFC`
- `CH_f`
- `CH_f_is_CH`
- the Cohen model forcing not-CH
- the collapse model forcing CH
- `function_reflect_of_omega_closed`
- `surjection_reflect`
- `omega_lt_aleph_one_collapse`
- `collapse_algebra.CH_true`

The notation changed, but the mathematical content stayed aligned. Lean 3 uses
notations such as `⊢'`, `∼`, and `-CH₂`; Lean 4 uses `⊢ₛ'`, `bd_not`, and
`CH₂ᶜ`.

## Predicate Comparison

The lower-level predicate pass checked the definitions most likely to hide a
subtle orientation bug:

- `PSet.is_func`
- `PSet.is_surj`
- `is_func`
- `is_total`
- `is_func'`
- `is_function`
- `is_surj`
- `larger_than`
- `surjects_onto`
- `realize_at_most_f`
- `realize_injects_into`
- `CH_f_is_CH`

No argument-order flip was found. In both Lean 3 and Lean 4:

```text
larger_than x y
```

means that some subset of `x` surjects onto `y`.

The key CH realization also preserves the same orientation:

```text
realize_at_most_f [y, x] = larger_than x y
```

This is the most important check for the first-order CH formula, because a
swap here would change the cardinal comparison while leaving many later proofs
well-typed.

## Collapse Bridge

The most sensitive object-level bridge remains the collapse-side argument that
there is no ground-model surjection:

```text
PSet.omega -> pSet_aleph1
```

The Lean 4 port now isolates that fact as:

```lean
collapse_algebra.no_pset_surj_omega_aleph_one
```

The proof extracts a type-level surjection from a hypothetical
`PSet.is_surj PSet.omega pSet_aleph1 h`, derives:

```lean
#(pSet_aleph1.Type) <= #(PSet.omega.Type)
```

and contradicts:

```lean
PSet.omega_lt_aleph_one
```

This is the right cardinal obstruction for the collapse proof.

## Runnable Checks

Two reusable Lean validation scripts were added and run during this validation
pass.

The intermediate axiom audit was run from `flypitch4` with:

```sh
lake env lean validation/AxiomAudit.lean
```

Result: passed. Every checked declaration reported only:

```text
[propext, Classical.choice, Quot.sound]
```

The theorem-shape guard was run from `flypitch4` with:

```sh
lake env lean validation/StatementShape.lean
```

Result: passed. This script prints nothing on success and fails if key theorem
shapes are weakened or no longer elaborate as expected.

## Conclusion

This second pass found no evidence that the Lean 4 port has weakened the CH
independence endpoints or flipped the relevant cardinal-comparison predicates.

The remaining most useful mathematical validation would be to add more
`StatementShape.lean` examples for formula-realization lemmas, especially
`realize_at_most_f`, so future edits fail fast if the CH cardinal comparison
changes orientation.
