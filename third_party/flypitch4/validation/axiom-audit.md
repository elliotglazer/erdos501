# Intermediate Axiom Audit

This records the reusable axiom audit added in `AxiomAudit.lean`.

## Command

Run from `flypitch4`:

```sh
lake env lean validation/AxiomAudit.lean
```

## Checked Declarations

The script prints axiom dependencies for the final theorem, the two
unprovability endpoints, the CH soundness/model endpoints, and the
collapse-side bridge lemmas:

- `independence_of_CH`
- `CH_unprovable`
- `neg_CH_unprovable`
- `CH_f_unprovable`
- `neg_CH_f_unprovable`
- `V_𝔹_cohen_models_neg_CH`
- `V_𝔹_collapse_models_CH`
- `CH_f_is_CH`
- `collapse_algebra.CH_true`
- `collapse_algebra.CH₂_true`
- `collapse_algebra.aleph_one_not_lt_powerset_omega`
- `collapse_algebra.aleph_one_check_le_of_omega_lt_collapse`
- `collapse_algebra.omega_lt_aleph_one_collapse`
- `collapse_algebra.surjection_reflect`
- `collapse_algebra.no_pset_surj_omega_aleph_one`

## Result

Every checked declaration reported the same dependency set:

```text
[propext, Classical.choice, Quot.sound]
```

No project-specific axiom, `axiom`, or hidden assumption appeared in any of
these endpoint axiom profiles.

## Raw Output

```text
'independence_of_CH' depends on axioms: [propext, Classical.choice, Quot.sound]
'CH_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'neg_CH_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'CH_f_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'neg_CH_f_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'V_𝔹_cohen_models_neg_CH' depends on axioms: [propext, Classical.choice, Quot.sound]
'V_𝔹_collapse_models_CH' depends on axioms: [propext, Classical.choice, Quot.sound]
'CH_f_is_CH' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.CH_true' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.CH₂_true' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.aleph_one_not_lt_powerset_omega' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.aleph_one_check_le_of_omega_lt_collapse' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.omega_lt_aleph_one_collapse' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.surjection_reflect' depends on axioms: [propext, Classical.choice, Quot.sound]
'collapse_algebra.no_pset_surj_omega_aleph_one' depends on axioms: [propext, Classical.choice, Quot.sound]
```
