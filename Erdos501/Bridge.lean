/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Standard interpretation of `L_ZFC` and the Mathlib-level statement

THIS FILE IS PART OF THE TRUSTED BASE OF THE COMPARATOR CHALLENGE (the two
definitions below); see docs/COMPARATOR.md.

* `erdos501_deepmind : Prop` — the first question of Erdős #501 at Mathlib
  level, verbatim the right-hand side of `formal-conjectures`' `erdos_501`
  (`FormalConjectures/ErdosProblems/501.lean`).
* `stdStructure : Structure L_ZFC` — Mathlib's `ZFSet` with the standard
  interpretation of the five function symbols and of `∈`, mirroring the
  Boolean-valued interpretation `V β` of `Flypitch4/Zfc.lean`
  (`bSet_model_fun_map` / `bSet_model_rel_map`): `∅`, Kuratowski pair
  `{{x}, {x, y}}`, `ω`, powerset, union, membership.

The faithfulness statement `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` is
the comparator target `erdos501_sentence_faithful` (open; see
`Erdos501/Independence.lean`).  The corresponding file of the flypitch patch
(`Flypitch4/Erdos501/Bridge.lean`) is to be merged here when it arrives.
-/
import Erdos501.Sentence
import Mathlib.SetTheory.ZFC.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

open MeasureTheory Fol

namespace Flypitch.Erdos501

/-- The first question of Erdős #501, exactly as in
`google-deepmind/formal-conjectures` (`Erdos501.erdos_501`, right-hand side):
every family of bounded sets of Lebesgue outer measure `< 1` has an infinite
independent set. -/
def erdos501_deepmind : Prop :=
  ∀ (A : ℝ → Set ℝ),
    (∀ x, Bornology.IsBounded (A x)) →
    (∀ x, volume.toOuterMeasure (A x) < 1) →
    ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y)

/-- The standard interpretation of `L_ZFC` on Mathlib's `ZFSet`. -/
def stdStructure : Structure L_ZFC where
  carrier := ZFSet.{0}
  fun_map := fun {n} f xs =>
    match n, f, xs with
    | _, ZFC_func.emptyset, _ => (∅ : ZFSet)
    | _, ZFC_func.pr, DVec.cons x (DVec.cons y DVec.nil) => ZFSet.pair x y
    | _, ZFC_func.ω, _ => ZFSet.omega
    | _, ZFC_func.P, DVec.cons x DVec.nil => ZFSet.powerset x
    | _, ZFC_func.Union, DVec.cons x DVec.nil => ZFSet.sUnion x
  rel_map := fun {n} r xs =>
    match n, r, xs with
    | _, ZFC_rel.ε, DVec.cons x (DVec.cons y DVec.nil) => x ∈ y

end Flypitch.Erdos501
