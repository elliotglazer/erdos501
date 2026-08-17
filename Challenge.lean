/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Erdős Problem #501 — comparator challenge (trusted statements)

This file is the *trusted* half of a comparator challenge
(https://github.com/leanprover/comparator).  It states, with `sorry`, exactly
what the accompanying `Solution.lean` must prove.  Everything that this file
imports is part of the trusted base and should be audited by a human:

* Mathlib (Lebesgue measure on `ℝ`, `Set.Pairwise`, cardinals);
* `Flypitch4.Summary` — the Lean 4 port of Flypitch (first-order logic, the
  theory `ZFC`, the proof system `⊢ₛ'`, the predicate `independent`);
* `Flypitch4.Erdos501.Sentence` — the first-order sentence
  `Erdos501_f : sentence L_ZFC` rendering the first question of #501 in the
  language of set theory (`L_ZFC`: `∅`, pairs, `ω`, `𝒫`, `⋃`, `∈`);
* `Flypitch4.Erdos501.StdSemantics` — the standard interpretation
  `stdStructure` of `L_ZFC` in Mathlib's `ZFSet` and the Mathlib-level
  proposition `erdos501_deepmind` (verbatim the `formal-conjectures` statement
  of the first question).

## The problem (erdosproblems.com/501)

For every `x ∈ ℝ` let `A x ⊆ ℝ` be a bounded set of outer measure `< 1`.  Must
there exist an infinite *independent* set, i.e. an infinite `X ⊆ ℝ` with
`x ∉ A y` for all distinct `x, y ∈ X`?  (First question.)  If the sets `A x`
are closed and of measure `< 1`, must there exist an independent set of size
`3`?  (Second question.)

The formal shape of the hypotheses follows
`google-deepmind/formal-conjectures`, `FormalConjectures/ErdosProblems/501.lean`:
per-set boundedness `Bornology.IsBounded (A x)`, outer measure
`volume.toOuterMeasure (A x) < 1` (definitionally `volume (A x)`, which on an
arbitrary set is Lebesgue outer measure), independence `X.Pairwise (fun x y => x ∉ A y)`.

## The targets

1. `erdos501_closed_infinite` — second question, strong form (NPS87): closed
   sets of measure `< 1` admit an *infinite* independent set.
2. `erdos501_closed_size3` — second question as asked: an independent set of
   size `3`.
3. `erdos501_hechler_of_CH` — Hechler: under `CH` the first question has a
   negative answer (a `ZFC` theorem, stated at Mathlib level).
4. `erdos501_not_refutable` — `ZFC` does not refute the first-order rendering
   of the first question: `¬ (ZFC ⊢ₛ' ∼Erdos501_f)` (a positive answer is
   consistent: it holds after adding `𝔠⁺` random reals).
5. `erdos501_not_provable` — `ZFC` does not prove it: `¬ (ZFC ⊢ₛ' Erdos501_f)`
   (a negative answer is consistent: Hechler's counterexample under `CH`, in
   the collapse extension).
6. `erdos501_independent` — the first question is independent of `ZFC`, in the
   sense of Flypitch (`independent ZFC Erdos501_f`, i.e. 4 ∧ 5).
7. `erdos501_sentence_faithful` — faithfulness of the rendering: in the standard
   `ZFSet` interpretation, `Erdos501_f` holds iff the Mathlib-level statement
   `erdos501_deepmind` holds.
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.Data.Set.Card
import Flypitch4.Summary
import Flypitch4.Erdos501.Sentence
import Flypitch4.Erdos501.StdSemantics

open MeasureTheory
open scoped Cardinal
open Fol

universe u

/-! ### Second question: closed sets of measure `< 1` -/

/-- Newelski–Pawlikowski–Seredyński (Proc. AMS 100 (1987) 335–339): if every
`A x` is closed of Lebesgue measure `< 1` then there is an infinite independent
set.  (No boundedness hypothesis is needed.) -/
theorem erdos501_closed_infinite :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-- The second question of #501 as asked: an independent set of size `3`
(`Set.ncard` is `0` on infinite sets, so this forces a finite independent set
with at least three elements). -/
theorem erdos501_closed_size3 :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, 3 ≤ X.ncard ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-! ### First question: Hechler's counterexample under `CH` -/

/-- Hechler (Israel J. Math. 11 (1972) 231–248): if `ℵ₁ = 𝔠` then there is a
family of bounded sets of outer measure `< 1` (indeed countable, null sets)
with no infinite independent set.  This is a theorem of `ZFC`, so it holds in
Lean outright; the hypothesis `CH` is a genuine hypothesis of the theorem. -/
theorem erdos501_hechler_of_CH :
    ((ℵ₁ : Cardinal.{u}) = 𝔠) →
    ∃ (A : ℝ → Set ℝ),
      (∀ x, Bornology.IsBounded (A x)) ∧
      (∀ x, volume.toOuterMeasure (A x) < 1) ∧
      ¬ ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-! ### First question: independence from `ZFC` -/

/-- `ZFC` does not refute the first question: there is no derivation of
`∼Erdos501_f` from the first-order theory `ZFC` of Flypitch
(`Flypitch4/Zfc.lean`).  Mathematically: after adding `𝔠⁺` random reals every
family of sets of outer measure `< 1` has an infinite independent set
(E. Glazer, 2026). -/
theorem erdos501_not_refutable :
    ¬ (ZFC ⊢ₛ' (bd_not Flypitch.Erdos501.Erdos501_f : sentence L_ZFC)) := by
  sorry

/-- `ZFC` does not prove the first question: there is no derivation of
`Erdos501_f` from `ZFC`.  Mathematically: `CH` holds in the collapse extension
`V^{Col(ω₁, 𝒫(ω))}` (Flypitch's `V_𝔹_collapse_models_CH`) and `CH` gives
Hechler's counterexample. -/
theorem erdos501_not_provable : ¬ (ZFC ⊢ₛ' Flypitch.Erdos501.Erdos501_f) := by
  sorry

/-- The first question of #501 is independent of `ZFC`: with `ZFC` the
first-order theory of Flypitch and `Erdos501_f` the `L_ZFC`-sentence of
`Flypitch4/Erdos501/Sentence.lean`, neither `Erdos501_f` nor `∼Erdos501_f` has
a derivation from `ZFC`.  Compare `independence_of_CH : independent ZFC CH_f`
in `Flypitch4/Summary.lean`. -/
theorem erdos501_independent : independent ZFC Flypitch.Erdos501.Erdos501_f := by
  sorry

/-- Faithfulness of the first-order rendering: in the standard interpretation of
`L_ZFC` on Mathlib's `ZFSet` (`Flypitch4/Erdos501/StdSemantics.lean`), the
sentence `Erdos501_f` is realized iff the Mathlib-level statement of the first
question (`erdos501_deepmind`, verbatim the right-hand side of
`formal-conjectures`' `erdos_501`) holds. -/
theorem erdos501_sentence_faithful :
    Flypitch.Erdos501.stdStructure ⊨ₘ Flypitch.Erdos501.Erdos501_f ↔
      Flypitch.Erdos501.erdos501_deepmind := by
  sorry
