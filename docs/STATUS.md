# Status of the formalization

Last updated: 2026‑08‑17 (forcing development integrated).  "Verified" means:
builds without `sorry`, `#print axioms` = `[propext, Classical.choice, Quot.sound]`,
at the unified pin of this repository,
**Lean v4.34.0-rc1 / Mathlib `355bc1e0ed1d36e49525121e1a280ca13a058a92`**.

## Comparator targets (`Challenge.lean`)

| # | target | mathematics | proof status | in `config-proved.json` |
|---|---|---|---|---|
| 1 | `erdos501_closed_infinite` | NPS87: closed, measure < 1 ⇒ infinite independent set | **verified** (`Erdos501/Closed.lean`, `Erdos501.erdos501_pairwise`) | yes |
| 2 | `erdos501_closed_size3` | second question as asked | **verified** (`Erdos501.erdos501_ncard_three`) | yes |
| 3 | `erdos501_hechler_of_CH` | Hechler: CH ⇒ ¬P (ZFC theorem, Mathlib level) | **verified** (`Erdos501/Hechler.lean`) | yes |
| 4 | `erdos501_not_refutable` | `¬ (ZFC ⊢ₛ' ∼Erdos501_f)`: P holds after adding `𝔠⁺` random reals | **verified** (`Flypitch4/Erdos501/Main.lean`, `Flypitch.Erdos501.neg_Erdos501_f_unprovable`, via `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f`) | yes |
| 5 | `erdos501_not_provable` | `¬ (ZFC ⊢ₛ' Erdos501_f)`: ¬P holds in the collapse extension (CH + Hechler) | **open** — unit H3 below (`Erdos501/Independence.lean`, `erdos501_f_unprovable`, the only `sorry` on the route) | no |
| 6 | `erdos501_independent` | `independent ZFC Erdos501_f` = 4 ∧ 5 | open exactly in component 5 | no |
| 7 | `erdos501_sentence_faithful` | `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` | **verified** (`Flypitch4/Erdos501/Bridge.lean`, `stdStructure_realize_Erdos501_f_iff`) | yes |

**`config-proved.json` (targets 1, 2, 3, 4, 7) passes the comparator**: HEAD
`777e7f5`, lean4export at v4.34.0-rc1, non-sandboxed dry run, 2026‑08‑17 —
"Lean default kernel accepts the solution / Your solution is okay!".
`config.json` (all seven) cannot pass until unit H3 is closed.

Axiom audit of the targets: `docs/audits/2026-08-17-axiom-audit-targets-355bc1e.txt`
(`validation/AxiomAudit.lean`).  Audit of the whole forcing tree (185
declarations): `docs/audits/2026-08-17-erdos501-forcing-audit-355bc1e.txt`
(`validation/Erdos501Audit.lean`) — identical, declaration by declaration, to
the audit at the original pin 83a5988
(`third_party/flypitch4/erdos501-audit-output-83a5988.txt`).  The only
declarations depending on `sorryAx` in the whole repository are
`Flypitch.Erdos501.erdos501_of_col_random` and its corollary
`neg_Erdos501_f_unprovable_of_col_random` (the paper's literal two-step forcing
Col × Random, off the formalized route — the route uses the pure random algebra
with `𝔠⁺` coordinates, `RandomIndex`), and `Erdos501.erdos501_f_unprovable`
(unit H3), with `erdos501_independent` / `erdos501_not_provable` inheriting it.

## Independence proof — unit map

Notation: P = "every family of bounded sets of outer measure < 1 has an infinite
independent set"; `Erdos501_f` its `L_ZFC` rendering ("every complete ordered
field has the Erdős property", `Flypitch4/Erdos501/Sentence.lean`;
`Erdos501_ex_f` the existential form); `𝔹_collapse` = Flypitch's Col(ω₁, 𝒫(ω));
`randomAlgebra ι` = the measure algebra of the fair-coin product measure on
`ι → (ℕ → Bool)`; `𝔹_random_succ_continuum = randomAlgebra RandomIndex` with
`#RandomIndex = 𝔠⁺`.

### Direction ¬(ZFC ⊢ Erdos501_f)  (needs a model of ¬P)

| unit | content | status |
|---|---|---|
| H1 | Hechler at Mathlib level: `CH → ¬P` | verified (target 3) |
| H2 | Flypitch: `⊤ ⊩[V 𝔹_collapse] CH_f` | verified (`V_𝔹_collapse_models_CH`, vendored port) |
| H3 | Transfer: `⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f` | **open** — Hechler's construction internalised in the Boolean-valued universe (in progress in the forcing session; future patches go to `Flypitch4/Erdos501/`) |
| H4 | `erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` from H3 by Boolean soundness (`unprovable_of_model_neg` pattern of `Main.lean`) | routine once H3 exists |

### Direction ¬(ZFC ⊢ ∼Erdos501_f)  (needs a model of P: 𝔠⁺ random reals) — **complete**

All in `Flypitch4/Erdos501/` (namespace `Flypitch.Erdos501`), all verified at
the unified pin (see the forcing audit):

| unit | content | where |
|---|---|---|
| F1 | Lemmas 2.1–2.2 (σ-finite selection, preservation) | `ZFCCore.lean` (`measure_Q_pos`, `measure_diff_eq_top_of_mem_Q`); independently `Erdos501/ZFCCore/Selection.lean` |
| F2 | Def. 3.1 certificate, Thm 3.2 `Prof(𝒜) → Free_ω(𝒜)` | `ZFCCore.lean` (`Certificate`, `exists_infinite_independent_of_certificate`); independently `Erdos501/ZFCCore/Certificate.lean` (`prof_imp_free`) |
| F3 | Thm 4.3 Δ-system for 𝔠⁺ countable sets | `DeltaSystem.lean` (`delta_system_countable`) |
| F4 | Thms 4.1, 4.2, Prop. 4.4: countable support, Borel reading of names, homogeneous reading | `RandomForcing.lean`, `HomogeneousReading.lean` |
| F5 | Thm 4.5 fresh-profile fullness, with names for Borel sets | `BorelNames.lean` (`borelName`, `profilesName`, `fullness`) |
| F6 | Assembly of the certificate inside V^𝔹: binary expansion (S1), internal reals `Rdot` as a complete ordered field (S2), reading of internal reals/covers as Borel data (S3), envelopes (S4), selection and recursion (S6) | `BinaryExpansion.lean`, `Semantics.lean`, `InternalReals.lean`, `RealReading.lean`, `Envelopes.lean`, `Selection.lean`, `Recursion.lean`, `Assembly.lean` |
| F7 | Transfer of Thm 3.2 into the forcing model: `erdosProperty_Rdot`, `erdos501_ex_forced` | `Assembly.lean`, `Main.lean` |
| F8 | Universal form: every internal complete ordered field is isomorphic to `Rdot` (dyadics, Archimedean property, `psi`), transport of the Erdős property | `InternalField.lean`, `InternalIso.lean`, `Transfer.lean` (`erdos501_forced`) |
| — | endpoints: `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f`, `neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)` | `Main.lean` |
| F9 | Modelling choice: the pure random algebra with `𝔠⁺` coordinates replaces the paper's Col ∗ Random | the route needs no collapse; the literal Col × Random assertion `erdos501_of_col_random` (`ColRandom.lean`) is stated with `sorry` and unused |

### Faithfulness (target 7) — **complete**

`stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`
(`Bridge.lean`), from the two-valued unfolding `realize_Erdos501_f_std`
(`StdSemantics.lean`), `ℝ` coded as a complete ordered field in `ZFSet`
(`RealsInZFSet.lean`, direction std ⇒ DeepMind, with the covering lemma for
outer measure < 1) and the isomorphism of every complete ordered field inside
`ZFSet` with `ℝ` (`ZFSetCOF.lean`, Mathlib's `LinearOrderedField.inducedOrderRingIso`,
direction DeepMind ⇒ std).

## Infrastructure status

| item | status |
|---|---|
| Flypitch4 port vendored (`ianklatzco/flypitch@ad649f8`, `flypitch4/`) | done and forward-ported to the unified pin; `independence_of_CH` and all endpoints use only the standard axioms (`third_party/flypitch4/validation/AxiomAudit.lean`); see `docs/PORTING-NOTES.md` |
| Random/measure algebra additions (`Flypitch4/{MeasureAlgebra,RandomAlgebra,ForcingRandom,SummaryRandom}.lean`, `independence_of_CH_random`) | integrated and ported (2026‑08‑17) |
| Forcing development `Flypitch4/Erdos501/*` (24 modules, ≈11.5k lines) | integrated from the 2026‑08‑17 forcing session (zip `erdos501leansources.zip`, at 83a5988) and forward-ported to the unified pin; audit identical to the original |
| Comparator files (`Challenge.lean`, `Solution.lean`, `config.json`, `config-proved.json`) | `lake build` passes; comparator accepts `config-proved.json` (targets 1, 2, 3, 4, 7) |
| CI (`.github/workflows/ci.yml`): build + axiom audit + comparator on `config-proved.json` | written, untested on GitHub |
