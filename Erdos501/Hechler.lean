/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# First question of Erdős #501 — Hechler's counterexample under `CH`

PENDING INTEGRATION.  The verified proof (`Hechler501FC_master.lean`, sorry-free
at Mathlib master 355bc1e / Lean v4.34.0-rc1, session 2026-08-16/17) is to be
pasted here.  Construction: well-order `ℝ` by `r` with `ord #ℝ = type r`; under
`CH` every initial segment `{y | r y x}` is countable; put
`A x = {y | r y x ∧ |y| ≤ |x| + 1}` — bounded, countable hence null; an infinite
independent set would give `|y| + 1 < |x|` along `r`, and iterating `r`-minima
yields `|y| + n ≤ |m|` for all `n`, contradiction.
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.Analysis.Real.Cardinality

open MeasureTheory
open scoped Cardinal

universe u

namespace Erdos501

/-- Hechler (1972): under `CH` there is a family of bounded null sets with no
infinite independent set.  PENDING: proof from `Hechler501FC_master.lean`. -/
theorem hechler_of_CH (hCH : (ℵ₁ : Cardinal.{u}) = 𝔠) :
    ∃ (A : ℝ → Set ℝ),
      (∀ x, Bornology.IsBounded (A x)) ∧
      (∀ x, volume.toOuterMeasure (A x) < 1) ∧
      ¬ ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

end Erdos501
