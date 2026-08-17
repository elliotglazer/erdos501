/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Second question of Erdős #501 — closed sets of measure `< 1` (NPS87)

PENDING INTEGRATION.  The verified proof (`Erdos501.lean`, ≈580 lines,
sorry-free at Mathlib master 355bc1e / Lean v4.34.0-rc1, session 2026-08-16)
is to be pasted here verbatim.  Its interface, which `Solution.lean` relies on:

* `Erdos501.IsFreeSet (F : α → Set α) (X : Set α) : Prop :=
     ∀ x ∈ X, ∀ y ∈ X, x ≠ y → x ∉ F y`
* `Erdos501.exists_infinite_isFreeSet` — general form (`α` second countable,
  `μ` σ-finite Borel measure with `μ univ = ∞`, `F` closed-valued with
  `μ (F x) ≤ C < ∞`) ⇒ an infinite free set.
* `Erdos501.erdos501` — `A : ℝ → Set ℝ`, `IsClosed (A x)`, `volume (A x) < 1`
  ⇒ ∃ infinite `X` with `x ∉ A y` for distinct `x, y ∈ X`.
* `Erdos501.erdos501_three` — same hypotheses ⇒ ∃ `T : Finset ℝ`, `T.card = 3`,
  independent.

`Erdos501.erdos501_closed_infinite` below is the `Set.Pairwise` phrasing used
by the comparator challenge; it is `Erdos501.erdos501` up to `Iff.rfl`
(see docs/audits/2026-08-16-audit-formal-conjectures-501-statements.md).
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

open MeasureTheory

namespace Erdos501

/-- Newelski–Pawlikowski–Seredyński: closed sets of Lebesgue measure `< 1`
admit an infinite independent set.  PENDING: proof from the verified
`Erdos501.lean` (this stub is `sorry`; CI refuses to accept it as closed). -/
theorem erdos501_closed_infinite (A : ℝ → Set ℝ) (hA : ∀ x, IsClosed (A x))
    (hvol : ∀ x, volume (A x) < 1) :
    ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

end Erdos501
