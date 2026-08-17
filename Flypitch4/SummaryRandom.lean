/-
Copyright (c) 2026 The Flypitch Project. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Summary of the alternative consistency proof of ¬CH via the ℵ₂-random algebra.
-/
import Flypitch4.Summary
import Flypitch4.ForcingRandom

/-!
# Summary: `¬CH` is consistent — via the `ℵ₂`-random algebra

`Summary.lean` proves `independence_of_CH : independent ZFC CH_f`, where the unprovability of
`CH_f` is witnessed by the Boolean-valued model `V 𝔹_cohen` for the *Cohen algebra*
`𝔹_cohen` (the regular open algebra of `2^(ℵ₂ × ω)`).

This file records the alternative proof of the same unprovability statement, using instead the
*`ℵ₂`-random algebra* `𝔹_random`, i.e. the measure algebra (measurable sets modulo null sets)
of the product measure on `2^(ℵ₂ × ω)`, see

* `Flypitch4/MeasureAlgebra.lean` — measure algebras of finite measures are complete Boolean
  algebras satisfying the countable chain condition;
* `Flypitch4/RandomAlgebra.lean` — the `ℵ₂`-random algebra and its "random bits";
* `Flypitch4/ForcingRandom.lean` — `V 𝔹_random ⊨ ¬CH`, and hence `ZFC ⊬ CH_f`.
-/

open Fol bSet Flypitch

/-- The `ℵ₂`-random algebra is the measure algebra of the fair-coin product measure on
`ℵ₂ × ω → 2` (presented as `ℵ₂ → (ω → 2)`). -/
example : 𝔹_random = MeasureAlgebra (RandomAlgebra.μ_random PSet.pSet_aleph2.Type) := rfl

example : RandomAlgebra.μ_random PSet.pSet_aleph2.Type =
    MeasureTheory.Measure.infinitePi (fun _ : PSet.pSet_aleph2.Type => RandomAlgebra.cantorMeasure) :=
  rfl

example : RandomAlgebra.cantorMeasure =
    MeasureTheory.Measure.infinitePi (fun _ : ℕ => RandomAlgebra.fairCoin) := rfl

/-- The random algebra is a nontrivial complete Boolean algebra ... -/
noncomputable example : NontrivialCompleteBooleanAlgebra 𝔹_random := inferInstance

/-- ... satisfying the countable chain condition. -/
theorem random_algebra_CCC : CCC 𝔹_random := 𝔹_random_CCC

/-- **The random algebra forces `¬CH`.** -/
theorem random_algebra_forces_neg_CH : (⊤ : 𝔹_random) ≤ CHᶜ := neg_CH_random

/-- The Boolean-valued model `V 𝔹_random` is a model of `ZFC` ... -/
theorem V_random_models_ZFC : ⊤ ⊩ₜ[V 𝔹_random] ZFC := bSet_models_ZFC

/-- ... in which the first-order sentence `CH_f` fails. -/
theorem V_random_models_neg_CH_f : ⊤ ⊩[V 𝔹_random] (bd_not CH_f : sentence L_ZFC) :=
  V_𝔹_random_models_neg_CH

/-- **The Continuum Hypothesis is not provable from `ZFC`** — via the `ℵ₂`-random algebra.
This is the same statement as `CH_unprovable` in `Summary.lean`, with an independent proof. -/
theorem CH_unprovable_random : ¬ (ZFC ⊢ₛ' CH_f) := CH_f_unprovable_random

/-- **The independence of the Continuum Hypothesis**, with the unprovability half proved via
the random algebra. -/
theorem independence_of_CH_random : independent ZFC CH_f :=
  ⟨CH_unprovable_random, neg_CH_unprovable⟩

#print axioms independence_of_CH_random
#print axioms CH_unprovable_random
#print axioms random_algebra_forces_neg_CH
#print axioms random_algebra_CCC
