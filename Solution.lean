/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Erdős Problem #501 — comparator solution

The untrusted half of the comparator challenge: the statements of `Challenge.lean` (Part B),
repeated verbatim, each proved by delegation to the `Erdos501` development.  Only the statements
are compared by the comparator; this file may import anything (it must not import `Challenge`).

The shared definitions of `Challenge.lean` (Part A: the language `L`, the theory `ZFC`, the
sentence `Erdos501`, the structure `zfsetStructure`) are provided here by
`Erdos501.FOL.Statement`, a verbatim copy kept in sync by `scripts/sync-statement.py`; the
comparator checks that every constant occurring in the seven statements is the same declaration
in both environments.

All seven targets are proved; `comparator.json` lists them all.
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.Data.Set.Card
import Mathlib.ModelTheory.Satisfiability
import Mathlib.SetTheory.ZFC.Basic
import Erdos501

open MeasureTheory
open scoped Cardinal FirstOrder
open FirstOrder FirstOrder.Language

universe u

open Erdos501.FOL

/-! ### Second question: closed sets of measure `< 1` -/

theorem erdos501_closed_infinite :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) :=
  fun A hA hvol => Erdos501.erdos501_pairwise A hA hvol

theorem erdos501_closed_size3 :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, 3 ≤ X.ncard ∧ X.Pairwise (fun x y => x ∉ A y) :=
  fun A hA hvol => Erdos501.erdos501_ncard_three A hA hvol

/-! ### First question: Hechler's counterexample under `CH` -/

theorem erdos501_hechler_of_CH :
    ((ℵ₁ : Cardinal.{u}) = 𝔠) →
    ∃ (A : ℝ → Set ℝ),
      (∀ x, Bornology.IsBounded (A x)) ∧
      (∀ x, volume.toOuterMeasure (A x) < 1) ∧
      ¬ ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) :=
  fun hCH => Erdos501.hechler_of_CH hCH

/-! ### First question: independence from `ZFC` -/

theorem erdos501_not_refutable : ¬ (ZFC ⊨ᵇ ∼Erdos501) :=
  Erdos501.FOL.erdos501_not_refutable

theorem erdos501_not_provable : ¬ (ZFC ⊨ᵇ Erdos501) :=
  Erdos501.FOL.erdos501_not_provable

theorem erdos501_independent : ¬ (ZFC ⊨ᵇ Erdos501) ∧ ¬ (ZFC ⊨ᵇ ∼Erdos501) :=
  Erdos501.FOL.erdos501_independent

theorem erdos501_sentence_faithful :
    (ZFSet.{0} ⊨ Erdos501) ↔
      ∀ (A : ℝ → Set ℝ),
        (∀ x, Bornology.IsBounded (A x)) →
        (∀ x, volume.toOuterMeasure (A x) < 1) →
        ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) :=
  Erdos501.FOL.realize_Erdos501_iff
