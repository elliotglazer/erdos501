import Flypitch4.Summary
import Flypitch4.SummaryRandom

open scoped Flypitch
open Fol bSet
open collapse_algebra Flypitch

/-!
This file checks the theorem shapes most likely to be accidentally weakened
during porting. Run it with:

  lake env lean validation/StatementShape.lean

Unlike `AxiomAudit.lean`, this file does not print anything on success. It
fails to elaborate if one of the checked declarations no longer has the
expected mathematical type.
-/

example : independent ZFC CH_f :=
  independence_of_CH

example : ¬ Fol.SentTheory.sprovable ZFC CH_f :=
  CH_unprovable

example : ¬ Fol.SentTheory.sprovable ZFC (bd_not CH_f : sentence L_ZFC) :=
  neg_CH_unprovable

example {β : Type 0} [NontrivialCompleteBooleanAlgebra β] :
    Fol.all_forced_in (⊤ : β) (V β) ZFC :=
  fundamental_theorem_of_forcing

example {Γ : collapse_algebra.𝔹_collapse} :
    Γ ≤ (bSet.larger_than bSet.omega
      (check (𝔹 := collapse_algebra.𝔹_collapse) pSet_aleph1) :
      collapse_algebra.𝔹_collapse)ᶜ :=
  collapse_algebra.omega_lt_aleph_one_collapse

example :
    ∀ {h : PSet}, PSet.is_func PSet.omega pSet_aleph1 h →
      ¬ PSet.is_surj PSet.omega pSet_aleph1 h :=
  fun {h} => collapse_algebra.no_pset_surj_omega_aleph_one (h := h)

example {Γ : 𝔹_collapse} :
    Γ ≤ bSet.larger_than (check pSet_aleph1 : bSet 𝔹_collapse) (bv_powerset bSet.omega) := by
  simpa using (collapse_algebra.aleph_one_not_lt_powerset_omega (Γ := Γ))

example : (⊤ : 𝔹_collapse) ≤ CH :=
  collapse_algebra.CH_true

-- Alternative proof of `CH_unprovable` via the ℵ₂-random algebra: same statement.
example : ¬ Fol.SentTheory.sprovable ZFC CH_f :=
  CH_unprovable_random

example : independent ZFC CH_f :=
  independence_of_CH_random

example : (⊤ : 𝔹_random) ≤ (CH : 𝔹_random)ᶜ :=
  bSet.neg_CH_random

example : Fol.forced_in (⊤ : 𝔹_random) (V 𝔹_random) (bd_not CH_f : sentence L_ZFC) :=
  V_𝔹_random_models_neg_CH

-- The random algebra is the measure algebra of the fair-coin product measure on `2^(ℵ₂ × ω)`.
example : 𝔹_random = Flypitch.MeasureAlgebra (Flypitch.RandomAlgebra.μ_random PSet.pSet_aleph2.Type) := rfl
