# Status of the formalization

Last updated: 2026‑08‑17 (repository set-up).  "Verified" means: builds without
`sorry`, `#print axioms` = `[propext, Classical.choice, Quot.sound]`, at the
stated Mathlib pin.  The unified pin of this repository is
**Lean v4.34.0-rc1 / Mathlib `355bc1e0ed1d36e49525121e1a280ca13a058a92`**.

## Comparator targets (`Challenge.lean`)

| # | target | mathematics | proof status | in `config-zfc.json` |
|---|---|---|---|---|
| 1 | `erdos501_closed_infinite` | NPS87: closed, measure < 1 ⇒ infinite independent set | **verified** at 355bc1e as `Erdos501.erdos501` (session 2026‑08‑16); to be pasted into `Erdos501/Closed.lean` | yes |
| 2 | `erdos501_closed_size3` | second question as asked | follows from 1 in `Solution.lean` (`Set.Infinite.exists_subset_ncard_eq`) | yes |
| 3 | `erdos501_hechler_of_CH` | Hechler: CH ⇒ ¬P (ZFC theorem, Mathlib level) | **verified in this repository** (`Erdos501/Hechler.lean`, re-derived 2026‑08‑17; standard axioms; comparator dry run passes on this target) | yes |
| 4 | `erdos501_independent` | `independent ZFC Erdos501_f` (Flypitch sense) | **open** — see unit table below | no |
| 5 | `erdos501_sentence_faithful` | `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` | **open** (spec stated in `Bridge.lean` of the flypitch patch) | no |

Until 4 and 5 are closed, `config.json` (all five) cannot pass; `config-zfc.json`
is the challenge that should pass today (once the verified files are integrated
and re-checked at the unified pin).

## Independence proof — unit map

Notation: P = "every family of bounded sets of outer measure < 1 has an infinite
independent set"; `Erdos501_f` its `L_ZFC` rendering; `𝔹_collapse` = Flypitch's
Col(ω₁, 𝒫(ω)); `𝔹_col_random` = regular-open completion of
`𝔹_collapse⁺ × (randomAlgebra RandomIndex)⁺` with `#RandomIndex = 𝔠⁺`.

### Direction ¬(ZFC ⊢ Erdos501_f)  (needs a model of ¬P)

| unit | content | status |
|---|---|---|
| H1 | Hechler at Mathlib level: `CH → ¬P` | verified (target 3) |
| H2 | Flypitch: `⊤ ⊩[V 𝔹_collapse] CH_f` | verified (`V_𝔹_collapse_models_CH`, vendored port) |
| H3 | Transfer: `⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f` | **open** — needs Hechler's construction internalised in the Boolean-valued universe (or a first-order derivation of `CH_f ⟹ ∼Erdos501_f`, impractical) |
| H4 | `erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` from H3 by Boolean soundness | routine once H3 exists |

### Direction ¬(ZFC ⊢ ∼Erdos501_f)  (needs a model of P: ω₂ random reals over CH)

Units as in the paper's §6 (rev10) and the 2026‑08‑16 forcing session:

| unit | content | status |
|---|---|---|
| F1 | Lemmas 2.1–2.2 (σ-finite selection, preservation) | verified (ZFC core, at 83a5988; port pending) |
| F2 | Def. 3.1 certificate, Thm 3.2 `Prof(𝒜) → Free_ω(𝒜)` | verified (ZFC core, at 83a5988; port pending) |
| F3 | Thm 4.3 Δ-system for 𝔠⁺ countable sets (ZFC, index 𝔠⁺ replaces ω₂+CH) | **statement only** (`delta_system_countable := sorry`); Mathlib has no Δ-system lemma. Plan: Kunen II.1.6 |
| F4 | Thms 4.1, 4.2, Prop. 4.4: countable support, Borel reading of names, homogeneous reading | proved (RandomForcing.lean, HomogeneousReading.lean; 4.4 modulo F3) |
| F5 | Thm 4.5 fresh-profile fullness | proved at reading level (`exists_fresh_petal_of_fiber_pos`); literal `⊩ ν*(Ż) = 1` needs names for Borel sets — **open** |
| F6 | Thm 5.1 assembly of the certificate inside V^𝔹 (names Ω̌, ν̌, Ż, ẋ_m, ċ_m; Boolean values of "λ*(A_y) < 1", "A_y ⊆ U(c)") | **not started** |
| F7 | Transfer of Thm 3.2 into the forcing model (Boolean-valued re-development, or set-model run with canonical witnesses) | **not started** — see the rev10 audit §4 |
| F8 | `erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f` (from F1–F7) and `neg_erdos501_f_unprovable` (derived, no extra sorry) | statement + derivation exist; proof open |
| F9 | Modelling choice: product Col × Random instead of the iteration Col ∗ Random | justified informally (Col(ω₁,ℝ) is σ-closed ⇒ no new reals ⇒ the ω₂-random algebra of V[G] is the check name of the ground algebra with 𝔠⁺ coordinates); to be documented/proved as needed |

### Faithfulness (target 5)

`stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`: open.  Needs (i) that
Mathlib's `ZFSet` contains a complete ordered field and that all such fields
are isomorphic to `ℝ` (Mathlib: `LinearOrderedField.inducedOrderRingIso`),
(ii) that the interval-cover rendering of "outer measure < 1" agrees with
`volume` on `ℝ`.

## Infrastructure status

| item | status |
|---|---|
| Flypitch4 port vendored (`ianklatzco/flypitch@ad649f8`, `flypitch4/`) | **done and forward-ported to the unified pin**: full `lake build`; `independence_of_CH` and all endpoints use only the standard axioms (`third_party/flypitch4/validation/AxiomAudit.lean`); see `docs/PORTING-NOTES.md` |
| `Erdos501/Bridge.lean`: `erdos501_deepmind`, `stdStructure` | written (real definitions); `Erdos501/Sentence.lean`: `Erdos501_f` is a `sorry` PLACEHOLDER until the patch file is integrated |
| Random algebra / measure algebra additions (`MeasureAlgebra.lean`, `RandomAlgebra.lean`, `ForcingRandom.lean`, `SummaryRandom.lean`, `independence_of_CH_random`) | pending integration of the flypitch patch |
| Comparator files (`Challenge.lean`, `Solution.lean`, `config.json`, `config-zfc.json`) | written; `lake build` of Challenge/Solution passes; comparator (HEAD `777e7f5`, lean4export at v4.34.0-rc1, non-sandboxed dry run) accepts a config with `erdos501_hechler_of_CH` — "Your solution is okay!" |
| CI (`.github/workflows/ci.yml`): build + axiom audit + comparator on `config-zfc.json` | written, untested |
