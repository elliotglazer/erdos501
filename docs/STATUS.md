# Status of the formalization

Last updated: 2026‑08‑19 — **complete**.  "Verified" means: builds without
`sorry`, `#print axioms` = `[propext, Classical.choice, Quot.sound]`, at the
unified pin of this repository,
**Lean v4.34.0-rc1 / Mathlib `355bc1e0ed1d36e49525121e1a280ca13a058a92`**.

## Comparator targets (`Challenge.lean`, Mathlib only) — all verified

| # | target | mathematics | proof |
|---|---|---|---|
| 1 | `erdos501_closed_infinite` | NPS87: closed, measure < 1 ⇒ infinite independent set | `Erdos501/Closed.lean`, `Erdos501.erdos501_pairwise` |
| 2 | `erdos501_closed_size3` | second question as asked | `Erdos501.erdos501_ncard_three` |
| 3 | `erdos501_hechler_of_CH` | Hechler: CH ⇒ ¬P (ZFC theorem, Mathlib level) | `Erdos501/Hechler.lean` |
| 4 | `erdos501_not_refutable` | `¬ (ZFC ⊨ᵇ ∼Erdos501)`: P holds in a model of ZFC — after adding `𝔠⁺` random reals | `Erdos501/FOL/Independence.lean` from `Flypitch.Erdos501.neg_Erdos501_f_unprovable` (`Flypitch4/Erdos501/Main.lean`, via `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f`) and Flypitch's completeness theorem |
| 5 | `erdos501_not_provable` | `¬ (ZFC ⊨ᵇ Erdos501)`: ¬P holds in a model of ZFC — the collapse extension (CH + Hechler) | `Erdos501/FOL/Independence.lean` from `Flypitch.Erdos501.Hechler.Erdos501_f_unprovable` (`Flypitch4/Erdos501/Hechler.lean`, via `neg_erdos501_forced_collapse : ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`) |
| 6 | `erdos501_independent` | 4 ∧ 5 | `Erdos501/FOL/Independence.lean` |
| 7 | `erdos501_sentence_faithful` | `(ZFSet ⊨ Erdos501) ↔ erdos501_deepmind` | `Erdos501/FOL/Sentence.lean` (`realize_Erdos501_iff`, from `zfsetStructure = toM stdStructure`, `tr_Erdos501 := rfl` and `Flypitch4/Erdos501/Bridge.lean`, `stdStructure_realize_Erdos501_f_iff`) |

The same seven names, with 4–7 in Flypitch's terms (`¬ (ZFC ⊢ₛ' ∼Erdos501_f)`,
`¬ (ZFC ⊢ₛ' Erdos501_f)`, `independent ZFC Erdos501_f`,
`stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`), form the second challenge
`ChallengeFlypitch.lean` / `SolutionFlypitch.lean` / `comparator-flypitch.json`
(proofs: `Erdos501/Independence.lean`, `Flypitch4/Erdos501/{Main,Hechler,Bridge}.lean`).

**Both configurations pass the comparator**: HEAD `777e7f5`, lean4export at
v4.34.0-rc1, non-sandboxed dry run, 2026‑08‑19 — "Lean default kernel accepts
the solution / Your solution is okay!" (`comparator.json` and
`comparator-flypitch.json`; the sandboxed judge runs in CI).

Axiom audit of the targets and of the bridge: `docs/audits/2026-08-19-axiom-audit-targets-355bc1e.txt`
(`validation/AxiomAudit.lean`).  Audit of the whole forcing tree (194
declarations): `docs/audits/2026-08-17-erdos501-forcing-audit-355bc1e.txt`
(`validation/Erdos501Audit.lean`) — identical, declaration by declaration, to
the audit at the original pin 83a5988
(`third_party/flypitch4/erdos501-audit-output-83a5988.txt`, 197 declarations)
except for the three declarations removed here (below).  **No declaration in
the repository depends on `sorryAx`**; the only `sorry`s are the statements of
`Challenge.lean` and `ChallengeFlypitch.lean`.  (The paper's literal two-step forcing Col × Random had been
stated with `sorry` as `erdos501_of_col_random` in `Flypitch4/Erdos501/ColRandom.lean`,
with the corollary `neg_Erdos501_f_unprovable_of_col_random` and the trivial
`V_col_random_models_ZFC`; it was never used — the formalized route uses the pure
random algebra with `𝔠⁺` coordinates, `RandomIndex` — and was removed on
2026‑08‑17.  The algebra `𝔹_col_random` itself is kept as a definition, for
reference.)

## Bridge to Mathlib's first-order logic (`Erdos501/FOL/`) — **complete** (2026‑08‑19)

| unit | content | where |
|---|---|---|
| B1 | the Challenge's definitions, verbatim (generated) | `Statement.lean`, `scripts/sync-statement.py` |
| B2 | translation `trT`/`tr` (levels ↦ indices), `toM`, `realize_trT`, `realize_tr`, `realize_sentence_tr` | `Translate.lean` |
| B3 | two-valued `realize_bounded_formula_insert_lift`, `realize_lift2_at2`, `realize_lift3_at2`, `realize_subst_formula0` (ports of the Boolean-valued lemmas of `Bfol.lean`/`Zfc.lean`) | `FolLemmas.lean` |
| B4 | semantics of `collectionAxiom` (Mathlib side, `Fin.snoc`/`liftAt` computations) and of `axiom_of_collection` (Flypitch side); transfer `toM_realize_collectionAxiom` | `Collection.lean` |
| B5 | `tr axiomOf* = axiom_of_*` (8 × `rfl`); `toM_models_ZFC` | `Axioms.lean` |
| B6 | `tr_Erdos501 : tr Erdos501 = Erdos501_f := rfl`; `zfsetStructure = toM stdStructure`; `realize_Erdos501_iff` (target 7) | `Sentence.lean` |
| B7 | completeness → countermodel → `Theory.Model.isSatisfiable` → `models_iff_not_satisfiable`: targets 4–6 | `Independence.lean` |

## Independence proof — unit map

Notation: P = "every family of bounded sets of outer measure < 1 has an infinite
independent set"; `Erdos501_f` its `L_ZFC` rendering ("every complete ordered
field has the Erdős property", `Flypitch4/Erdos501/Sentence.lean`;
`Erdos501_ex_f` the existential form); `𝔹_collapse` = Flypitch's Col(ω₁, 𝒫(ω));
`randomAlgebra ι` = the measure algebra of the fair-coin product measure on
`ι → (ℕ → Bool)`; `𝔹_random_succ_continuum = randomAlgebra RandomIndex` with
`#RandomIndex = 𝔠⁺`.

### Direction ¬(ZFC ⊢ Erdos501_f)  (a model of ¬P) — **complete**

| unit | content | where |
|---|---|---|
| H1 | Hechler at Mathlib level: `CH → ¬P` | `Erdos501/Hechler.lean` (target 3) |
| H2 | Flypitch: `⊤ ⊩[V 𝔹_collapse] CH_f` | `Flypitch4/ForcingCH.lean` (`V_𝔹_collapse_models_CH`, vendored port); the collapse's ω-closedness (`check_functions_eq_functions`, `DenseOmegaClosed`) is what H3 uses |
| H3 | `⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f` | `Flypitch4/Erdos501/OmegaClosed.lean` (external ω-closed refinement: on a nonzero piece an ω-sequence of decisions can be made), `CheckReals.lean` (the check-name reals `Rc` with `plusC, timesC, ltC, zeroC, oneC` form an internal complete ordered field of `V 𝔹` for any `𝔹` with a dense ω-closed subset: `completeOrderedField_Rc`), `Hechler.lean` (Hechler's family `Aname` from the generic collapse `π_af`; `isFun_Aname`, `bounded_Aset`, `outerMeasureLtOne_Aset`, `no_infinite_independent`, `erdosProperty_Rc_eq_bot`, `erdos501_eq_bot`, `neg_erdos501_forced_collapse`) |
| H4 | `Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` by Boolean soundness | `Hechler.lean` (`unprovable_of_model_neg`, the pattern of `CH_f_unprovable`) |

### Direction ¬(ZFC ⊢ ∼Erdos501_f)  (a model of P: 𝔠⁺ random reals) — **complete**

All in `Flypitch4/Erdos501/` (namespace `Flypitch.Erdos501`):

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
| F9 | Modelling choice: the pure random algebra with `𝔠⁺` coordinates replaces the paper's Col ∗ Random | the route needs no collapse; the paper's Col × Random algebra `𝔹_col_random` is only defined (`ColRandom.lean`), nothing is proved about it |

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
| Forcing development `Flypitch4/Erdos501/*` (27 modules, ≈13.3k lines) | integrated from the 2026‑08‑17 forcing session (zips `erdos501leansources*.zip`, at 83a5988) and forward-ported to the unified pin; audit identical to the original |
| Comparator files (`Challenge.lean`, `Solution.lean`, `comparator.json`; `ChallengeFlypitch.lean`, `SolutionFlypitch.lean`, `comparator-flypitch.json`) | `lake build` passes; comparator accepts both configurations (all seven targets each) |
| `formalization.yaml` (v0.4, Palomar conventions) | written 2026‑08‑19; validates against the upstream v0.4 JSON schema |
| CI (`.github/workflows/ci.yml`): statement sync check + build + axiom audit + comparator on both configurations | green on GitHub for the Flypitch pair (2026‑08‑17); to be re-run after this commit |
