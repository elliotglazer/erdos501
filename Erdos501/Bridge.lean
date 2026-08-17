/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Standard interpretation of `L_ZFC` and the Mathlib-level statement

PENDING INTEGRATION of `Flypitch4/Erdos501/Bridge.lean` from the flypitch patch.
Provides
* `Flypitch.Erdos501.erdos501_deepmind : Prop` — verbatim the right-hand side of
  `formal-conjectures`' `erdos_501`;
* `Flypitch.Erdos501.stdStructure : Structure L_ZFC` — Mathlib's `ZFSet` with
  ∅, pairing, ω, powerset, union and ∈;
* the spec `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` (a `sorry` there; it
  is the comparator target `erdos501_sentence_faithful` here, to be proved in
  `Erdos501/Independence.lean`).

THIS FILE IS PART OF THE TRUSTED BASE OF THE COMPARATOR CHALLENGE (the two
definitions above); the theorem is not.
-/
import Erdos501.Sentence
import Mathlib.SetTheory.ZFC.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
