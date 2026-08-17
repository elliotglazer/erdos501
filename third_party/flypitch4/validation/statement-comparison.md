# Lean 3 To Lean 4 Statement Comparison

This note compares the mathematically sensitive CH-independence statements in
the Lean 3 source under `src/` with their Lean 4 ports under `flypitch4/`.

The goal is not syntax equality. Lean 4 uses different names, namespaces,
coercions, and notation. The question is whether the Lean 4 statements are
mathematically as strong as the Lean 3 statements at the audited endpoints.

## Summary

No weakening was found in the checked theorem statements.

The audited Lean 4 statements preserve the same mathematical shape as the Lean
3 statements for:

- final independence,
- `ZFC`,
- `CH_f`,
- CH soundness against the Boolean-valued `CH₂`,
- Cohen forcing of not-CH,
- collapse forcing of CH,
- the omega-closed function reflection bridge,
- the collapse-side no-surjection contradiction,
- the final collapse `CH_true` endpoint.

The main deliberate Lean 4 change is that the collapse-side nonsurjection
contradiction is now factored into `no_pset_surj_omega_aleph_one`, rather than
being hidden inside larger proofs.

## Final Independence

Lean 3:

- `src/summary.lean:81`: `CH_unprovable : ¬ (ZFC ⊢' CH_f)`
- `src/summary.lean:84`: `neg_CH_unprovable : ¬ (ZFC ⊢' ∼CH_f)`
- `src/summary.lean:87`: `independent T f := ¬ T ⊢' f ∧ ¬ T ⊢' ∼f`
- `src/summary.lean:90`: `independence_of_CH : independent ZFC CH_f`

Lean 4:

- `Flypitch4/Summary.lean:121`: `CH_unprovable : ¬ (ZFC ⊢ₛ' CH_f)`
- `Flypitch4/Summary.lean:125`: `neg_CH_unprovable : ¬ (ZFC ⊢ₛ' (bd_not CH_f : sentence L_ZFC))`
- `Flypitch4/Summary.lean:129`: `independent T f := (¬ T ⊢ₛ' f) ∧ (¬ T ⊢ₛ' bd_not f)`
- `Flypitch4/Summary.lean:133`: `independence_of_CH : independent ZFC CH_f`

Assessment: preserved. The notation changed from Lean 3 `⊢'` and `∼` to Lean
4 `⊢ₛ'` and `bd_not`, but the two-sided unprovability statement is the same.

## ZFC Theory

Lean 3:

- `src/zfc.lean:378`: `ZFC : Theory L_ZFC`
- finite axioms: emptyset, ordered pairs, extensionality, union, powerset,
  infinity, regularity, Zorn's lemma
- collection schema over all `bounded_formula L_ZFC (n+2)`

Lean 4:

- `Flypitch4/Zfc.lean:564`: `ZFC : SentTheory L_ZFC`
- same finite axioms
- collection schema over all `bounded_formula L_ZFC (n + 2)`

Assessment: preserved. The type name changed from `Theory` to `SentTheory`;
the axiom set has the same mathematical content.

## CH Formula And Boolean Value

Lean 3:

- `src/zfc.lean:481`: `CH_f : sentence L_ZFC`
- shape: `∀ x, Ord x -> at_most omega x or at_most powerset(omega) x`
- `src/zfc.lean:485`: `CH_f_is_CH : ⟦CH_f⟧[V β] = CH₂`
- `src/zfc.lean:498`: `CH_f_sound : Γ ⊩[V β] CH_f ↔ Γ ≤ CH₂`
- `src/zfc.lean:501`: `neg_CH_f_sound : Γ ⊩[V β] ∼CH_f ↔ Γ ≤ -CH₂`

Lean 4:

- `Flypitch4/Zfc.lean:729`: `CH_f : sentence L_ZFC`
- same ordinal implication and two `at_most_f` substitutions
- `Flypitch4/Zfc.lean:735`: `CH_f_is_CH : ⟦CH_f⟧[V β] = CH₂`
- `Flypitch4/Zfc.lean:752`: `CH_f_sound : Γ ⊩[V β] CH_f ↔ Γ ≤ CH₂`
- `Flypitch4/Zfc.lean:756`: `neg_CH_f_sound : Γ ⊩[V β] bd_not CH_f ↔ Γ ≤ CH₂ᶜ`

Assessment: preserved. Lean 4 spells Boolean complement as `CH₂ᶜ` rather than
Lean 3 `- CH₂`; the statement is the same.

## Forcing Endpoints

Lean 3:

- `src/zfc.lean:511`: Cohen model forces `∼CH_f`
- `src/zfc.lean:518`: `CH_f_unprovable : ¬ (ZFC ⊢' CH_f)`
- `src/zfc.lean:529`: collapse model forces `CH_f`
- `src/zfc.lean:532`: `neg_CH_f_unprovable : ¬ (ZFC ⊢' ∼CH_f)`

Lean 4:

- `Flypitch4/Zfc.lean:770`: Cohen model forces `bd_not CH_f`
- `Flypitch4/Zfc.lean:775`: `CH_f_unprovable : ¬ (ZFC ⊢ₛ' CH_f)`
- `Flypitch4/Zfc.lean:786`: collapse model forces `CH_f`
- `Flypitch4/Zfc.lean:789`: `neg_CH_f_unprovable : ¬ (ZFC ⊢ₛ' bd_not CH_f)`

Assessment: preserved. The model endpoints still feed into
`unprovable_of_model_neg`; no endpoint was replaced by a direct consistency
axiom.

## Function Reflection

Lean 3:

- `src/forcing_CH.lean:334`: `function_reflect_of_omega_closed`
- output:

```text
exists f Γ', ⊥ < Γ' and Γ' ≤ Γ and Γ' ≤ check f =ᴮ g
  and pSet.is_func pSet.omega y f
```

Lean 4:

- `Flypitch4/ForcingCH.lean:407`: `function_reflect_of_omega_closed`
- output:

```text
exists f Γ', ⊥ < Γ' and Γ' ≤ Γ and Γ' ≤ check f =ᴮ g
  and PSet.is_func PSet.omega y f
```

Assessment: preserved. The Lean 4 statement makes several arguments explicit,
but the reflected object and output guarantee are the same: below a nonzero
condition, the Boolean-valued function is equal to a checked ground-model
`PSet` function from omega to `y`.

## Surjection Reflection

Lean 3:

- `src/forcing_CH.lean:559`: `surjection_reflect`
- assumption: a nonzero condition forces a surjection from Boolean-valued
  omega onto checked aleph1
- conclusion: there exists a `pSet` function from omega to aleph1 which is
  surjective

Lean 4:

- `Flypitch4/ForcingCH.lean:1191`: `surjection_reflect`
- assumption: a nonzero condition is below
  `surjects_onto bSet.omega (check pSet_aleph1)`
- conclusion:

```lean
∃ f : PSet,
  PSet.is_func PSet.omega (PSet.card_ex (Cardinal.aleph 1)) f ∧
  PSet.is_surj PSet.omega (PSet.card_ex (Cardinal.aleph 1)) f
```

Assessment: preserved. Lean 4 uses the abbreviation
`pSet_aleph1 := PSet.card_ex (Cardinal.aleph 1)` at the Boolean-valued side
and the expanded expression in the conclusion. This is not a weakening.

## Omega Is Smaller Than Aleph One

Lean 3:

- `src/forcing_CH.lean:595`: `omega_lt_aleph_one {Γ} : Γ ≤ bSet.omega ≺ ℵ₁̌`
- proof calls `surjection_reflect` and contradicts
  `ex_no_surj_omega_aleph_one`

Lean 4:

- `Flypitch4/ForcingCH.lean:1231`: `omega_lt_aleph_one_collapse`
- statement:

```lean
Γ ≤ (larger_than bSet.omega (check pSet_aleph1) : 𝔹_collapse)ᶜ
```

- proof reflects a Boolean-valued surjection back to a checked `PSet` function
  and contradicts `no_pset_surj_omega_aleph_one`

Assessment: preserved, with a clearer local contradiction. Lean 3's `≺`
notation is the complement of `larger_than`; Lean 4 expands that notation in
the theorem statement. The mathematical content is the same.

## Collapse CH Endpoint

Lean 3:

- `src/forcing_CH.lean:610`: `aleph_one_check_le_of_omega_lt`
- `src/forcing_CH.lean:632`: `aleph_one_not_lt_powerset_omega`
- `src/forcing_CH.lean:639`: `CH_true : (⊤ : β) ≤ CH`

Lean 4:

- `Flypitch4/ForcingCH.lean:1275`: `aleph_one_check_le_of_omega_lt_collapse`
- `Flypitch4/ForcingCH.lean:1315`: `aleph_one_not_lt_powerset_omega`
- `Flypitch4/ForcingCH.lean:1334`: `CH_true : (⊤ : 𝔹_collapse) ≤ CH`

Assessment: preserved. The Lean 4 endpoint specializes the theorem to
`𝔹_collapse`, matching how the result is consumed by `Zfc.lean`.

## Findings

No statement weakening was found in this pass.

The checked Lean 4 statements preserve the Lean 3 mathematical endpoints. The
main change is proof organization: Lean 4 exposes the omega-to-aleph1
nonsurjection as `no_pset_surj_omega_aleph_one`, making the cardinal obstruction
more auditable than the duplicated inline proofs.

## Remaining Caveats

This was a targeted statement comparison, not a full AST-level formula
equivalence proof. The next deeper checks would be:

1. Compare the definitions of `larger_than`, `surjects_onto`, `is_surj`, and
   `is_function` line by line between Lean 3 and Lean 4.
2. Compare the realization lemmas for `at_most_f`, `is_func_f`,
   `is_total'_f₂`, and `injects_into_f`.
3. Compare the dense omega-closed reflection hypotheses around
   `function_reflect_of_omega_closed`.
4. Add exact `#check` or theorem-shape assertions for the critical statements
   if we want CI to fail on accidental weakening.
