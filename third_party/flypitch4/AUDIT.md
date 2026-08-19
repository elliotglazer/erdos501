# Independent audit of the Lean 4 port `flypitch4`, and the random-algebra addition

Date: 2026-08-16.  Audited commit: `ad649f8` of `ianklatzco/flypitch`
(`flypitch4/`, toolchain `leanprover/lean4:v4.30.0-rc2`,
Mathlib `83a5988a25fdd78621774a57af7e1f5c55f24289` as pinned in `lake-manifest.json`).

This document has two parts.  Part I is an independent audit of the port, with particular
attention to *statement formalization*, i.e. whether the theorem that is finally proved in Lean 4
is the theorem that was proved in Lean 3 (and the theorem one wants).  Part II describes the
alternative consistency proof of `¬CH` via the `ℵ₂`-random algebra that was appended to the
project.

---

## Part I — Audit of the port

### 1. Mechanical checks (reproduced independently)

* The pinned Mathlib was **built from source** (no `lake exe cache` was used), and then the whole
  project was built with `lake build`: **success, 1110 jobs, no errors** (only the pre-existing
  linter warnings).  The 25 Lean 4 files total 29 278 lines (Lean 3 original: 22 499 lines in
  31 files).
* `#print axioms` on every marquee theorem — `independence_of_CH`, `CH_unprovable`,
  `neg_CH_unprovable`, `CH_f_unprovable`, `neg_CH_f_unprovable`, `godel_completeness_theorem`,
  `boolean_valued_soundness_theorem`, `fundamental_theorem_of_forcing`, `ZFC_is_consistent`,
  `bSet.neg_CH₂`, `𝔹_CCC`, `collapse_algebra.CH₂_true`, `Fol.completeness`, … — reports exactly
  `[propext, Classical.choice, Quot.sound]`.
* Searched all of `Flypitch4/*.lean` for `sorry`, `admit`, `axiom`, `native_decide`,
  `implemented_by`, `extern`, `unsafe`, `opaque`, `#exit`, `partial`, `macro_rules`, `elab`:
  nothing on the proof path (`partial def` occurs only in the pretty-printer `PrintFormula.lean`,
  which is not used by any theorem; the build log contains no "declaration uses sorry").
* The port's own `validation/AxiomAudit.lean` and `validation/StatementShape.lean` were re-run
  and pass.
* With `set_option pp.explicit true`, `Fol.provable`, `Fol.SentTheory.sprovable`,
  `Fol.SentTheory.fst`, `Fol.SentTheory.is_consistent` and `independent` were printed to make
  sure they refer to the genuine root/Mathlib `Nonempty`, `Not`, `And`, `Set.image` (they do — no
  shadowing).
* Because the project does **not** set `autoImplicit false` (Lean's default is `true`), a typo in
  a statement could silently become a universally quantified variable.  The full signatures of
  all statement-relevant declarations were therefore checked with `#check @…`:
  `independence_of_CH : independent ZFC CH_f`, `CH_f : sentence L_ZFC`, `ZFC : SentTheory L_ZFC`,
  every ZFC axiom `: sentence L_ZFC`, `axiom_of_collection : {n : ℕ} → bounded_formula L_ZFC
  (n+2) → sentence L_ZFC`, `Ord_f : bounded_formula L_ZFC 1`, `at_most_f : bounded_formula L_ZFC 2`,
  `is_func'_f₂ : bounded_formula L_ZFC 3`, `V : (β : Type) → [NontrivialCompleteBooleanAlgebra β]
  → bStructure L_ZFC β`, `𝔹_cohen : Type`, `bSet_models_ZFC`, `unprovable_of_model_neg`, ….
  No stray arguments.

### 2. Statement-level comparison Lean 3 → Lean 4

Everything below was compared by reading the two sources side by side.

| Object | Lean 3 (`src/`) | Lean 4 (`Flypitch4/`) | Verdict |
|---|---|---|---|
| `Language` | `structure Language := (functions relations : ℕ → Type u)` | identical | ✔ |
| `preterm`, `preformula` (de Bruijn) | 3 / 6 constructors | identical constructors and arities | ✔ |
| `lift_term_at`, `subst_term`, `lift_formula_at`, `subst_formula`, `subst_realize` | | clause-by-clause identical | ✔ |
| `prf` (natural deduction) | 8 rules `axm, impI, impE, falsumE, allI, allE₂, ref, subst₂` | identical, incl. `lift_formula1 '' Γ` in `allI` and `f[t // 0]` in `allE₂`/`subst₂` | ✔ |
| `provable T f := nonempty (T ⊢ f)` | | `Nonempty (T ⊢ f)` | ✔ |
| `Theory L := set (sentence L)`, `Theory.fst := bounded_preformula.fst '' T`, `sprovable T f := T.fst ⊢' f.fst` | | `SentTheory`, `SentTheory.fst`, `SentTheory.sprovable` (notation `⊢ₛ'`) — identical | ✔ |
| `bounded_preterm`, `bounded_preformula`, `.fst` | | identical | ✔ |
| `bd_not, bd_and, bd_or, bd_biimp, bd_ex, bd_alls, subst0/substmax` | | identical definitions (notation `∼ᵇ, ⊓ᵇ, ⊔ᵇ, ⇔ᵇ, ∃ᵇ`) | ✔ |
| `Structure`, `realize_term/formula`, `realize_bounded_formula`, `ssatisfied`, `Model` | | identical (Tarski semantics) | ✔ |
| `bStructure` (Boolean-valued structure), `boolean_realize_formula`, `boolean_realize_bounded_formula`, `boolean_realize_sentence`, `forced_in`, `all_forced_in`, `bstatisfied`, `forced` | | identical (`⇒` = `imp a b := aᶜ ⊔ b`) | ✔ |
| `boolean_formula_soundness`, `boolean_soundness`, `unprovable_of_model_neg`, `consis_of_exists_bmodel` | | same statements | ✔ |
| `bSet`, `bv_eq`, `mem`, `check`, `bv_powerset`, `omega`, `larger_than`, `injects_into`, `is_func`, `is_func'`, `is_surj`, `Ord`, `CH`, `CH₂`, `CCC` | | identical | ✔ |
| `L_ZFC` (`∈`; `∅, pair, ω, 𝒫, ⋃`) | | identical | ✔ |
| `V β` (interpretation of `L_ZFC` in `bSet β`) | | identical (`ε ↦ ∈ᴮ`, `pr ↦ pair`, `P ↦ bv_powerset`, `Union ↦ bv_union`; verified via the `rfl` simp lemmas `boolean_realize_bounded_term_pair'` etc.) | ✔ |
| `axiom_of_emptyset`, `_ordered_pairs`, `_extensionality`, `_union`, `_powerset`, `_regularity`, `zorns_lemma`, `axiom_of_collection` (schema, closed by `bd_alls (n+1)`) | | identical formulas (variable indices, connectives, quantifier structure checked term by term) | ✔ |
| `is_transitive_f`, `epsilon_trichotomy_f`, `epsilon_well_founded_f`, `ewo_f`, `Ord_f`, `subset''`, `is_func_f`, `is_total'_f`, `is_total'_f₂`, `is_func'_f`, `is_func'_f₂`, `at_most_f`, `is_inj_f`, `injects_into_f` | | identical | ✔ |
| `CH_f := ∀' (Ord_f ⟹ (at_most_f[ω'/max] ⊔ at_most_f[𝒫ω'/0]))` | | identical | ✔ |
| `ZFC` (8 axioms ∪ collection schema) | | identical | ✔ (but see note 1) |
| `independent T f := ¬ T ⊢' f ∧ ¬ T ⊢' ∼f`, `independence_of_CH` | | identical | ✔ |
| Completeness theorem `T ⊢' ψ ↔ T ⊨ ψ` | | identical statement, proved | ✔ |
| Cohen algebra `𝔹_cohen := regular_opens (set (ℵ₂.type × ℕ))` | | `Flypitch.RegularOpens (Set (PSet.pSet_aleph2.Type × ℕ))` | ✔ |
| Collapse algebra `𝔹_collapse` | | `Flypitch.CollapseAlgebra pSet_aleph1.Type PSet.omega.powerset.Type` | ✔ |

Since the completeness theorem for the *same* proof system and the *same* (standard Tarski)
semantics is proved in the port, the proof system cannot be accidentally weaker than first-order
logic: `¬ (ZFC ⊢ₛ' CH_f)` implies `¬ (ssatisfied ZFC CH_f)`, the strongest reading of
"`CH` is unprovable from `ZFC`".

### 3. Discrepancies and remarks

1. **`axiom_of_infinity` — association of the outer conjunction.**  Lean 3 (`⊓'` is `infixr`)
   parses the axiom as `P ⊓ (Q ⊓ R)` with `P = (∅ ∈ ω ⊓ ∀x∈ω ∃y∈ω, x∈y)`, `Q = ∃α (Ord α ∧ ω = α)`,
   `R = ∀α (Ord α → limit α → ω ⊆ α)`; the Lean 4 port writes it as `((A ⊓ B) ⊓ Q) ⊓ R` with
   `P = A ⊓ B` (this is confirmed by the shape of the two proofs `bSet_models_infinity`).  The
   two sentences are trivially inter-derivable, so `ZFC` (Lean 4) and `ZFC` (Lean 3) are
   equivalent theories and `independence_of_CH` has the same mathematical content.  It is,
   however, a genuine (harmless) syntactic difference in the formal object called `ZFC`.
2. **Ordinals as pre-sets.**  Lean 3 defined its own `ordinal.mk` by transfinite recursion
   (`limit_rec_on`); the port uses Mathlib's `Ordinal.toPSet` (`PSet.ordinalMk` is an `abbrev`
   for it), a different but extensionally equivalent pre-set representation of von Neumann
   ordinals.  Nothing in the final statement depends on this choice; all cardinality lemmas
   (`mk_type_mk_eq''`, `ordinalMk_inj`, `omega_lt_aleph_one`, …) are re-proved for the new
   definition.  Similarly `PSet.is_func` is now phrased through `ZFSet.IsFunc` (Mathlib's
   quotient); the port's own `predicate-comparison.md` documents this.
3. **`autoImplicit` is not disabled** (there is no `autoImplicit = false` in `lakefile.toml`).
   Nothing went wrong (see §1), but this is a standing risk for future edits; adding
   `leanOptions = [{ name = "autoImplicit", value = false }]` (and `relaxedAutoImplicit = false`)
   to the lakefile is recommended.
4. Cosmetic: many "tactic does nothing / never executed", "unused variable", `Try this`
   linter warnings; two `def`s of class type not marked `@[reducible]`
   (`Flypitch.collapseSpace`, `bSet.subset'_partial_order`); universe of `V β` is fixed to
   `β : Type 0` exactly as in Lean 3 (`L_ZFC : Language.{1}`, `bSet β : Type 1`).
5. The Lean 3 files `abstract_forcing.lean`, `parse_formula.lean`, `reflect_test.lean`,
   `ring.lean`, `abel.lean`, `normal.lean`, `zfc_expanded.lean` (experiments / tests, not on the
   proof path) were not ported; `set_theory.lean` became `SetTheoryExt.lean`.  This does not
   affect the theorem.
6. The toolchain is a release candidate (`v4.30.0-rc2`) with `mathlib` at `master` in the
   lakefile; builds are reproducible only through `lake-manifest.json` (which does pin the
   commit).

### 4. Verdict

The port is legitimate: the formal statement `independence_of_CH : independent ZFC CH_f`
in `flypitch4` is (up to the harmless re-association of one conjunction inside
`axiom_of_infinity`) the same formal statement as in the Lean 3 Flypitch release 2.2, all the
underlying definitions (proof system, semantics, Boolean-valued models, ZFC axioms, `CH_f`) are
faithful, the project builds from source, and every marquee theorem depends only on
`propext`, `Classical.choice`, `Quot.sound`.

---

## Part II — Alternative consistency proof of `¬CH` via the `ℵ₂`-random algebra

### What was added

Four new files (1053 lines), registered in `Flypitch4.lean` and covered by the validation
scripts:

| File | Content |
|---|---|
| `Flypitch4/MeasureAlgebra.lean` (501 lines) | For a finite measure `μ` on a measurable space `X`, the **measure algebra** `MeasureAlgebra μ` (measurable sets modulo `μ`-null sets, a `Quotient` of `{s // MeasurableSet s}` by `s =ᵐ[μ] t`).  A single `BooleanAlgebra` instance (all axioms by a.e. pointwise reasoning); the descended measure `meas`; **`CCC_measureAlgebra`** (via `Measure.countable_meas_pos_of_disjoint_iUnion₀`); **completeness**: for a set `S` of classes, a countable family of representatives whose union has the maximal possible measure is an *essential union* (`exists_countable_essUnion`, using density of `ℚ` in `ℝ≥0∞`), giving `sSup`; `sInf` by complements; `instCompleteBooleanAlgebra`, `instNontrivialCompleteBooleanAlgebra` (for probability measures); `iSup_mk`/`iInf_mk` (countable sups/infs are unions/intersections). |
| `Flypitch4/RandomAlgebra.lean` (187 lines) | `fairCoin` on `Bool`; `cantorMeasure := infinitePi (fun _ : ℕ => fairCoin)` on `ℕ → Bool`; `μ_random := infinitePi (fun _ : ℵ₂ => cantorMeasure)` on `Ω := PSet.pSet_aleph2.Type → (ℕ → Bool)` (i.e. the fair-coin product measure on `2^(ℵ₂ × ω)`, using Mathlib's `MeasureTheory.Measure.infinitePi`); **`𝔹_random := MeasureAlgebra μ_random`** with `NontrivialCompleteBooleanAlgebra` and `𝔹_random_CCC`; the bits `χ ν n := ⟦{x | x ν n = true}⟧`; the measure computation `μ_random {x | ∀ n < N, x ν₁ n = x ν₂ n} ≤ 2⁻¹ ^ N` (cover by `2^N` cylinders of measure `4⁻¹ ^ N`) and hence **`iInf_biimp_χ_eq_bot : ν₁ ≠ ν₂ → ⨅ n, (χ ν₁ n ⇔ χ ν₂ n) = ⊥`**. |
| `Flypitch4/ForcingRandom.lean` (297 lines) | An **abstract `¬CH` theorem**: `bSet.neg_CH_of_CCC_of_indep : CCC 𝔹 → ∀ χ : ℵ₂̌.type → ℕ → 𝔹, IndepBits χ → (⊤ : 𝔹) ≤ CHᶜ` for any nontrivial complete Boolean algebra `𝔹` (cardinal preservation `ω < ℵ₁ < ℵ₂` from ccc, exactly as in `Forcing.lean`; the reals `indep_real.mk χ ν = {n ∈ ω ∣ χ ν n}` are pairwise distinct by `IndepBits`, giving an injection `ℵ₂̌ ↪ 𝒫(ω)`).  Instantiation: `bSet.neg_CH_random`, `bSet.neg_CH₂_random`, `V_𝔹_random_models_neg_CH : ⊤ ⊩[V 𝔹_random] ∼CH_f`, and **`CH_f_unprovable_random : ¬ (ZFC ⊢ₛ' CH_f)`**. |
| `Flypitch4/SummaryRandom.lean` (68 lines) | Summary/`#print axioms`: `random_algebra_CCC`, `random_algebra_forces_neg_CH`, `V_random_models_ZFC`, `V_random_models_neg_CH_f`, `CH_unprovable_random`, `independence_of_CH_random : independent ZFC CH_f`. |

The Cohen proof in `Forcing.lean`/`Zfc.lean` is left untouched; the new development only
imports it (for `PSet.pSet_aleph2` and the ccc→cardinal-preservation lemmas
`AE_of_check_larger_than_check`, `not_CCC_of_uncountable_fiber`, `uncountable_fiber_of_regular'`,
which were already generic in `𝔹`).

### Checks

* `lake build` (whole project incl. new files): success (2641 jobs).  The new files need
  measure theory from Mathlib (`Mathlib.Probability.ProductMeasure` and dependencies, ≈1500
  further Mathlib modules, all built from source here).
* `#print axioms` for `CH_unprovable_random`, `independence_of_CH_random`,
  `V_𝔹_random_models_neg_CH`, `bSet.neg_CH_random`, `bSet.neg_CH_of_CCC_of_indep`,
  `Flypitch.𝔹_random_CCC`, `Flypitch.MeasureAlgebra.CCC_measureAlgebra`,
  `Flypitch.MeasureAlgebra.instCompleteBooleanAlgebra`,
  `Flypitch.RandomAlgebra.iInf_biimp_χ_eq_bot`: all `[propext, Classical.choice, Quot.sound]`.
* No `sorry` in the new files.  `validation/AxiomAudit.lean` and `validation/StatementShape.lean`
  were extended with the new endpoints (in particular `example : ¬ Fol.SentTheory.sprovable ZFC
  CH_f := CH_unprovable_random`, i.e. *the same proposition* as `CH_unprovable`) and pass.
* `validation/DependencyCheck.lean` (new) walks the constants transitively used by the two proofs:
  `CH_f_unprovable_random` (31 342 constants) does **not** use `𝔹_cohen`, `𝔹_CCC`,
  `bSet.cohen_real.*`, `bSet.neg_CH`, `bSet.neg_CH₂` or `collapse_algebra.𝔹_collapse`, while
  `CH_f_unprovable` (11 523 constants) does use the Cohen ones; both share the generic
  infrastructure `bSet_models_ZFC`, `bSet.AE_of_check_larger_than_check`,
  `bSet.not_CCC_of_uncountable_fiber` (and neither uses `sorryAx`).  So the two proofs of
  `¬ (ZFC ⊢ₛ' CH_f)` are genuinely independent at the level of the forcing notion.

### Remarks on the mathematics

* `𝔹_random` is the measure algebra of the product (Haar) measure on `2^(ℵ₂×ω)` w.r.t. the
  product σ-algebra; this is the standard "`ℵ₂`-random algebra" (the measure algebra of Maharam
  type `ℵ₂`; the Borel-modulo-null presentation is isomorphic to it).
* Only three properties of `𝔹_random` are used for `¬CH`: it is a nontrivial complete Boolean
  algebra, it satisfies ccc, and it carries `ℵ₂` independent bits.  This is made explicit by the
  abstract theorem `neg_CH_of_CCC_of_indep`, of which both the Cohen and the random proof are
  instances (for the Cohen algebra, `χ ν n` would be the principal open set of `(ν, n)`).

---

## Part III — Erdős problem #501 (first question): independence from `ZFC`

Added in `Flypitch4/Erdos501/` (see its `README.md`):

* `Sentence.lean` — `Flypitch.Erdos501.Erdos501_f : sentence L_ZFC`, the first-order rendering of
  DeepMind's `erdos_501` (every family `⟨A_x : x ∈ ℝ⟩` of bounded sets of reals of Lebesgue outer
  measure `< 1` has an infinite independent set), built with a de-Bruijn-*level* combinator layer
  (`Fm := ∀ n, bounded_formula L_ZFC n`; quantifiers pass the level of the bound variable to their
  body, so scoping is checked by Lean).  `ℝ` is not constructed: the sentence quantifies over all
  complete ordered fields `(R, +, ·, <, 0, 1)` (given as sets) and asserts the property for each;
  outer measure `< 1` is "a cover by open intervals `(aₙ, bₙ)`, `n ∈ ω`, whose partial sums stay
  `≤ r < 1`"; `Infinite` is "`ω` injects"; `Independent` is `∀ x y ∈ X, x ≠ y → x ∉ A(y)`.
  `Erdos501_f` uses no `sorry` (axioms `[propext, Quot.sound]`); its printed form (4223 characters)
  and all building blocks can be inspected with `validation/Erdos501Print.lean`.
* `ColRandom.lean` — the forcing notion `𝔹_col_random := RO(𝔹_collapse⁺ × (randomAlgebra RandomIndex)⁺)`
  (`RandomAlgebra.lean` was generalized to `randomAlgebra ι` for an arbitrary index type;
  `#RandomIndex = 𝔠⁺`, which is `ω₂` of the collapse extension), a `NontrivialCompleteBooleanAlgebra`
  in `Type`, and the assertion
  `erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f := sorry`, with the derived
  corollary `neg_Erdos501_f_unprovable_of_col_random : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)` (this literal
  version is not on the formalized route, see Part III (b) below).  The use of the *product* poset
  (rather than an iteration with a name) encodes the standard fact that the `ω₂`-random algebra of
  the σ-closed extension by `Col(ω₁, ℝ)` is the check name of the ground-model random algebra with
  `𝔠⁺` coordinates; this is documented in the module docstring and is the one modelling choice a
  reader should be aware of.
* `Bridge.lean` (with `StdSemantics.lean`, `RealsInZFSet.lean`, `ZFSetCOF.lean`) — **the bridge,
  proved**: `stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`,
  where `erdos501_deepmind : Prop` is the DeepMind proposition verbatim and `stdStructure :
  Structure L_ZFC` is Mathlib's `ZFSet` with `∅`, Kuratowski pairs, `ω`, `𝒫`, `⋃`, `∈`.  This pins
  down the meaning of the sentence as a Lean *theorem*: in the standard model, `Erdos501_f` holds iff
  the DeepMind proposition holds.  Ingredients: the two-valued unfolding `realize_Erdos501_f_std`
  (the analogue of `Semantics.lean`); the coding of `ℝ` as a complete ordered field
  `(Rz, plusZ, timesZ, ltZ, zeroZ, oneZ)` inside `ZFSet` (`completeOrderedField_Rz`) with the covering
  lemma `exists_cover_of_volume_lt_one` for the outer-measure hypothesis (`RealsInZFSet.lean`,
  direction ⇒); and, for the converse, the instances `Field`, `LinearOrder`, `IsStrictOrderedRing`,
  `ConditionallyCompleteLinearOrder` on the carrier of an arbitrary complete ordered field inside
  `ZFSet`, verified from the twenty internal axioms, so that Mathlib's uniqueness theorem for
  conditionally complete linear ordered fields yields `realIso : ℝ ≃+*o Carrier F`, along which the
  Erdős property is transported (`ZFSetCOF.lean`).  Axioms `[propext, Classical.choice, Quot.sound]`.
* `validation/Erdos501Audit.lean` — `#print axioms`: only `erdos501_of_col_random` (and its
  corollary `neg_Erdos501_f_unprovable_of_col_random`) depend on `sorryAx`; the main theorems
  `erdos501_forced`, `erdos501_of_random`, `neg_Erdos501_f_unprovable`, `erdos501_ex_forced`,
  `erdos501_ex_of_random`, `neg_Erdos501_ex_f_unprovable` and the bridge
  `stdStructure_realize_Erdos501_f_iff` do not.

### Part III (b) — the proof begins: units (F3)–(F5) of the paper's plan

The rev10 paper's units are (F1) Thms 2.1–2.2, (F2) Thms 3.1–3.2, (F3) Thm 4.3 (Δ-system),
(F4) Thms 4.1, 4.2, 4.4 (countable support and homogeneous Borel reading), (F5) Thm 4.5 (isolated
fresh-coordinate forcing argument), (F6) Thm 5.1 (assembly into the certificate interface).
Files (see `Flypitch4/Erdos501/README.md` for the statements): `RandomForcing.lean` — Thms 4.1, 4.2
and 4.5, all proved, axioms `[propext, Classical.choice, Quot.sound]`; `DeltaSystem.lean` — Thm 4.3
proved for `𝔠⁺` countable sets (no `CH` needed in this form since `𝔠^{ℵ₀} = 𝔠 < 𝔠⁺`; Zorn for
maximal families disjoint outside a small set, pigeonhole on traces, and a closure chain of length
`ω₁` on `(ℵ₁).ord.ToType`); `HomogeneousReading.lean` — Prop. 4.4 proved from Thm 4.1, Thm 4.3 and the
count `card_measurable_le_continuum` (≤ `𝔠` Borel functions `2^R × 2^ℕ → 2^ω`).  All of (F3)–(F5)
is `sorry`-free.  Thm 4.5 is proved at the level of Boolean values of events
read from the generic point (`bot_lt_inf_mk_of_fiber_pos_comp`, `exists_fresh_petal_of_fiber_pos`);
its literal internal form `⊩ ν*(Ż) = 1`, and (F6), require names for Borel sets / the internal
measure theory of `V (randomAlgebra ι)`, which is the next unit.  For an index type `ι`, with
`Ω ι = ι → 2^ω`, `μ_random ι` and `randomAlgebra ι` as in `RandomAlgebra.lean`:

* **Thm 4.1** `exists_countable_support` (measurable sets depend on countably many coordinates);
  `mkReal F hF : bSet (randomAlgebra ι)`, the name of the real `{n | F(ĝ) n = 1}` read from the
  generic point by a measurable `F : Ω ι → 2^ω`, with `mem_mkReal : (of_nat n ∈ᴮ mkReal F hF) =
  [{x | F x n = true}]`; `genericReal α`; and the **Borel reading theorem**
  `exists_mkReal_restrict_bv_eq`: every name `ẋ` with `⊤ ≤ ẋ ⊆ᴮ omega` satisfies
  `⊤ ≤ ẋ =ᴮ mkReal (F ∘ (·↾S)) _` for a countable `S ⊆ ι` and a measurable `F : 2^S → 2^ω`.  The
  extensionality principle used (`eq_of_forall_of_nat_mem_eq`: two names for subsets of `ω` with
  the same Boolean values `‖n ∈ ·‖`, `n ∈ ℕ`, are forced equal) is proved for every
  `NontrivialCompleteBooleanAlgebra`.
* **Thm 4.2** `indepFun_restrict_restrict` (`𝔹(T ⊔ P) = 𝔹(T) ⊗ 𝔹(P)`: for disjoint `T, P ⊆ ι` the
  restrictions `x↾T`, `x↾P` are independent under `μ_random ι`), `map_restrict_prod_restrict` (joint
  law = product of the fair-coin marginals), `μ_random_restrict_prod_restrict` (the pull-back along
  `x ↦ (x↾T, x↾P)` is measure preserving), the single-coordinate and petal versions
  (`indepFun_restrict_eval`, `map_restrict_prod_eval`, `map_comp_injective`, `indepFun_restrict_comp`,
  `map_restrict_prod_comp`), and Fubini `measure_restrict_prod_of_map`.
* **Prop. 4.4** `homogeneous_reading`: `𝔠⁺` names for subsets of `ω`, an injective choice of profile
  coordinates `d` and a countable `R₀` yield `J` with `#J = 𝔠⁺`, a countable root `R ⊇ R₀`, pairwise
  disjoint petals `π a : ℕ ↪ ι` avoiding `R` with `π a 0 = d a`, and one Borel `F : 2^R × 2^ℕ → 2^ω`
  with `⊤ ≤ ẋ_a =ᴮ mkReal (fun ĝ => F (ĝ↾R, ĝ ∘ π a))` for all `a ∈ J`.
* **Thm 4.5** `measure_pos_of_fiber_pos_of_map` / `bot_lt_inf_mk_of_fiber_pos(_comp)`: if
  `q = [{x | x↾T ∈ Q}] ≠ ⊥` and the fibres `B_t` (`t ∈ Q`) of a Borel `B ⊆ 2^T × 2^P` have measure
  `≥ ε > 0` a.s., then `q ⊓ [{x | (x↾T, ĝ ∘ π) ∈ B}] ≠ ⊥` for every coordinate/petal avoiding `T`
  (its measure is `≥ ε · μ_T(Q)`); `exists_fresh_petal_of_fiber_pos`: among uncountably many pairwise
  disjoint petals some petal is fresh over the countable support `T` and the above holds.

* **Names for Borel sets** (`BorelNames.lean`, all proved): `bv_eq_mkReal`
  (`‖mkReal G = mkReal F‖ = [{x | G x = F x}]`); `borelName T B`, the name of the Borel set of
  reals `{r | (ĝ↾T, r) ∈ B}` read from `B ⊆ 2^T × 2^ω` (elements: the canonical names of all reals,
  membership value `[{x | (x↾T, F x) ∈ B}]`), with `mem_borelName_mkReal`, `mem_borelName` (every
  name for a real), `mem_borelName_le_subset_omega`; `profileName π` (`ż = ĝ ∘ π`, coded as a real),
  `profilesName J π` (`Ż`), `borelNameP T B'` (Borel sets of profiles), `mem_borelNameP_profileName :
  ‖ż ∈ Ḃ‖ = [{x | (x↾T, ĝ ∘ π) ∈ B'}]`, `iSup_mem_profilesName : ‖∃ z ∈ Ż, z ∈ Ḃ‖ = ⨆ a ‖ż_a ∈ Ḃ‖`;
  `measGtP T hB' ε` = the Boolean value of "`ν(Ḃ) > ε`"; and **Theorem 4.5 with names**,
  `fullness : ‖ν(Ḃ) > ε‖ ≤ ⨆ a ∈ J, ‖ż_a ∈ Ḃ‖` for uncountably many pairwise disjoint petals,
  countable `T`, Borel `B'`, `ε > 0` — i.e. `⊩ ν(Ḃ) > ε → Ḃ ∩ Ż ≠ ∅` (`⊩ ν*(Ż) = 1` modulo the
  Borel reading of codes).

* **ZFC core** (`ZFCCore.lean`): (F1) Lemma 2.1 `measure_Q_pos` (positive-measure selection, by
  double counting with `Measure.prod_apply`/`prod_apply_symm`) and Lemma 2.2
  `measure_diff_eq_top_of_mem_Q`, both proved; (F2) Definition 3.1 as the structure `Certificate A Ω`
  (probability measure `ν`, `Z` meeting every positive-measure Borel set, `x m` with law
  `λ↾[m, m+1)`, jointly measurable envelopes `U m` of measure `< 1` covering `A (x m z)` for `z ∈ Z`),
  and Theorem 3.2 `exists_infinite_independent_of_certificate` (a certificate yields an infinite
  independent set), proved by the paper's recursion on `ℤ × Ω` with `counting ⊗ ν`; also
  `erdos501_deepmind_of_certificate` (line 1 of the paper's decomposition (1.1), in the ground model)
  and `map_profileTest` ((P2) for the test points `m + ρ(z 0)`, given a measure-preserving `ρ`).  Units
  (F1)–(F5) are now all `sorry`-free.  `PLAN.md` records the design of (F6)/(F7); its step S1 is
  done in `BinaryExpansion.lean` (`map_binExp`: binary expansion pushes the coin measure to Lebesgue
  measure on `[0,1)`, hence (P2) for the profile test points, `map_profileTest_binExp`).

* **The Boolean value of `Erdos501_f`** (`Semantics.lean`, proved for every nontrivial complete
  Boolean algebra `β`): `realize_Erdos501_f : ⟦Erdos501_f⟧[V β] = Sem.erdos501`, where the `Sem.*`
  predicates (`Sem.completeOrderedField`, `Sem.erdosProperty`, `Sem.bounded`,
  `Sem.outerMeasureLtOne`, `Sem.infinite`, `Sem.independent`, …) are the Boolean-valued counterparts
  of the blocks of `Sentence.lean`, stated directly on names — a mechanical `simp` computation
  (unfolding the level-based combinators at depth `0` and evaluating the de Bruijn indices).  Hence
  `forced_Erdos501_f_iff : (Γ ⊩[V β] Erdos501_f) ↔ ∀ R plus times lt zero one,
  Γ ⊓ Sem.completeOrderedField R … ≤ Sem.erdosProperty R …`.  This also gives an independent,
  semantic reading of the sentence for auditing purposes.
* **The internal reals** (`InternalReals.lean`, step S2 of `PLAN.md`, proved): names
  `realName f = mkReal (code ∘ f)` for measurable `f : Ω ι → ℝ` (cut codes),
  `bv_eq_realName : ‖realName f = realName g‖ = [{x | f x = g x}]`; the names `Rdot`, `plusDot`,
  `timesDot`, `ltDot`, `zeroDot`, `oneDot`; evaluation lemmas (`mem_Rdot`, `app2_opDot`, `lt_ltDot`,
  `le_ltDot_realName`); and `completeOrderedField_Rdot : ⊤ ≤ Sem.completeOrderedField Rdot plusDot
  timesDot ltDot zeroDot oneDot` — all twenty axioms, each reduced to the pointwise fact about `ℝ`
  through natural-deduction-style rules on Boolean values, and Dedekind completeness
  (`complete_Rdot`) with the supremum read off from the events `‖∃ s ∈ S, qₙ < s‖`.

* **Reading internal data** (`RealReading.lean`, step S3 of `PLAN.md`, proved): every internal
  real is canonical (`realName_of_mem_Rdot : Γ ≤ y ∈ᴮ Rdot → ∃ g, Γ ≤ y =ᴮ realName g`, via a
  Γ-version of Theorem 4.1 and decoding of cut codes), internal sequences `ω → Rdot` are sequences
  of readings (`exists_seq_of_isFun`), the maximum principle for the witnesses of
  `Sem.outerMeasureLtOne` (`outerMeasureLtOne_elim`, from Flypitch's `maximum_principle` and the
  extensionality of realizations `B_ext_realize`), names `openName a b` of open sets, and the
  reading theorem `outerMeasureLtOne_reading`: the internal outer-measure hypothesis for `S` yields
  ground sequences `a b : ℕ → MeasReal ι` with `S ⊆ᴮ openName a b` and, on `Γ`, nondegenerate
  intervals of total length `< 1`, hence `λ(⋃ (aₙ x, bₙ x)) < 1` (`volume_iUnion_Ioo_lt_one`).

* **Homogeneous envelopes** (`Envelopes.lean`, step S4, proved): the value `valSet A x` of a
  function name `A : Rdot → 𝒫(Rdot)` (`app_valSet`, via extensionality for subsets of `Rdot` in
  context), the profile test points `testPoint m α = m + binExp (ĝ α)`, the coding of families
  `ℤ → ℕ → ℝ × ℝ` as subsets of `ω`, and `exists_homogeneous_envelopes`: for `𝔠⁺` coordinates
  `d a`, `J` with `#J = 𝔠⁺`, a countable root `R`, pairwise disjoint petals `π a` with `π a 0 = d a`
  and one Borel `E : 2^R × 2^ℕ → (ℤ → ℕ → ℝ × ℝ)` such that on `Γ`, for `a ∈ J` and `m`,
  `A(testPoint m (d a)) ⊆ᴮ openName (envA E (π a) m) (envB E (π a) m)` and the cover event holds —
  the paper's (5.4)–(5.8).
* **Measurable selection from fullness** (`Selection.lean`, proved): every supremum in the measure
  algebra is a countable supremum (`exists_countable_iSup_eq`), whence
  `exists_seq_of_fullness`/`exists_selection_of_fullness`: for a Borel `B'` of profiles read from a
  countable `T` and uncountably many pairwise disjoint petals, a sequence `a k ∈ J` and a measurable
  selector with `(ĝ↾T, ĝ ∘ π (a (sel ĝ))) ∈ B'` a.e. on `{ν(B'_{ĝ↾T}) > 0}` — one step of the
  recursion of Theorem 3.2 on names.

* **The recursion of Theorem 3.2 on names** (`Recursion.lean`, step S6 part 1, proved): the
  σ-finite space `SS = ℤ × 2^P` with `μS = count ⊗ ν`, the test map `xx (m, z) = m + binExp (z 0)`
  (`μS_preimage_xx : μS (xx⁻¹ B) = λ(B)`), the truncated envelopes `envSet E t s`, the relation
  `Erel E` and its section `ErelX E ĝ` (horizontal sections of `μS`-measure `≤ 1`), the
  positive-measure set `QX E C ĝ` of Lemma 2.1 (`QX_pos`), one stage of the recursion as a
  measurable choice of countable range from fullness (`exists_stage_selection`), the stages
  `stage j` and chosen points `tj j ĝ`, `ae_good` and `tj_not_mem_removedX`.
* **The name of the infinite independent set** (`Assembly.lean`, step S6 part 2, proved): the name
  `Xname` (elements `testPoint (cand j k).1 (d (cand j k).2)`, Boolean values `[sel j = k]`), the
  name `fname` of `j ↦ x_j`, `infinite_Xname`, `independent_Xname`,
  `exists_infinite_independent_name`, and
  **`erdosProperty_Rdot : 𝔠⁺ ≤ #ι → ⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot`**
  — Theorem 3.2 inside `V (randomAlgebra ι)` for the internal reals; with
  `completeOrderedField_Rdot`, `completeOrderedField_and_erdosProperty_Rdot`: `V (randomAlgebra ι)`
  has a complete ordered field with the Erdős property.  Axioms:
  `[propext, Classical.choice, Quot.sound]`.

* **The main theorems** (`Main.lean`, proved): `erdos501_ex_forced : 𝔠⁺ ≤ #ι →
  ⊤ ⊩[V (randomAlgebra ι)] Erdos501_ex_f` (the existential sentence "there is a complete ordered
  field with the Erdős property", `Sentence.lean`; its Boolean value `Sem.erdos501_ex` is computed
  in `Semantics.lean`, `realize_Erdos501_ex_f`), `erdos501_ex_of_random` for
  `𝔹_random_succ_continuum = randomAlgebra RandomIndex`, and
  **`neg_Erdos501_ex_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_ex_f)`** — the relative consistency of a
  positive answer to Erdős #501 (first question) — all with axioms
  `[propext, Classical.choice, Quot.sound]`.  The universal sentence `Erdos501_f` follows by unit
  (F8) (below): `erdos501_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f` (`Transfer.lean`),
  `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f` and
  **`neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)`**, all proved with the same axioms.

* **(F8), part 1** (`InternalField.lean`, proved): the Boolean-valued theory of an arbitrary internal
  complete ordered field — operations named by the maximum principle, ordered-group laws, `0 < 1`,
  halving, internal dyadics `dyR m k = m/2^k`, the Archimedean property `arch`, floor and density
  `dense` — generic in the Boolean algebra; axioms `[propext, Classical.choice, Quot.sound]`.

* **(F8), part 2** (`InternalIso.lean`, proved): the readings `rd F r` of the dyadic cuts of the
  elements of an internal complete ordered field, the reading lemma, and the internal isomorphism
  `psi F : F.R → Rdot` — a function (`psi_isFun`), order-preserving and -reflecting, injective,
  additive, `zero ↦ 0`, `one ↦ 1`, surjective (`psi_surj`); axioms
  `[propext, Classical.choice, Quot.sound]`.

* **(F8), part 3** (`Transfer.lean`, proved): the introduction rule for `Sem.outerMeasureLtOne Rdot …`
  from ground readings, the transported family `Atr F A` (a function `Rdot → 𝒫 Rdot` with values of
  outer measure `< 1`), the pull-back of the independent set, and `erdosProperty_of_COF : 𝔠⁺ ≤ #ι →
  Γ ≤ F.COF → Γ ≤ Sem.erdosProperty F.R F.plus F.ltR F.zero F.one` for every internal complete
  ordered field; hence `erdos501_forced`; axioms `[propext, Classical.choice, Quot.sound]`.

* **The bridge** (`StdSemantics.lean`, `RealsInZFSet.lean`, `ZFSetCOF.lean`, `Bridge.lean`, proved):
  `stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` — the sentence
  is a faithful rendering of DeepMind's proposition; axioms `[propext, Classical.choice, Quot.sound]`.

* **The ¬CH direction** (`OmegaClosed.lean`, `CheckReals.lean`, `Hechler.lean`, proved):
  `Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` via `neg_erdos501_forced_collapse :
  ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`.  `CH` holds in the collapse model (`collapse_algebra.CH_true`), so
  Hechler's family `A_r = {s : |s| ≤ |r|+1, s ≺ r}` — with `≺` the well-order induced by the generic
  surjection `ℵ₁̌ ↠ 𝒫(ω)` of `ForcingCH.lean` — is a family of countable (hence outer-measure `< 1`)
  bounded sets with no infinite independent set (`no_infinite_independent`, via the combinatorial
  descent `no_descent` and ω-closed refinement, `exists_forall_of_denseOmegaClosed`).  Here the
  check-name reals `Rc` are shown to be an internal complete ordered field of `V 𝔹_collapse`
  (`completeOrderedField_Rc`, Dedekind completeness using the collapse's `(ω,∞)`-distributivity).
  Axioms `[propext, Classical.choice, Quot.sound]`.

* **The marquee theorem** (`Hechler.lean`, proved): **`independence_of_Erdos501 : independent ZFC
  Erdos501_f`** — neither `Erdos501_f` nor `∼Erdos501_f` is a theorem of `ZFC`, so the first question
  of Erdős #501 is independent of `ZFC`.  Axioms `[propext, Classical.choice, Quot.sound]`.

Not yet done (off-route): the paper's literal two-step forcing `𝔹_col_random`
(`erdos501_of_col_random`) — the only remaining `sorry` in the repository (it is *not* needed for the
independence result, which is complete).

*Update (erdos501 repository, 2026‑08‑17):* the `sorry`-stated assertion `erdos501_of_col_random`
and its corollary `neg_Erdos501_f_unprovable_of_col_random` (and the trivial
`V_col_random_models_ZFC`) were removed from `ColRandom.lean`; the algebra `𝔹_col_random` is kept
as a definition for reference.  The repository contains no `sorry` outside the two comparator
Challenge files (`Challenge.lean`, `ChallengeFlypitch.lean`).
