# MANIFEST — `flypitch4-random-algebra-and-erdos501.patch`

Cumulative patch of everything added to the Lean 4 port of Flypitch (`flypitch4/`) in the Erdős #501 work (the ℵ₂-random-algebra proof of ¬CH, and the full independence of Erdős #501's first question from `ZFC`). Generated 2026-08-17 by `git diff HEAD` in the repository root of `ianklatzco/flypitch` at commit `ad649f8`; nothing is committed. `git apply --check` succeeds on a clean checkout of `ad649f8`. Apply with `git apply flypitch4-random-algebra-and-erdos501.patch` in the repository root.

Patch statistics: **41 files changed, 16205 insertions(+), 1 deletion(-)**; 36 new files, 5 pre-existing files modified. The individual `.lean`/`.md` sources are in `erdos501-lean-sources.zip` (not stored in the project).

## Headline results (all fully proved; axioms `[propext, Classical.choice, Quot.sound]`)

* **`Flypitch.Erdos501.Hechler.independence_of_Erdos501 : independent ZFC Erdos501_f`** — the first question of Erdős problem #501 is **independent of `ZFC`**.
  * `¬ (ZFC ⊢ Erdos501_f)` (`Erdos501_f_unprovable`, `Hechler.lean`): a negative answer is forced by `Col(ω₁, ℝ)` (Hechler's `CH` counterexample).
  * `¬ (ZFC ⊢ ∼Erdos501_f)` (`neg_Erdos501_f_unprovable`, `Main.lean`): a positive answer is forced by `𝔠⁺` random reals.
* `stdStructure_realize_Erdos501_f_iff` (`Bridge.lean`) — `Erdos501_f` faithfully renders DeepMind's `erdos_501` in the standard model `ZFSet`.

## Toolchain pin (exact)

* `flypitch4/lean-toolchain`: `leanprover/lean4:v4.30.0-rc2` (unchanged by the patch).
* `flypitch4/lake-manifest.json` (unchanged): mathlib `83a5988a25fdd78621774a57af7e1f5c55f24289` (inputRev `master`); batteries `5c57f3857ba81924a88b2cdf4f062e34ec04ff11` (`v4.30.0-rc2`); aesop `f0c6e183ea26531e82773feb4b73ab6595ca17a5`; Qq `1cc7e819b9b9bc1e87c9edcccb62e0269e00a809`; proofwidgets `2db6054a44326f8c0230ee0570e2ddb894816511` (`v0.0.98`); importGraph `cdab3938ccabbdb044be6896e251b5814bec932e`; LeanSearchClient `c5d5b8fe6e5158def25cd28eb94e4141ad97c843`; plausible `293af9b2a383eed4d04d66b898d608d0a44b750f`; Cli `13567aed1ac4f12aea9484178e07e51f8c9f7658`.

## Full build

* `cd flypitch4 && lake build` — **Build completed successfully (2689 jobs)** (includes Mathlib compiled from source here).
* `lake env lean validation/Erdos501Audit.lean` — 197 `#print axioms` lines + shape checks + the printed sentence (4223 characters); `sorryAx` occurs ONLY for `erdos501_of_col_random` and its corollary `neg_Erdos501_f_unprovable_of_col_random` (the off-route literal two-step-forcing assertion, not needed for independence).
* `lake env lean validation/{AxiomAudit,DependencyCheck,StatementShape}.lean` — all pass.

## Files in the patch

| # | Path (relative to repository root) | Lines (whole file after patch) | Lean module | Status |
|---|---|---:|---|---|
| 1 | `README.org` | 171 | — (documentation) | modified |
| 2 | `flypitch4/AUDIT.md` | 399 | — (documentation) | new |
| 3 | `flypitch4/Flypitch4.lean` | 81 | Flypitch4 (library root) | modified |
| 4 | `flypitch4/Flypitch4/ForcingRandom.lean` | 297 | Flypitch4.ForcingRandom | new |
| 5 | `flypitch4/Flypitch4/MeasureAlgebra.lean` | 501 | Flypitch4.MeasureAlgebra | new |
| 6 | `flypitch4/Flypitch4/RandomAlgebra.lean` | 210 | Flypitch4.RandomAlgebra | new |
| 7 | `flypitch4/Flypitch4/SummaryRandom.lean` | 68 | Flypitch4.SummaryRandom | new |
| 8 | `flypitch4/Flypitch4/Erdos501/Assembly.lean` | 461 | Flypitch4.Erdos501.Assembly | new |
| 9 | `flypitch4/Flypitch4/Erdos501/BinaryExpansion.lean` | 302 | Flypitch4.Erdos501.BinaryExpansion | new |
| 10 | `flypitch4/Flypitch4/Erdos501/BorelNames.lean` | 383 | Flypitch4.Erdos501.BorelNames | new |
| 11 | `flypitch4/Flypitch4/Erdos501/Bridge.lean` | 52 | Flypitch4.Erdos501.Bridge | new |
| 12 | `flypitch4/Flypitch4/Erdos501/CheckReals.lean` | 715 | Flypitch4.Erdos501.CheckReals | new |
| 13 | `flypitch4/Flypitch4/Erdos501/ColRandom.lean` | 124 | Flypitch4.Erdos501.ColRandom | new |
| 14 | `flypitch4/Flypitch4/Erdos501/DeltaSystem.lean` | 350 | Flypitch4.Erdos501.DeltaSystem | new |
| 15 | `flypitch4/Flypitch4/Erdos501/Envelopes.lean` | 299 | Flypitch4.Erdos501.Envelopes | new |
| 16 | `flypitch4/Flypitch4/Erdos501/Hechler.lean` | 913 | Flypitch4.Erdos501.Hechler | new |
| 17 | `flypitch4/Flypitch4/Erdos501/HomogeneousReading.lean` | 265 | Flypitch4.Erdos501.HomogeneousReading | new |
| 18 | `flypitch4/Flypitch4/Erdos501/InternalField.lean` | 1303 | Flypitch4.Erdos501.InternalField | new |
| 19 | `flypitch4/Flypitch4/Erdos501/InternalIso.lean` | 1133 | Flypitch4.Erdos501.InternalIso | new |
| 20 | `flypitch4/Flypitch4/Erdos501/InternalReals.lean` | 1055 | Flypitch4.Erdos501.InternalReals | new |
| 21 | `flypitch4/Flypitch4/Erdos501/Main.lean` | 94 | Flypitch4.Erdos501.Main | new |
| 22 | `flypitch4/Flypitch4/Erdos501/OmegaClosed.lean` | 153 | Flypitch4.Erdos501.OmegaClosed | new |
| 23 | `flypitch4/Flypitch4/Erdos501/PLAN.md` | 294 | — (documentation) | new |
| 24 | `flypitch4/Flypitch4/Erdos501/README.md` | 439 | — (documentation) | new |
| 25 | `flypitch4/Flypitch4/Erdos501/RandomForcing.lean` | 616 | Flypitch4.Erdos501.RandomForcing | new |
| 26 | `flypitch4/Flypitch4/Erdos501/RealReading.lean` | 783 | Flypitch4.Erdos501.RealReading | new |
| 27 | `flypitch4/Flypitch4/Erdos501/RealsInZFSet.lean` | 545 | Flypitch4.Erdos501.RealsInZFSet | new |
| 28 | `flypitch4/Flypitch4/Erdos501/Recursion.lean` | 535 | Flypitch4.Erdos501.Recursion | new |
| 29 | `flypitch4/Flypitch4/Erdos501/Selection.lean` | 263 | Flypitch4.Erdos501.Selection | new |
| 30 | `flypitch4/Flypitch4/Erdos501/Semantics.lean` | 308 | Flypitch4.Erdos501.Semantics | new |
| 31 | `flypitch4/Flypitch4/Erdos501/Sentence.lean` | 317 | Flypitch4.Erdos501.Sentence | new |
| 32 | `flypitch4/Flypitch4/Erdos501/StdSemantics.lean` | 436 | Flypitch4.Erdos501.StdSemantics | new |
| 33 | `flypitch4/Flypitch4/Erdos501/Transfer.lean` | 923 | Flypitch4.Erdos501.Transfer | new |
| 34 | `flypitch4/Flypitch4/Erdos501/ZFCCore.lean` | 370 | Flypitch4.Erdos501.ZFCCore | new |
| 35 | `flypitch4/Flypitch4/Erdos501/ZFSetCOF.lean` | 621 | Flypitch4.Erdos501.ZFSetCOF | new |
| 36 | `flypitch4/validation/AxiomAudit.lean` | 38 | — (validation script) | modified |
| 37 | `flypitch4/validation/DependencyCheck.lean` | 44 | — (validation script) | new |
| 38 | `flypitch4/validation/Erdos501Audit.lean` | 437 | — (validation script) | new |
| 39 | `flypitch4/validation/Erdos501Print.lean` | 40 | — (validation script) | new |
| 40 | `flypitch4/validation/README.md` | 65 | — (documentation) | modified |
| 41 | `flypitch4/validation/StatementShape.lean` | 64 | — (validation script) | modified |

Total lines of the 41 files after the patch: 16467. New Lean under `Flypitch4/Erdos501/`: 13319 lines; `MeasureAlgebra`+`RandomAlgebra`+`ForcingRandom`+`SummaryRandom`: 1076 lines.

## Pre-existing Flypitch4 files modified by the patch (and how)

Only five pre-existing files are touched; **no existing Lean proof or definition is changed** — `Bvm.lean`, `BvmExtras.lean`, `BvmExtras2.lean`, `Bfol.lean`, `Fol.lean`, `Zfc.lean`, `Forcing.lean`, `ForcingCH.lean`, `Collapse.lean`, `Completeness.lean`, `Summary.lean`, `PrintFormula.lean`, `lakefile.toml`, `lean-toolchain`, `lake-manifest.json` are NOT modified.  The ¬CH direction reuses `ForcingCH.lean`'s collapse machinery (`π_af`, `π_af_wide`, `π_af_anti`, `principalOpens_denseOmegaClosed`, `collapse_algebra.CH_true`) unchanged.

* `flypitch4/Flypitch4.lean` (+59 lines): only `import` lines appended, registering `Flypitch4.MeasureAlgebra`, `Flypitch4.RandomAlgebra`, `Flypitch4.ForcingRandom`, `Flypitch4.SummaryRandom` and all `Flypitch4.Erdos501.*` modules.
* `flypitch4/validation/AxiomAudit.lean` (+12): the random-algebra ¬CH endpoints.
* `flypitch4/validation/StatementShape.lean` (+19/−1): shape checks for the random-algebra endpoints.
* `flypitch4/validation/README.md` (+31): notes on the new validation scripts and results.
* `README.org` (+~50, repository root): subsections on the ℵ₂-random ¬CH proof and Erdős #501 (now including the independence theorem).

## Main theorems and their `#print axioms` output

### Erdős #501: independence and the two consistency directions

```
'Flypitch.Erdos501.Hechler.independence_of_Erdos501' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.Erdos501_f_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.neg_Erdos501_f_unprovable' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.neg_erdos501_forced_collapse' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.erdos501_of_random' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.RandomForcing.erdos501_forced' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### Erdős #501: the ¬CH machinery (Hechler)

```
'Flypitch.Erdos501.exists_forall_of_denseOmegaClosed' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.CheckReals.completeOrderedField_Rc' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.CheckReals.completeOrderedField_Rc_collapse' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.no_descent' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.isFun_Aname' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.bounded_Aset' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.outerMeasureLtOne_Aset' depends on axioms: [propext, Classical.choice, Quot.sound]
'Flypitch.Erdos501.Hechler.no_infinite_independent' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### Erdős #501: the bridge (faithfulness)

```
'Flypitch.Erdos501.stdStructure_realize_Erdos501_f_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### Erdős #501: the off-route literal assertion (the ONLY `sorry` in the repository)

```
'Flypitch.Erdos501.erdos501_of_col_random' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
'Flypitch.Erdos501.neg_Erdos501_f_unprovable_of_col_random' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```

Statements: `independence_of_Erdos501 : independent ZFC Erdos501_f`; `Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)`; `neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)`; `neg_erdos501_forced_collapse : ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`; `erdos501_forced : Order.succ 𝔠 ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f`.

## Not in this patch (open)

* `erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f` (paper's literal two-step forcing) — `sorry`, off-route; not needed for the independence result, which is complete.
