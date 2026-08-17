/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Erdős Problem #501 — comparator solution

The untrusted half of the comparator challenge: the statements of
`Challenge.lean`, repeated verbatim, each proved by delegation to the
`Erdos501` development.  Only the statements are compared by the comparator;
this file may import anything.

Targets whose proofs are not yet complete in the development are still
present, so that `lake build Solution` succeeds; the comparator is run with a
`config` that lists only the targets whose proofs are closed
(see `config-proved.json`) until the full `config.json` can be met.
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.Data.Set.Card
import Flypitch4.Summary
import Erdos501

open MeasureTheory
open scoped Cardinal
open Fol

universe u

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

theorem erdos501_not_refutable :
    ¬ (ZFC ⊢ₛ' (bd_not Flypitch.Erdos501.Erdos501_f : sentence L_ZFC)) :=
  Erdos501.neg_erdos501_f_unprovable

theorem erdos501_not_provable : ¬ (ZFC ⊢ₛ' Flypitch.Erdos501.Erdos501_f) :=
  Erdos501.erdos501_f_unprovable

theorem erdos501_independent : independent ZFC Flypitch.Erdos501.Erdos501_f :=
  Erdos501.erdos501_independent

theorem erdos501_sentence_faithful :
    Flypitch.Erdos501.stdStructure ⊨ₘ Flypitch.Erdos501.Erdos501_f ↔
      Flypitch.Erdos501.erdos501_deepmind :=
  Erdos501.erdos501_sentence_faithful
