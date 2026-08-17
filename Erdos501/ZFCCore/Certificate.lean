/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# ZFC core of the random-reals argument — `ZFCCore/Certificate`

PENDING INTEGRATION of `erdos501-zfc-core.zip` (session 2026-08-16; sorry-free
at Lean v4.30.0-rc2 / Mathlib 83a5988; to be ported to Mathlib 355bc1e).
Contents to land in this directory:
* IcoPartition — the `Ico m (m+1)` partition of ℝ used to derive the column
  bound μ(E^s) ≤ 1 and null fibres of x from (P2)/(P3);
* Selection    — Lemma 2.1 `Erdos501.pos_measure_Q` (σ-finite positive-measure
  selection, Tonelli double count) and Lemma 2.2
  `Erdos501.infinite_measure_preservation`;
* Certificate  — Def. 3.1 `Erdos501.Certificate`, `Erdos501.Free`,
  `Erdos501.Prof`, Theorem 3.2 `Erdos501.prof_imp_free` / `prof_imp_free'`.
-/
import Mathlib.MeasureTheory.Measure.Prod
import Mathlib.MeasureTheory.Measure.Count
import Mathlib.MeasureTheory.Integral.Lebesgue.Countable
