# Predicate And Realization Comparison

This note goes below the theorem endpoints and checks the predicate definitions
that give the CH formula its mathematical meaning.

The main risk here is an argument-order or polarity error. For example, CH is
formalized through `at_most_f`, which realizes to `larger_than`; if that
realization flipped `x` and `y`, the final theorem could remain provable while
speaking about the wrong cardinal comparison.

## Result

No predicate-order flip or weakening was found in this pass.

The checked Lean 4 definitions preserve the Lean 3 mathematical content for:

- ground-model `PSet.is_func`,
- ground-model `PSet.is_surj`,
- Boolean-valued `is_func`, `is_total`, `is_func'`, `is_function`,
- Boolean-valued `is_surj`,
- `larger_than`,
- `surjects_onto`,
- formula realization for `is_func_f`, `is_total'_f₂`, `at_most_f`, and
  `injects_into_f`.

## Ground-Model PSet Predicates

Lean 3:

- `src/pSet_ordinal.lean:469`: `is_func x y f := Set.is_func mk(x) mk(y) mk(f)`
- `src/pSet_ordinal.lean:477`: `is_surj x y f` means every `b ∈ y` has
  some `a ∈ x` with pair `(a,b) ∈ f`
- `src/pSet_ordinal.lean:1002`: `is_func_iff` expands to subset of product
  plus unique output over every input
- `src/pSet_ordinal.lean:1052`: `functions x y` is selected out of
  `powerset (prod x y)` by `is_func x y`

Lean 4:

- `Flypitch4/PSetOrdinal.lean:486`: `PSet.is_func x y f := ZFSet.IsFunc mk(x) mk(y) mk(f)`
- `Flypitch4/PSetOrdinal.lean:498`: `PSet.is_surj x y f` means every `b ∈ y`
  has some `a ∈ x` with pair `(a,b) ∈ f`
- `Flypitch4/PSetOrdinal.lean:912`: `PSet.is_func_iff` expands to subset of
  product plus unique output over every input
- `Flypitch4/PSetOrdinal.lean:975`: `PSet.functions x y` is selected out of
  `powerset (pSet_prod x y)` by `is_func x y`

Assessment: preserved. The `PSet.is_surj` direction is the one used by the
collapse contradiction: domain first, codomain second.

## Boolean-Valued Function Predicates

Lean 3:

- `src/bvm_extras.lean:535`: `is_func f` is extensional functionality:
  two pairs with equal first coordinate have equal second coordinate
- `src/bvm_extras.lean:561`: `is_total x y f` says every `w₁ ∈ x` has
  some `w₂ ∈ y` with pair `(w₁,w₂) ∈ f`
- `src/bvm_extras.lean:585`: `is_func' x y f := is_func f ⊓ is_total x y f`
- `src/bvm_extras.lean:684`: `is_function x y f := is_func' x y f ⊓ f ⊆ prod x y`

Lean 4:

- `Flypitch4/BvmExtras.lean:996`: same `is_func f`
- `Flypitch4/BvmExtras.lean:1043`: same `is_total x y f`
- `Flypitch4/BvmExtras.lean:1084`: same `is_func' x y f`
- `Flypitch4/BvmExtras.lean:1273`: same `is_function x y f`

Assessment: preserved. Lean 4 proof code is more explicit, but the definitions
are the same.

## Boolean-Valued Surjection And Cardinal Comparison

Lean 3:

- `src/bvm_extras.lean:891`: `is_surj x y f` says every `v ∈ y` has some
  `w ∈ x` with pair `(w,v) ∈ f`
- `src/bvm_extras.lean:895`: `larger_than x y := ∃ S f, S ⊆ x ∧ is_func' S y f ∧ is_surj S y f`
- `src/bvm_extras.lean:981`: `is_surj_onto x y f := is_func' x y f ⊓ is_surj x y f`
- `src/bvm_extras.lean:983`: `surjects_onto x y := ∃ f, is_surj_onto x y f`

Lean 4:

- `Flypitch4/BvmExtras.lean:1663`: same `is_surj x y f`
- `Flypitch4/BvmExtras.lean:1668`: same `larger_than x y`
- `Flypitch4/BvmExtras.lean:1814`: same `is_surj_onto x y f`
- `Flypitch4/BvmExtras.lean:1817`: same `surjects_onto x y`

Assessment: preserved. In both ports, `larger_than x y` means a subset of `x`
surjects onto `y`. This is the intended "y is at most x" cardinal comparison.

## Formula Realization

Lean 3:

- `src/zfc.lean:408`: `realize_is_func_f = is_func`
- `src/zfc.lean:425`: `realize_is_total'_f₂ = is_total y x f`
- `src/zfc.lean:453`: `realize_at_most_f [y,x] = larger_than x y`
- `src/zfc.lean:468`: `realize_injects_into [y,x] = injects_into x y`
- `src/zfc.lean:485`: `CH_f_is_CH : value(CH_f) = CH₂`

Lean 4:

- `Flypitch4/Zfc.lean:605`: `realize_is_func_f = is_func`
- `Flypitch4/Zfc.lean:632`: `realize_is_total'_f₂ = is_total y x f`
- `Flypitch4/Zfc.lean:675`: `realize_at_most_f [y,x] = larger_than x y`
- `Flypitch4/Zfc.lean:706`: `realize_injects_into [y,x] = injects_into x y`
- `Flypitch4/Zfc.lean:735`: `CH_f_is_CH : value(CH_f) = CH₂`

Assessment: preserved. The most important orientation check is
`realize_at_most_f`: the Lean 4 statement keeps the Lean 3 environment order
`[y,x]` and still realizes to `larger_than x y`.

## Check Bridge Lemmas

Lean 3:

- `src/bvm_extras.lean:1238`: `check_not_is_func`
- `src/bvm_extras.lean:1273`: `check_not_is_surj`
- `src/bvm_extras.lean:1709`: `mem_functions_iff`

Lean 4:

- `Flypitch4/BvmExtras.lean:2203`: `check_not_is_func`
- `Flypitch4/BvmExtras.lean:2265`: `check_not_is_surj`
- `Flypitch4/BvmExtras.lean:3298`: `mem_functions_iff`

Assessment: preserved at statement shape. These are the key Boolean-valued to
ground-model bridge lemmas used by reflection and nonsurjection contradictions.
The Lean 4 `check_not_is_surj` proof explicitly follows the same witness
structure: choose `b ∈ y` that is missed by every `a ∈ x`, then contradict a
Boolean-valued surjectivity claim for `check f`.

## Statement-Shape Guard

`StatementShape.lean` was added to make several endpoint shapes executable as
elaboration checks. Run from `flypitch4`:

```sh
lake env lean validation/StatementShape.lean
```

It succeeds only if the final theorem, unprovability endpoints, collapse
omega-to-aleph1 theorem, nonsurjection lemma, and collapse CH endpoint still
have the expected mathematical types.

The script was run on this validation pass and completed successfully.

## Remaining Caveats

This is still a targeted comparison. It does not prove syntactic equality of
Lean 3 and Lean 4 formula ASTs. The next possible step would be to add more
`StatementShape.lean` examples for realization lemmas such as
`realize_at_most_f`, but the direct source comparison above already checks the
most likely orientation failure.
