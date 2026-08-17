# Erdős problem #501 (first question) in the Flypitch framework

This directory contains the formalization of **the independence from `ZFC` of the first question of
Erdős problem #501** — as formalized in DeepMind's `formal-conjectures`
(`FormalConjectures/ErdosProblems/501.lean`, theorem `erdos_501`):

> ```
> ∀ (A : ℝ → Set ℝ), (∀ x, Bornology.IsBounded (A x)) → (∀ x, volume.toOuterMeasure (A x) < 1) →
>   ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y)
> ```

rendered as sentences of first-order set theory (`Sentence.lean`: `Erdos501_f`, "every complete
ordered field has the Erdős property", and `Erdos501_ex_f`, "there is a complete ordered field with
the Erdős property"; `ZFC` proves both equivalent to each other and to the statement about `ℝ`).  The
main result is **`independence_of_Erdos501 : independent ZFC Erdos501_f`**: neither `Erdos501_f` nor
its negation is provable — a positive answer is forced by adding `𝔠⁺` random reals, and a negative
answer (Hechler's `CH` counterexample) is forced by the collapse `Col(ω₁, ℝ)`.

## Main theorems (`Main.lean`)

**All fully proved** (no `sorry`; axioms `[propext, Classical.choice, Quot.sound]`):

* `erdos501_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f` (`Transfer.lean`) — **adding
  `𝔠⁺` random reals forces the universal sentence**: every complete ordered field of the extension
  has the Erdős property.  The proof is Theorem 3.2 of the paper run on names for the internal reals
  `Rdot` (`erdosProperty_Rdot`, `Assembly.lean`), followed by the internal isomorphism of an
  arbitrary internal complete ordered field with `Rdot` and the transport of the Erdős property
  along it (unit (F8): `InternalField.lean`, `InternalIso.lean`, `Transfer.lean`);
* `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f` for the concrete index set
  `RandomIndex` (`#RandomIndex = 𝔠⁺`), and `erdos501_ex_forced`, `erdos501_ex_of_random` for the
  existential form `Erdos501_ex_f`;
* `neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)` and `neg_Erdos501_ex_f_unprovable` — **`ZFC`
  does not refute a positive answer to Erdős #501 (first question)**: the relative consistency of a
  positive answer, for both renderings of the sentence;
* `Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` and **`independence_of_Erdos501 : independent ZFC
  Erdos501_f`** (`Hechler.lean`) — **`ZFC` does not *prove* `Erdos501_f` either**, so the first
  question is **independent of `ZFC`**.  In the collapse model `V 𝔹_collapse` (where `CH` holds,
  `collapse_algebra.CH_true`) Hechler's family `⟨A_x⟩` of countable bounded sets of reals has no
  infinite independent set, forcing `∼Erdos501_f` (`neg_erdos501_forced_collapse`);
* **the bridge** `stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`
  (`Bridge.lean`) — **the sentence `Erdos501_f` means exactly DeepMind's proposition**: in the
  standard model `ZFSet` of Lean/Mathlib, `Erdos501_f` holds iff `erdos501_deepmind` (the right-hand
  side of `erdos_501` in `formal-conjectures`, verbatim) holds.  The proof codes `ℝ` as a complete
  ordered field inside `ZFSet` (`RealsInZFSet.lean`) and, conversely, shows that every complete
  ordered field inside `ZFSet` is order-isomorphic to `ℝ` by Mathlib's uniqueness theorem for
  conditionally complete linear ordered fields (`ZFSetCOF.lean`).

The paper's assertion in its literal form,

> **Assertion.** Forcing with `Col(ω₁, ℝ)` and then adding `ω₂` random reals produces a model of
> `ZFC` in which the first question of Erdős problem #501 has a positive answer,

is stated as `erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f := sorry` (`ColRandom.lean`).
It is *not* on the formalized route: the collapse `Col(ω₁, ℝ)` served in the paper to obtain `CH`
for the Δ-system argument at `ω₂`, which the formalization replaces by using `𝔠⁺` random reals over
the ground model directly (`exists_homogeneous_envelopes`), so that no collapse is needed for the
consistency result.

## Files

| File | Content |
|---|---|
| `Sentence.lean` | `Flypitch.Erdos501.Erdos501_f : sentence L_ZFC`, the first-order rendering of the DeepMind proposition (see below), built with a small "de Bruijn level" combinator layer (`Fm`, `Tm`, `allF`, `exF`, `allIn`, `exIn`, …) so that variable scoping is checked by Lean; and its existential form `Erdos501_ex_f`. |
| `Main.lean` | **The main theorems** (see above): `erdos501_ex_forced`, `erdos501_ex_of_random`, `neg_Erdos501_ex_f_unprovable`, `erdos501_of_random`, `neg_Erdos501_f_unprovable`, all proved. |
| `Transfer.lean` | Unit (F8), part 3: **transport of the Erdős property along `psi`**.  The introduction rule `outerMeasureLtOne_of_readings` for `Sem.outerMeasureLtOne Rdot …` from ground sequences of readings (the converse of the S3 reading theorem), the transported family `Atr F A = {(psi r, psi[A(r)]) | r ∈ F.R}` — a function `Rdot → 𝒫 Rdot` (`Atr_isFun`) whose values have outer measure `< 1` (`Atr_values`: the covering sequences of `A(r)` in `F` are read through `psi`, `readings_*`) — Theorem 3.2 in `V^{randomAlgebra ι}` (`exists_infinite_independent_of_omlt1`) applied to `Atr F A`, and the pull-back `Xpb F X' = {r | psi r ∈ X'}`, infinite (`infinite_Xpb`) and independent for `A` (`independent_Xpb`).  Result: **`erdosProperty_of_COF : 𝔠⁺ ≤ #ι → Γ ≤ F.COF → Γ ≤ Sem.erdosProperty F.R F.plus F.ltR F.zero F.one`** for every internal complete ordered field, and **`erdos501_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f`**. **Proved** (920 lines). |
| `InternalField.lean` | Unit (F8), part 1 (`PLAN.md` §6): **internal complete ordered fields**.  For six names `F = (R, plus, times, ltR, zero, one)` with `Γ ≤ F.COF`: names for the operations by the maximum principle (`Fld.add`, `Fld.mul`, `Fld.neg`, `Fld.inv`), the ordered abelian group laws (`add_assoc`, `add_comm`, `add_zero`, `add_neg`, cancellation, `add_lt_add_right`, …), `zero_lt_one`, halving (`half_add_half`), the internal naturals `mulN n x`, halves `hR k = 1/2^k`, dyadics `dyR m k = m/2^k` with their order (`dyR_lt_of_cross`, `not_dyR_lt_of_cross`) and additive arithmetic (`dyR_add`, `dyR_neg`, `dyR_double`), the **Archimedean property** `arch` (from `Sem.complete`), the floor `exists_floor` and the **density of the dyadics** `dense`.  Generic in `β`; the equivalence `x ≡[Γ] y` (`Γ ≤ x =ᴮ y`) is usable in `calc`. **Proved** (1300 lines). |
| `ColRandom.lean` | The index set `RandomIndex` (`#RandomIndex = 𝔠⁺`) and the random algebra `𝔹_random_succ_continuum = randomAlgebra RandomIndex`; the complete Boolean algebra `𝔹_col_random` of the paper's two-step forcing, and the literal assertion `erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f := sorry` with its consequence `neg_Erdos501_f_unprovable_of_col_random` (not on the formalized route). |
| `Bridge.lean` | **The bridge**: `stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`, the faithfulness of the rendering, **proved** from the three files below. |
| `StdSemantics.lean` | Bridge, part 1: `erdos501_deepmind : Prop` (the DeepMind proposition verbatim), the standard structure `stdStructure` on Mathlib's `ZFSet` (`∅`, Kuratowski pairs, `ω`, `𝒫`, `⋃`, `∈`), the two-valued predicates `StdSem.*` on `ZFSet` mirroring the blocks of `Sentence.lean`, and the computation `realize_Erdos501_f_std : (stdStructure ⊨ₘ Erdos501_f) ↔ StdSem.erdos501` (the analogue of `Semantics.lean`); a `ZFSet` toolkit (the finite ordinals `natZ n`, `mem_omega_iff`, values `fval`/`opval` of internal functions/operations). **Proved.** |
| `RealsInZFSet.lean` | Bridge, part 2 (`StdSem.erdos501 → erdos501_deepmind`): the coding `cutZ r` of a real by its rational cut (injective), the complete ordered field `(Rz, plusZ, timesZ, ltZ, zeroZ, oneZ)` inside `ZFSet` (`completeOrderedField_Rz`, all twenty axioms), the copies `setZ`, `famZ`, `seqZ` of sets, families and sequences of reals, the **covering lemma** `exists_cover_of_volume_lt_one` (a set of reals of Lebesgue outer measure `< 1` is covered by open intervals `(aₙ, bₙ)` with all partial sums of lengths `≤ r < 1`, extracted from the definition of the Lebesgue outer measure as `OuterMeasure.ofFunction`), the internal hypotheses for `famZ A` (`bounded_setZ`, `outerMeasureLtOne_setZ`), and the pull-back of an internal infinite independent set (`erdos501_deepmind_of_std`). **Proved.** |
| `ZFSetCOF.lean` | Bridge, part 3 (`erdos501_deepmind → StdSem.erdos501`): for a complete ordered field `F` inside `ZFSet` (a bundle `COF`), the carrier `Carrier F = {x // x ∈ F.R}` with the operations read off from `plus`, `times`, `ltR`, and the instances `Field`, `LinearOrder`, `IsStrictOrderedRing`, `ConditionallyCompleteLinearOrder` verified from the internal axioms; the isomorphism `realIso : ℝ ≃+*o Carrier F` (Mathlib's `ConditionallyCompleteLinearOrderedField.inducedOrderRingIso`); the pull-back `pull A : ℝ → Set ℝ` of an internal family (`isBounded_pull`, `volume_pull_lt_one`), the push-forward `push X'` of an infinite independent set (`infinite_push`, `independent_push`), and `erdos501_std_of_deepmind`. **Proved.** |
| `OmegaClosed.lean` | The ¬CH direction, part 1: **ω-closed refinement** for a dense ω-closed subset `D ⊆ 𝔹` (`Flypitch.DenseOmegaClosed`, e.g. the principal opens of the collapse poset): countably many choices/decisions can be made simultaneously below any nonzero `Γ` (`exists_forall_of_denseOmegaClosed`, `exists_decide_of_denseOmegaClosed`, `exists_witness_of_denseOmegaClosed`).  This is the external form of the `(ω,∞)`-distributivity of `𝔹_collapse` ("no new `ω`-sequences"), and it is the only property of the collapse algebra the argument uses. **Proved.** |
| `CheckReals.lean` | The ¬CH direction, part 2: **the check-name reals** as an internal complete ordered field of `V 𝔹`.  `rname r = check (codeP r)` (`rname_bv_eq_of_ne : rname r =ᴮ rname s = ⊥` for `r ≠ s`), the names `Rc`, `plusC`, `timesC`, `ltC`, `zeroC`, `oneC`, evaluation lemmas, the nineteen first-order axioms (generic `𝔹`), and Dedekind completeness `complete_Rc` for `𝔹` with a dense ω-closed subset (the cut of an internal `S ⊆ Rc` is decided on a nonzero piece, so its supremum is a ground real), giving `completeOrderedField_Rc` / `completeOrderedField_Rc_collapse`. **Proved.** |
| `Hechler.lean` | The ¬CH direction, part 3: **Hechler's counterexample in `V 𝔹_collapse`**.  The generic surjection `ℵ₁̌ ↠ 𝒫(ω)` (`ForcingCH.lean`'s `π_af`) well-orders the check reals; `A_r = {s : |s| ≤ |r|+1, s ≺ r}` where `s ≺ r` means the least generic preimage of `s` precedes that of `r` (`Aname`, `Aset`); `isFun_Aname`, `bounded_Aset`, `outerMeasureLtOne_Aset` (each `A_r` is countable, covered by intervals of total length `≤ 1/2` read from a ground enumeration of the predecessors); the combinatorial descent `no_descent` (no injective `ℕ → Ordinal` with `v : ℕ → ℝ≥0` where a larger ordinal forces `v` to drop by `>1`) and `no_infinite_independent` (via ω-closed refinement to a nonzero piece deciding an injective sequence in `X` with its least preimages, then independence + the descent); hence `erdos501_eq_bot`, `neg_erdos501_forced_collapse`, `Erdos501_f_unprovable`, **`independence_of_Erdos501`**. **Proved.** |
| `RandomForcing.lean` | **The proof begins**: unit (F4), Theorems 4.1 (countable support / Borel reading of names for reals) and 4.2 (factorization), and unit (F5), Theorem 4.5 (the isolated fresh-coordinate forcing argument), proved for the random algebra `randomAlgebra ι` of an arbitrary index type; see below. |
| `DeltaSystem.lean` | Unit (F3), Theorem 4.3: the Δ-system lemma for `𝔠⁺` countable sets, **proved** (Zorn + a closure chain of length `ω₁`), in the form consumed by Prop. 4.4. |
| `HomogeneousReading.lean` | Unit (F4), Prop. 4.4: the homogeneous Borel reading of `𝔠⁺` names, proved from Theorems 4.1, 4.3 and the count "at most `𝔠` Borel functions `2^R × 2^ℕ → 2^ω`". |
| `ZFCCore.lean` | The ZFC core: unit (F1), Lemma 2.1 (positive-measure selection, `measure_Q_pos`) and Lemma 2.2, and unit (F2), Definition 3.1 as the structure `Certificate` and Theorem 3.2 (certificate ⇒ infinite independent set, `exists_infinite_independent_of_certificate`), all **proved** in Mathlib measure theory; also the ground-model form of the decomposition (1.1) (`erdos501_deepmind_of_certificate`) and the (P2) computation for the profile test points (`map_profileTest`). |
| `BinaryExpansion.lean` | Step S1 of `PLAN.md`: binary expansion `binExp : 2^ω → [0,1]` pushes the coin measure forward to Lebesgue measure on `[0, 1)` (`map_binExp`), hence (P2) for the profile test points `z ↦ m + binExp (z 0)` unconditionally (`map_profileTest_binExp`). **Proved.** |
| `Semantics.lean` | **The Boolean value of `Erdos501_f` in `V 𝔹`, computed**: `realize_Erdos501_f : ⟦Erdos501_f⟧[V β] = Sem.erdos501`, where `Sem.erdos501 = ⨅ R plus times lt zero one, Sem.completeOrderedField … ⟹ Sem.erdosProperty …` and the `Sem.*` are Boolean-valued predicates on names mirroring the blocks of `Sentence.lean` (`Sem.isFun`, `Sem.isOp2`, the twenty axioms `Sem.assoc`, …, `Sem.complete`, `Sem.bounded`, `Sem.outerMeasureLtOne`, `Sem.infinite`, `Sem.independent`); `forced_Erdos501_f_iff : (Γ ⊩[V β] Erdos501_f) ↔ ∀ R …, Γ ⊓ Sem.completeOrderedField R … ≤ Sem.erdosProperty R …`.  From here on the proof lives entirely at the level of names. **Proved** (a mechanical `simp` computation, any `β`). |
| `InternalReals.lean` | Step S2 of `PLAN.md`: **the internal reals of `V (randomAlgebra ι)`**.  Names `realName f = mkReal (code ∘ f)` for measurable `f : Ω ι → ℝ` (cut codes), `bv_eq_realName : ‖realName f = realName g‖ = [{x | f x = g x}]`, the names `Rdot`, `plusDot`, `timesDot`, `ltDot`, `zeroDot`, `oneDot`, evaluation of `Sem.app2`/`Sem.lt`/`Sem.le`/`∈ᴮ Rdot` on them, and the **theorem `completeOrderedField_Rdot : ⊤ ≤ Sem.completeOrderedField Rdot plusDot timesDot ltDot zeroDot oneDot`** (all twenty axioms, including Dedekind completeness `complete_Rdot`, whose supremum is read off from the events `‖∃ s ∈ S, qₙ < s‖`). **Proved.** |
| `RealReading.lean` | Step S3 of `PLAN.md`: **reading internal reals, sequences and covers as ground Borel data**.  Every internal real is canonical (`realName_of_mem_Rdot`: `Γ ≤ y ∈ᴮ Rdot → ∃ g, Γ ≤ y =ᴮ realName g`, via a Γ-version of Theorem 4.1 and decoding of cut codes), internal sequences `ω → Rdot` are sequences of readings (`exists_seq_of_isFun`), the maximum principle for the witnesses of `Sem.outerMeasureLtOne` (`outerMeasureLtOne_elim`, using that realizations of formulas are extensional, `B_ext_realize`), names `openName a b` of open sets `⋃ₙ (aₙ, bₙ)`, and the **reading theorem `outerMeasureLtOne_reading`**: from `Γ ≤ Sem.outerMeasureLtOne Rdot … S` get `a b : ℕ → MeasReal ι` with `S ⊆ᴮ openName a b` and, on `Γ`, nondegenerate intervals of total length `< 1` (`coverEvent`); hence `λ(⋃ₙ (aₙ x, bₙ x)) < 1` (`volume_iUnion_Ioo_lt_one`). **Proved.** |
| `Envelopes.lean` | Step S4 of `PLAN.md`: **the homogeneous envelopes** (5.4)–(5.8).  Extensionality for subsets of `Rdot` in context, the value `valSet A x` of a function name `A : Rdot → 𝒫(Rdot)` (`app_valSet`), the coding of families `ℤ → ℕ → ℝ × ℝ` as subsets of `ω` (`encodeFam`/`decodeFam`), the profile test points `testPoint m α = m + binExp (ĝ α)`, and **`exists_homogeneous_envelopes`**: for a function name `A` all of whose values have internal outer measure `< 1` and `𝔠⁺` coordinates `d a`, there are `J` (`#J = 𝔠⁺`), a countable root `R`, pairwise disjoint petals `π a` with `π a 0 = d a`, and one Borel `E : 2^R × 2^ℕ → (ℤ → ℕ → ℝ × ℝ)` such that on `Γ`, for all `a ∈ J`, `m`: `A(testPoint m (d a)) ⊆ᴮ openName (envA E (π a) m) (envB E (π a) m)` and the cover event holds (measure `< 1`), the endpoints being read from `(ĝ↾R, ĝ ∘ π a)` only. **Proved.** |
| `Selection.lean` | Towards step S6: every supremum in the measure algebra is a countable supremum (`exists_countable_iSup_eq`, from the essential unions of `MeasureAlgebra.lean`), the measurable "first index" of a countable cover (`firstIndex`), and **measurable selection from fullness** (`exists_seq_of_fullness`, `exists_selection_of_fullness`): for a Borel `B'` of profiles read from a countable `T` and uncountably many pairwise disjoint petals, a sequence `a k ∈ J` and a measurable selector `sel` with `(ĝ↾T, ĝ ∘ π (a (sel ĝ))) ∈ B'` a.e. on `{ν(B'_{ĝ↾T}) > 0}`. **Proved.** |
| `Recursion.lean` | Step S6 of `PLAN.md`, part 1: **the recursion of Theorem 3.2, run in the ground model pointwise in the generic point** ("function form").  The σ-finite space `S = ℤ × 2^P` with `μS = counting ⊗ ν`, the test map `xx (m, z) = m + binExp (z 0)` (pushing `μS` forward to Lebesgue measure, `μS_preimage_xx`), the truncated envelopes `envSet E t s` (empty off the cover event), the relation `Erel E ⊆ 2^R × (S × S)` and its section `ErelX E ĝ` (horizontal sections of measure `≤ 1`, `μS_section_ErelX_le_one`), the positive-measure set `QX E C ĝ = Q μS (ErelX E ĝ) (C ĝ)` of Lemma 2.1 (`QX_pos`), one stage of the recursion as a measurable choice of countable range from fullness (`exists_stage_selection`), the stages `stage j` (removing `removedX E ĝ t_j` at each step) and the chosen points `tj j ĝ`, with `ae_good` (a.e. every stage has infinite measure and `t_j ∈ QX`) and `tj_not_mem_removedX` (`t_j ∉ removedX (t_i)` for `i < j`). **Proved.** |
| `Assembly.lean` | Step S6, part 2: **the name of the infinite independent set and Theorem 3.2 in `V (randomAlgebra ι)`**.  From the candidates `cand j k` and measurable selectors `sel j` of the recursion, the name `Xname = {testPoint (cand j k).1 (d (cand j k).2) | j, k}` with `‖(j,k)-th element ∈ X‖ = [sel j = k]`, and the name `fname` of `j ↦ x_j`; `infinite_Xname` (`ω` injects into `Xname` via `fname`), `independent_Xname` (for `x ≠ y` in `Xname`, `x ∉ A(y)`: on the piece where `(m, a)` is chosen at stage `i` and `(m', a')` at stage `j ≠ i`, the recursion gives `xx (t_i) ∉ envSet E (ĝ↾R) t_j`, and the homogeneous envelope of `A(testPoint m' (d a'))` is exactly `envSet E (ĝ↾R) t_j` on the cover event, so `x_i ∉ A(x_j)`), the packaging `exists_infinite_independent_name`, and **`erdosProperty_Rdot : 𝔠⁺ ≤ #ι → ⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot`** (with `completeOrderedField_and_erdosProperty_Rdot`: `Rdot` is a complete ordered field with the Erdős property in `V (randomAlgebra ι)`). **Proved.** |
| `InternalIso.lean` | Unit (F8), part 2: **the internal isomorphism `F ≅ Rdot`**.  For an internal complete ordered field `F` on `Γ` and a name `r ∈ F.R`, the **reading** `rd F r x = sup {m/2^k | x ∈ ‖dyR m k < r‖}` (measurable representatives `cutSet` of the Boolean values of the dyadic comparisons); on the good event `cutGood` the reading has exactly that cut (`mem_iff_lt_dyReal`), giving the **reading lemma** `Γ ⊓ ‖dyR d < r‖ = Γ ⊓ [dyVal d < rd F r]` (`lt_dyR_le_mk_rd`, `mk_rd_le_lt_dyR`).  The name `psi F = {(r, realName (rd F r)) | r ∈ F.R}` is a function `F.R → Rdot` (`psi_isFun`, `app_psi_of`, `eq_of_app_psi`), preserves and reflects `<` (`rd_lt_of_lt`, `lt_of_rd_lt`), is injective (`eq_of_rd_eq`), additive (`rd_add`: `x + y = z` gives `rd z = rd x + rd y` a.e., by comparing dyadic cuts), sends `zero, one` to `0, 1` (`rd_zero`, `rd_one`), and is surjective (`psi_surj`: the internal completeness of `F` applied to the cut set `cutName F g` of a real name `g`). **Proved** (1130 lines). |
| `PLAN.md` | Design of the remaining units (F6) Theorem 5.1 and the transfer (F7): the internal objects still to be built and size estimates. |
| `BorelNames.lean` | **Names for Borel sets** of reals (`borelName`) and of profiles (`borelNameP`) in `V (randomAlgebra ι)`, the profile names `profileName`/`profilesName`, the evaluation lemmas `‖mkReal G ∈ Ḃ‖ = [{x | (x↾T, G x) ∈ B}]`, `‖ż ∈ Ḃ‖ = [{x | (x↾T, ĝ ∘ π) ∈ B'}]`, and unit (F5), Theorem 4.5, **with names**: `‖ν(Ḃ) > ε‖ ≤ ‖Ḃ ∩ Ż ≠ ∅‖` (`fullness`). All proved. |
| `../../validation/Erdos501Audit.lean` | `#print axioms` of everything (`Erdos501_f` and `𝔹_col_random` use no `sorry`; only the assertion and its corollary depend on `sorryAx`), shape checks, and the size of the printed sentence. |
| `../../validation/Erdos501Print.lean` | Pretty-prints every building block of `Erdos501_f` (`str_formula`), for auditing the sentence by eye. |

## How the DeepMind proposition is rendered (`Erdos501_f`)

`Erdos501_f` is the `L_ZFC`-sentence

    ∀ R plus times lt zero one, CompleteOrderedField(R, plus, times, lt, zero, one) →
      ∀ A, (A : R → 𝒫(R)) →
        (∀ x ∈ R, Bounded(A(x)) ∧ OuterMeasureLtOne(A(x))) →
        ∃ X ∈ 𝒫(R), Infinite(X) ∧ Independent(A, X)

with

* `CompleteOrderedField`: `plus`, `times` are binary operations on `R` (sets of triples
  `((x, y), z)`), `zero, one ∈ R`, the ordered-field axioms for `<` (a set of pairs), and Dedekind
  completeness.  Quantifying over *all* complete ordered fields avoids constructing `ℝ` inside
  first-order set theory; `ZFC` proves that they are all isomorphic and the property is invariant
  under isomorphism, so this is `ZFC`-equivalent to the property of "the" reals.
* `Bounded(S)`: `∃ m₁ m₂ ∈ R, ∀ y ∈ S, m₁ < y < m₂` (= `Bornology.IsBounded` in `ℝ`).
* `OuterMeasureLtOne(S)`: there are `a, b : ω → R` with `aₙ < bₙ` whose open intervals cover
  `S`, and partial sums `s : ω → R` (`s 0 = 0`, `s (n+1) + aₙ = s n + bₙ`) with `s n ≤ r` for
  all `n`, for some `r < 1` (= Lebesgue outer measure `< 1`).
* `Infinite(X)`: `ω` injects into `X` (= `X.Infinite`, using choice).
* `Independent(A, X)`: `∀ x y ∈ X, x ≠ y → x ∉ A(y)` (= `X.Pairwise (fun x y => x ∉ A y)`).

That this rendering is faithful is a **theorem**: `stdStructure_realize_Erdos501_f_iff` (`Bridge.lean`)
states that in the standard structure `stdStructure` (Mathlib's `ZFSet` with `∈`), `Erdos501_f` holds
iff `erdos501_deepmind` (the DeepMind proposition, verbatim) holds.

## The forcing notion `𝔹_col_random`

`𝔹_col_random := RO(𝔹_collapse⁺ × (randomAlgebra RandomIndex)⁺)`, the Boolean completion of
the product poset of

* `𝔹_collapse` (Flypitch's collapse algebra `Col(ω₁, 𝒫(ω)) ≅ Col(ω₁, ℝ)`, which forces `CH`), and
* `randomAlgebra RandomIndex`, the measure algebra of the fair-coin product measure on
  `2^(RandomIndex × ω)` with `#RandomIndex = 𝔠⁺` (`mk_RandomIndex`).

The product is used because, `Col(ω₁, ℝ)` being σ-closed, the `ω₂`-random algebra *of the
collapse extension* (`ω₂^{V[G]} = (𝔠⁺)^V`) is the check name of the ground-model measure algebra
with `𝔠⁺` coordinates, so the two-step iteration is (densely) this product; see the module
docstring of `ColRandom.lean`.  This identification is a theorem about `Col(ω₁, ℝ)` that is built
into the *definition* of `𝔹_col_random`; stating the assertion literally with an iteration would
require a formalization of two-step iterations `𝔹 ∗ Ċ` with names for Boolean algebras inside
`V 𝔹`, which Flypitch does not have.

## The proof: units (F3)–(F5) of the paper's plan

The rev10 paper separates the proof into the units (F1) Theorems 2.1–2.2 (σ-finite measure theory
in ZFC), (F2) Theorems 3.1–3.2 (the forcing-free certificate-to-independent-set theorem), (F3)
Theorem 4.3 (`ZFC + CH` combinatorics), (F4) Theorems 4.1, 4.2, 4.4 (countable support and
homogeneous Borel reading), (F5) Theorem 4.5 (the isolated fresh-coordinate forcing argument), and
(F6) Theorem 5.1 (assembly of the forcing data into the certificate interface).  Only (F4)–(F6)
mention forcing.  Status here:

| Unit | Content | File | Status |
|---|---|---|---|
| (F1) | Lemmas 2.1, 2.2, positive-measure selection | `ZFCCore.lean` | **proved** |
| (F2) | Def. 3.1 certificate interface; Thm 3.2 certificate ⇒ independent set | `ZFCCore.lean` | **proved** |
| (F3) | Thm 4.3, Δ-system lemma for `𝔠⁺` countable sets | `DeltaSystem.lean` | **proved** |
| (F4) | Thm 4.1, countable support + Borel reading | `RandomForcing.lean` | **proved** |
| (F4) | Thm 4.2, factorization `𝔹(T ⊔ P) = 𝔹(T) ⊗ 𝔹(P)` | `RandomForcing.lean` | **proved** |
| (F4) | Prop 4.4, homogeneous reading | `HomogeneousReading.lean` | **proved** |
| (F5) | Thm 4.5, fresh-coordinate argument | `RandomForcing.lean`, `BorelNames.lean` | **proved**, both at the level of Boolean values of events and **with names** for the Borel set `Ḃ` and the profiles `Ż` (`fullness : ‖ν(Ḃ) > ε‖ ≤ ‖Ḃ ∩ Ż ≠ ∅‖`) |
| (F6)+(F7) | Thm 5.1 and the transfer of Thm 3.2 into the model, for the internal reals `Rdot` | `Semantics.lean`, `InternalReals.lean`, `RealReading.lean`, `Envelopes.lean`, `Selection.lean`, `Recursion.lean`, `Assembly.lean` | **proved**: `erdosProperty_Rdot : 𝔠⁺ ≤ #ι → ⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot` — the target `⊤ ⊩ Erdos501_f` is unfolded into predicates on names (`forced_Erdos501_f_iff`), the internal reals `Rdot` are a complete ordered field (S2), the internal outer-measure hypothesis is read as a ground-model open cover of measure `< 1` (S3), the envelopes are read homogeneously from root and petals (S4), and the recursion of Theorem 3.2 is run on names (S6, `Recursion.lean`, `Assembly.lean`); hence the existential sentence is forced (`erdos501_ex_forced`, `Main.lean`) |
| (F8) | internal uniqueness of complete ordered fields (not in the paper's list; absorbed there in "the reals") | `InternalField.lean`, `InternalIso.lean`, `Transfer.lean` | **proved**: every internal complete ordered field `F` is isomorphic to `Rdot` by `psi F` (dyadic cuts, Archimedean property, density; readings; order, additivity, surjectivity), and the Erdős property transports along `psi` (`erdosProperty_of_COF`); hence the universal sentence is forced (`erdos501_forced`) |

Setting: `Ω ι = ι → 2^ω` with the fair-coin product measure `μ_random ι` and measure algebra
`randomAlgebra ι` (`RandomAlgebra.lean`); the generic point is `ĝ`, the profile/random real at
the coordinate `α` is `ĝ α ∈ 2^ω`; a coordinate block `P_α` of the paper is a single coordinate or
a *petal* `π : ℕ ↪ ι` here; `2^T = T → 2^ω` with product measure `μ_T` for a set of coordinates
`T`.  In the two-step forcing of `ColRandom.lean` the random algebra has `𝔠⁺` coordinates
(`ω₂` of the collapse extension), so wherever the paper uses `CH` to count Borel codes (`ℵ₁ < ℵ₂`)
we use `𝔠 < 𝔠⁺` (`𝔠^{ℵ₀} = 𝔠`, a theorem of `ZFC`).

* **(F4) Theorem 4.1 — Borel reading of names for reals.**  `mkReal F hF` is the name of
  `{n ∈ ω | F(ĝ) n = 1}` for a measurable `F : Ω ι → 2^ω` (`mem_mkReal : ‖n ∈ mkReal F hF‖ =
  [{x | F x n = 1}]`), `genericReal α = mkReal (· α)`.  Theorem `exists_mkReal_restrict_bv_eq`:
  **every** name `ẋ` with `⊤ ≤ ẋ ⊆ᴮ ω` is forced equal to `mkReal (F ∘ (·↾S))` for a countable
  `S ⊆ ι` and a Borel `F : 2^S → 2^ω`.  Ingredients: `exists_countable_support` (measurable sets
  depend on countably many coordinates) and the extensionality principle
  `eq_of_forall_of_nat_mem_eq` (proved for any nontrivial complete Boolean algebra).
* **(F4) Theorem 4.2 — factorization.**  `indepFun_restrict_restrict`: for disjoint `T, P` the
  restrictions `x↾T` and `x↾P` are independent (`𝔹(T ⊔ P) = 𝔹(T) ⊗ 𝔹(P)`);
  `map_restrict_prod_restrict` (joint law = product of the fair-coin marginals) and
  `μ_random_restrict_prod_restrict` (the pull-back along `x ↦ (x↾T, x↾P)` is measure preserving);
  the same for a coordinate `α ∉ T` and for a petal `π : ℕ ↪ ι` avoiding `T`
  (`map_comp_injective`, `indepFun_restrict_comp`, `map_restrict_prod_comp`), and Fubini
  `measure_restrict_prod_of_map : μ_random {x | (x↾T, Z x) ∈ B} = ∫⁻ t, ν(B_t) ∂μ_T` whenever
  the joint law of `(x↾T, Z x)` is `μ_T ⊗ ν`.
* **(F4) Prop. 4.4 — homogeneous reading** (`homogeneous_reading`).  Given `𝔠⁺` names `ẋ_a`
  (`a : A`, `#A = 𝔠⁺`) for subsets of `ω`, an injective choice `d : A → ι` of profile coordinates
  and a countable `R₀` (support of a condition), there are `J ⊆ A` with `#J = 𝔠⁺`, a countable
  root `R ⊇ R₀`, pairwise disjoint petals `π a : ℕ ↪ ι` (`a ∈ J`) avoiding `R` with `π a 0 = d a`
  (the paper's `π_α : P → P_α`, `π_α[D] = D_α`), and a **single** Borel `F : 2^R × 2^ℕ → 2^ω` with
  `⊤ ≤ ẋ_a =ᴮ mkReal (fun ĝ => F (ĝ↾R, ĝ ∘ π a))` for all `a ∈ J`.  Proof: Theorem 4.1 for each
  name; pad each support with a private countably infinite set (an injection `A × ℕ ↪ ι`, which
  exists since `#A ≤ #ι`), so that all petals are countably infinite; the Δ-system lemma (F3);
  discard the countably many indices whose profile coordinate or padding meets the root; enumerate
  each petal by `ℕ` with `d a` first; glue the readings to the common domain `2^R × 2^ℕ`; and
  pigeonhole (`Cardinal.infinite_pigeonhole_set`, `𝔠⁺` regular) over the at most `𝔠` Borel
  functions `2^R × 2^ℕ → 2^ω` (`card_measurable_le_continuum`, from Mathlib's
  `MeasurableSpace.cardinal_measurableSet_le_continuum` and the standard-Borel instances).
* **(F5) Theorem 4.5 — the fresh-coordinate argument.**  `bot_lt_inf_mk_of_fiber_pos(_comp)`:
  if `q = [{x | x↾T ∈ Q}] ≠ ⊥` and the fibres `B_t`, `t ∈ Q`, of a Borel `B ⊆ 2^T × 2^P` have
  measure `≥ ε > 0` (a.s. — the form given by "`q ⊩ ν(Ḃ) > ε`"), then
  `q ⊓ [{x | (x↾T, ĝ ∘ π) ∈ B}] ≠ ⊥` for every coordinate/petal avoiding `T` (its measure is
  `≥ ε · μ_T(Q)`, `measure_pos_of_fiber_pos_of_map`); `exists_fresh_petal_of_fiber_pos`: among
  uncountably many pairwise disjoint petals (the output of Prop. 4.4) some petal is fresh over the
  countable support `T`, and for it the above holds — no condition can force all the profiles
  `ż_a = ĝ ∘ π a` to avoid a set of positive measure coded from its support.  This is Lemma 4.5's
  computation; its literal form `⊩ ν*(Ż) = 1` needs names for Borel sets (below).

* **Names for Borel sets (`BorelNames.lean`).**  Every name for a real is forced equal to a
  canonical name `mkReal F` (Theorem 4.1), and two canonical names are equal exactly on the event
  where the readings agree: `bv_eq_mkReal : ‖mkReal G = mkReal F‖ = [{x | G x = F x}]`.  The name
  `borelName T B` of the Borel set of reals `{r | (ĝ↾T, r) ∈ B}` read from a Borel `B ⊆ 2^T × 2^ω`
  is the `bSet` whose elements are the canonical names `mkReal F` of all reals, with
  `‖mkReal F ∈ Ḃ‖ := [{x | (x↾T, F x) ∈ B}]`; then `mem_borelName_mkReal :
  ‖mkReal G ∈ Ḃ‖ = [{x | (x↾T, G x) ∈ B}]` for every canonical name, `mem_borelName` for every
  name of a real, and `mem_borelName_le_subset_omega` (`Ḃ` is a set of reals).  Profiles
  `z ∈ 2^P = ℕ → 2^ω` are coded as reals (`codeP`); `profileName π` is the name of the profile
  `ż = ĝ ∘ π` of a petal, `profilesName J π` the name of `Ż = {ż_a | a ∈ J}`, `borelNameP T B'` the
  name of the Borel set of profiles read from `B' ⊆ 2^T × 2^P`, and
  `mem_borelNameP_profileName : ‖ż ∈ Ḃ‖ = [{x | (x↾T, ĝ ∘ π) ∈ B'}]` — the identification used
  in the proof of Lemma 4.5.  `iSup_mem_profilesName : ‖∃ z ∈ Ż, z ∈ Ḃ‖ = ⨆ a ∈ J, ‖ż_a ∈ Ḃ‖`.
* **(F5) Theorem 4.5 with names** (`fullness`).  `measGtP T hB' ε` is the Boolean value of
  "`ν(Ḃ) > ε`" for `Ḃ = borelNameP T B'` (the class of `{x | ε < ν(B'_{x↾T})}` — what
  "`q ⊩ ν(Ḃ) > ε`" unpacks to in the measure-algebra model); for uncountably many pairwise disjoint
  petals `(π a)_{a ∈ J}`, every countable `T`, Borel `B'` and `ε > 0`:
  `‖ν(Ḃ) > ε‖ ≤ ⨆ a ∈ J, ‖ż_a ∈ Ḃ‖ = ‖Ḃ ∩ Ż ≠ ∅‖`, i.e. `⊩ (ν(Ḃ) > ε → Ḃ ∩ Ż ≠ ∅)`.  Proof: if not,
  `q := ‖ν(Ḃ) > ε‖ ⊓ ‖Ḃ ∩ Ż = ∅‖ ≠ ⊥`; write `q` as a `T'`-event for a countable `T' ⊇ T`
  (`exists_countable_restrict_preimage`), transport "`ν(B'_{x↾T}) > ε` a.e. on `[q]`" to the trace
  (`ae_map_iff`), and apply the fresh-petal lemma to get `a ∈ J` with `q ⊓ ‖ż_a ∈ Ḃ‖ ≠ ⊥`,
  contradicting `q ≤ ‖ż_a ∈ Ḃ‖ᶜ`.  Since every name for a Borel set of profiles is of the form
  `borelNameP T B'` for a countable `T` (Borel reading of its code — not formalized), this is
  `⊩ ν*(Ż) = 1`.

* **(F1) Lemma 2.1 — positive-measure selection** (`measure_Q_pos`, `ZFCCore.lean`): for a
  σ-finite `μ` on `S`, a measurable `E ⊆ S × S` whose horizontal sections `E^s` have measure `≤ K < ∞`,
  and a measurable `C` with `μ C = ∞`, the set `Q(C) = {t ∈ C | μ(C \ E_t) = ∞}` (measurable,
  `measurableSet_Q`) has positive measure.  Proof by double counting on `E ∩ (D_k × C')` via
  `Measure.prod_apply`/`prod_apply_symm` for `(μ.restrict D_k).prod μ`, exactly as in the paper.
  **Lemma 2.2** (`measure_diff_eq_top_of_mem_Q`): for `t ∈ Q(C)`, `μ(C \ (E_t ∪ F ∪ N)) = ∞` when
  `μ F < ∞` and `μ N = 0`.
* **(F2) Definition 3.1** (`Certificate A Ω`): `ν` probability measure on `Ω`, `Z ⊆ Ω` meeting every
  Borel set of positive measure (`ν*(Z) = 1`), measurable `x m : Ω → ℝ` with law `λ↾[m, m+1)` (P2),
  jointly measurable envelopes `U m : Ω → Set ℝ` with `λ(U m z) < 1` (P3) and `A (x m z) ⊆ U m z` for
  `z ∈ Z` (P4) — envelopes replace the paper's Borel codes `c_m` (their only use is the joint
  measurability).  **Theorem 3.2** (`exists_infinite_independent_of_certificate`): a certificate
  yields an infinite independent set.  Proof: on `S = ℤ × Ω` with `μ = counting ⊗ ν` (σ-finite),
  `μ(xx⁻¹ B) = λ B` for the joint test map `xx (m, z) = x m z` (P2 and `tsum_volume_inter_Ico`), so
  the Borel relation `E = {(t, s) | xx t ∈ U s}` has horizontal sections of measure `λ(U s) < 1` (P3)
  and `xx` has null fibres; the recursion picks `t_j = (m_j, z_j) ∈ Q(C_j)` with `z_j ∈ Z` (Lemma 2.1
  gives `μ(Q(C_j)) > 0`, so some `ν`-section of `Q(C_j)` is positive, and (3.1) gives `z_j`) and
  removes the two sections through `t_j` and the fibre of `xx t_j` (Lemma 2.2); `X = {xx t_j}` is
  infinite and independent by (P4).
* **(F3) Theorem 4.3 — the Δ-system lemma** (`delta_system_countable`, `DeltaSystem.lean`): every
  family of `𝔠⁺` countable sets has a Δ-subsystem of size `𝔠⁺` (`𝔠^{ℵ₀} = 𝔠 < 𝔠⁺` replaces the
  paper's `CH`).  Proof: call a family *disjoint outside* `Y` if the sets `S a \ Y` are pairwise
  disjoint; if such a family over a small `Y` (`#Y ≤ 𝔠`) has size `𝔠⁺`, the pigeonhole principle on
  the `≤ 𝔠` traces `S a ∩ Y` gives the Δ-system (`exists_delta_of_disjOutside`); otherwise take
  maximal such families (Zorn, `exists_maximal_fam`), whose union with `Y` every `S a ⊄ Y` must
  meet (`meets_of_maximal`), and iterate `ω₁` times (`chain`, a well-founded recursion on
  `(ℵ₁).ord.ToType`); a set not contained in the union `X_∞` (which exists, else `𝔠⁺` sets lie in a
  small set) has countable trace on `X_∞`, hence inside some stage, and cannot meet the next stage
  — contradiction (`chain_contradiction`).

* **(P2) for the profile test points** (`BinaryExpansion.lean`): `binExp f = ∑ f n 2^{-(n+1)}`;
  `binExp f = (f 0)/2 + binExp (shift f)/2`, the first coordinate and the shift are independent
  under the coin measure and the shift is measure preserving (`map_zero_shift`), so the distribution
  function `F t = cantorMeasure {f | binExp f ≤ t}` satisfies `F t = ½F(2t−1) + ½F(2t)`, whence
  `F(k/2ⁿ) = k/2ⁿ` and `F t = t` on `[0,1)`; `Measure.ext_of_Iic` gives
  `map_binExp : cantorMeasure.map binExp = volume.restrict (Ico 0 1)`, and `map_profileTest_binExp`:
  `z ↦ m + binExp (z 0)` on `2^P` has law Lebesgue on `[m, m+1)`.

* **The Boolean value of `Erdos501_f`** (`Semantics.lean`).  `boolean_realize_bounded_formula`
  is recursion on the syntax; unfolding the depth-polymorphic combinators of `Sentence.lean` at
  depth `0`, evaluating the de Bruijn indices (`DVec.nth`) and comparing with the definitions of the
  `Sem.*` predicates gives `realize_Erdos501_f : ⟦Erdos501_f⟧[V β] = Sem.erdos501` — a `simp only`
  computation.  The predicates `Sem.*` are the exact Boolean-valued counterparts of the blocks of
  the sentence (e.g. `Sem.app2 op x y z = pair (pair x y) z ∈ᴮ op`, `Sem.lt lt x y = pair x y ∈ᴮ lt`,
  `Sem.independent A X = ⨅ x, x ∈ᴮ X ⟹ ⨅ y, y ∈ᴮ X ⟹ ((x =ᴮ y)ᶜ ⟹ ⨅ Ay, app A y Ay ⟹ (x ∈ᴮ Ay)ᶜ)`).
  Consequence (`forced_Erdos501_f_iff`): `Γ ⊩[V β] Erdos501_f` iff for all names
  `R plus times lt zero one`, `Γ ⊓ Sem.completeOrderedField R plus times lt zero one ≤
  Sem.erdosProperty R plus lt zero one`.
* **The internal reals** (`InternalReals.lean`, step S2).  A real of the extension is read from the
  generic point by a measurable `f : Ω ι → ℝ`; its name is `realName f = mkReal (code ∘ f)`, the
  canonical name of its cut code (`code r n = [ratEnum n < r]`, injective), so that
  `bv_eq_realName : ‖realName f = realName g‖ = [{x | f x = g x}]`.  `Rdot` has all `realName f` as
  elements (`mem_Rdot : ‖x ∈ Rdot‖ = ⨆ f, ‖x = realName f‖`), `ltDot` is the set of pairs
  `(realName f, realName g)` with value `[{x | f x < g x}]`, `plusDot`/`timesDot` are the graphs
  `((realName f, realName g), realName (f + g))`, resp. `f * g` (`opDot`), `zeroDot`, `oneDot` the
  constants.  Evaluation: `app2_opDot : ‖op(x, y) = z‖ = ⨆ f g, ‖x = realName f‖ ⊓ ‖y = realName g‖ ⊓
  ‖z = realName (op ∘ (f, g))‖`, `lt_ltDot`, `le_ltDot_realName : ‖realName f ≤ realName g‖ =
  [{x | f x ≤ g x}]`.  With introduction/elimination rules in the style of natural deduction on
  Boolean values (`mem_Rdot_elim`, `app2_opDot_elim`, `lt_ltDot_elim`, `eq_realName_trans`,
  `eq_realName_of_eq`, …) each axiom of a complete ordered field reduces to the pointwise fact about
  `ℝ` (`assoc_opDot`, `comm_opDot`, `ident_opDot`, `addInv_plusDot`, `mulInv_timesDot`,
  `distrib_Rdot`, `irrefl_ltDot`, `trans_ltDot`, `total_ltDot`, `addCompat_Rdot`, `mulPos_Rdot`,
  `isOp2_opDot`, `zeroDot_ne_oneDot`); **Dedekind completeness** (`complete_Rdot`): for a name `S`
  of a nonempty bounded-above set of reals, let `A n` represent `‖∃ s ∈ S, qₙ < s‖`; the supremum is
  `realName (cutReal A)`, `cutReal A x = sup {qₙ | x ∈ A n}` (a measurable `EReal`-supremum made
  real), and the two defining properties are checked pointwise on the event where the cut is
  nonempty and bounded (`goodEvent`).  Result: `completeOrderedField_Rdot`.  Hence
  (`erdosProperty_Rdot_of_forced`) `⊤ ⊩ Erdos501_f` implies `⊤ ≤ Sem.erdosProperty Rdot plusDot
  ltDot zeroDot oneDot`; the converse direction — the actual target — needs the Erdős property for
  `Rdot` (S3–S6) **and** the internal uniqueness of complete ordered fields, unit (F8) of `PLAN.md`.

* **Reading internal data** (`RealReading.lean`, step S3).  A Γ-version of extensionality for
  subsets of `ω` (`eq_of_forall_of_nat_mem_eq'`) and of Theorem 4.1 (`exists_mkReal_of_subset_omega :
  ‖y ⊆ ω‖ ≤ ‖y = mkReal G‖`, the reading `G` being built bit by bit from representatives of
  `‖n ∈ y‖`, so no mixing is needed), together with the decoding of cut codes (`decode`,
  `decode_code`), give **`realName_of_mem_Rdot`**: `Γ ≤ y ∈ᴮ Rdot → ∃ g, Γ ≤ y =ᴮ realName g`.
  For a function name `F` with `Γ ≤ Sem.isFun ω Rdot F`, the value at `ň` is the name `valName F ň`
  of the union of all values (`app_valName`), a real, whence sequences of readings
  (`exists_seq_of_isFun`).  Every `Sem.*` predicate is the realization of a formula, and
  realizations are extensional (`B_ext_realize`, from `boolean_realize_bounded_formula_congr`),
  so Flypitch's `maximum_principle` applies to the witnesses `a, b, s` of `Sem.outerMeasureLtOne`
  (`outerMeasureLtOne_elim`; the realize lemmas `realize_omBody₁₋₃` are again `simp`
  computations).  Unfolding the eight clauses of `Sem.omBody` for the readings `aₙ, bₙ, sₙ`
  (`succ_of_nat`, `of_nat_zero_eq` for the internal recursion `s 0 = 0`,
  `s (n+1) + aₙ = s n + bₙ`) yields **`outerMeasureLtOne_reading`**: on `Γ`, `aₙ < bₙ`, the partial
  sums `∑_{n<N} (bₙ - aₙ)` are bounded by `sumBound a b < 1` (`coverEvent`), and
  `S ⊆ᴮ openName a b`, the name of the open set `⋃ₙ (aₙ(ĝ), bₙ(ĝ))` of the extension
  (`mem_openName_realName : ‖realName g ∈ openName a b‖ = [{x | ∃ n, aₙ x < g x < bₙ x}]`); in the
  ground model, `λ(⋃ₙ (aₙ x, bₙ x)) ≤ sumBound a b x < 1` on the cover event
  (`volume_iUnion_Ioo_lt_one`).  This is exactly the input of the paper's (5.4): for each test
  point, a Borel-read code of an open envelope of `A(x)` of measure `< 1`.

* **Homogeneous envelopes** (`Envelopes.lean`, step S4).  `valSet A x` is the name of the union of
  all values of `A` at `x` (a subset of `Rdot`); for a function name `A : Rdot → 𝒫(Rdot)` and
  `x ∈ Rdot` it *is* the value (`app_valSet`, by extensionality for subsets of `Rdot` in context,
  `eq_of_forall_realName_mem_eq'`).  For the profile test point `testPoint m α = m + binExp (ĝ α)`,
  S3 gives an open cover `openName aₘₐ bₘₐ` of `A(testPoint m α)` of measure `< 1`; the whole family
  `(aₘₐ, bₘₐ)_{m,n}` is coded as one subset of `ω` (`encodeFam`, inverted by `decodeFam`), and
  `homogeneous_reading` applied to these `𝔠⁺` names gives one Borel `E : 2^R × 2^ℕ → (ℤ → ℕ → ℝ × ℝ)`
  reading them all from the root and the petals: `exists_homogeneous_envelopes`.  The a.e. equality
  of the original and the homogeneous endpoint sequences transports the containment
  (`openName_congr_ae`) and the cover event (`coverEvent_congr`).
* **Measurable selection from fullness** (`Selection.lean`).  In the measure algebra every
  supremum is a countable supremum (`exists_countable_iSup_eq`), so the fullness lemma
  `‖ν(Ḃ) > ε‖ ≤ ⨆ a ∈ J, ‖ż_a ∈ Ḃ‖` yields, for `ε = 1/k`, sequences of petals; diagonalizing,
  `exists_seq_of_fullness : [ν(B'_{ĝ↾T}) > 0] ≤ [⋃ k, (ĝ↾T, ĝ ∘ π (a k)) ∈ B']`, and the measurable
  first-index selector (`firstIndex`, `measurable_find`) gives `exists_selection_of_fullness`.  This is
  one step of the recursion of Theorem 3.2 run on names: the profile chosen at each stage is
  `ż_{a (sel ĝ)}` with `sel` measurable of countable range.
* **The recursion of Theorem 3.2 on names** (`Recursion.lean`, step S6 part 1).  Instead of
  building the certificate interface (Def. 3.1) as internal objects, the recursion of Theorem 3.2 is
  run in the ground model *pointwise in the generic point* `ĝ`, all choices being measurable of
  countable range ("function form", `PLAN.md` §5).  On the σ-finite space `S = ℤ × 2^P` with
  `μS = counting ⊗ ν` (`ν` the coin measure on profiles), the test map `xx (m, z) = m + binExp (z 0)`
  pushes `μS` forward to Lebesgue measure (`μS_preimage_xx`, from `map_binExp`).  The homogeneous
  envelope `E` gives, for a root value `t ∈ 2^R` and `s ∈ S`, the open set
  `envSet E t s = ⋃ₙ (aₙ, bₙ)` (empty off the cover event, so always of measure `< 1`), the
  measurable relation `Erel E = {(t, s, s') | xx s ∈ envSet E t s'}` and its section
  `ErelX E ĝ = Erel E (ĝ↾R)`, whose horizontal sections have `μS`-measure `≤ 1`
  (`μS_section_ErelX_le_one`).  Lemma 2.1 gives the positive-measure set `QX E C ĝ = Q μS (ErelX E ĝ)
  (C ĝ)` (`QX_pos`, for `μS (C ĝ) = ∞`); its sections `{z | (m, z) ∈ QX E C ĝ}` are Borel sets of
  profiles read from a countable `T ⊇ R` (`sectionSet`), so fullness plus measurable selection
  (`Selection.lean`) chooses, measurably and with countable range, a pair `(m, a) ∈ ℤ × J` with
  `(m, ĝ ∘ π a) ∈ QX E C ĝ` a.e. (`exists_stage_selection`).  The stages `stage j` (with `C_{j+1} ĝ =
  C_j ĝ \ removedX E ĝ t_j`, removing the two `E`-sections and the fibre of `xx` at the chosen point
  `t_j = tj j ĝ`, each of measure `≤ 1`, resp. `0`) satisfy a.e. `μS (C_j ĝ) = ∞` and `t_j ∈ QX E C_j ĝ`
  (`ae_good`, by Lemma 2.2 `measure_diff_eq_top_of_mem_Q`), whence `t_j ∉ removedX E ĝ t_i` for `i < j`
  (`tj_not_mem_removedX`): the chosen test reals are pairwise distinct and mutually outside each
  other's envelopes.
* **The name of the independent set** (`Assembly.lean`, step S6 part 2).  With `cand j k ∈ ℤ × D` the
  `k`-th candidate at stage `j` and `sel j : Ω ι → ℕ` the measurable selector,
  `Xname = ⟨ℕ × ℕ, (j, k) ↦ testPoint (cand j k).1 (d (cand j k).2), (j, k) ↦ [sel j = k]⟩` and
  `fname = {(ǰ, x_j)}` is the name of the injection `ω → Xname`.  `infinite_Xname` uses that
  `⨆ₖ [sel j = k] = ⊤` (`iSup_selVal`), that distinct candidates of one stage are never both chosen
  (`selVal_inf_selVal`), and that test points chosen at different stages are forced different
  (`selVal_inf_eq_tp_le_bot`, from `xx_tj_ne`); `independent_Xname` reduces `x ∈ᴮ A(y)` for the
  pieces `(j, k) ≠ (j', k')` to the a.e. statement: on `[sel j = k] ⊓ [sel j' = k']`, `x` reads as
  `xx (t_j ĝ)` (`reading_tp`, using `π a 0 = d a`), `A(y) = valSet A (testPoint m' (d a'))` is contained
  in the homogeneous open envelope (P4), which on the cover event (P3) is exactly `envSet E (ĝ↾R)
  (t_{j'} ĝ)`, contradicting `xx_tj_not_mem_envSet`.  Passing to `𝔠⁺` coordinates
  (`Cardinal.le_mk_iff_exists_set`) and to the subtype `J` of `exists_homogeneous_envelopes` gives
  **`erdosProperty_Rdot`** and `completeOrderedField_and_erdosProperty_Rdot`.

* **The main theorems** (`Main.lean`).  `forced_Erdos501_ex_f_of` (`Semantics.lean`) packages six
  names forming a complete ordered field with the Erdős property into `Γ ⊩ Erdos501_ex_f`; with
  `completeOrderedField_and_erdosProperty_Rdot` this is `erdos501_ex_forced`, and Boolean-valued
  soundness (`unprovable_of_model_neg`) gives `neg_Erdos501_ex_f_unprovable`.  The universal form
  `erdos501_of_random` is `erdos501_forced` (`Transfer.lean`, unit (F8) below) for the index set
  `RandomIndex`, and Boolean-valued soundness gives `neg_Erdos501_f_unprovable`.

* **Internal complete ordered fields** (`InternalField.lean`, (F8) part 1).  For an arbitrary
  internal complete ordered field `F` on `Γ`, the operations are named by the maximum principle
  (`opN`, `Fld.add`, …), the twenty axioms are unfolded into Γ-style rules (`add_app2`,
  `add_unique`, `lt_total`, `add_lt_add_right`, `mul_add`, …), and one derives the ordered abelian
  group theory, `0 < 1`, halving, the internal dyadics and their arithmetic, the **Archimedean
  property** (`arch`: if `{n · ε}` were bounded, its supremum `u` — internal completeness — would
  give the upper bound `u - ε`, a contradiction), the floor (`exists_floor`, by a finite chain of
  totality) and the **density of the dyadics** (`dense`).  This is the internal input for the
  isomorphism `F ≅ Rdot` (part 2, next).

* **The internal isomorphism** (`InternalIso.lean`, (F8) part 2).  The Boolean values
  `‖dyR d < r‖` of the dyadic comparisons with an element `r` of `F` are events; on `Γ` they form a
  Dedekind cut (nonempty and bounded by the Archimedean property, downward closed, without maximum by
  density), so the real `rd F r x` with that cut is well defined a.e. and *the cut of `r` is read
  off from `rd F r`* (reading lemma).  Every property of `psi` then reduces to a statement about
  cuts: order (`dense` twice), injectivity (totality), additivity (`rd_add`: the cut of `x + y` is the
  sumset of the cuts, using `dense` and the internal group laws in one direction and a splitting
  argument in the other, then `exists_dyVal_btwn` in `ℝ`), `zero, one` (`dyR_zero`, `dyR_one_zero`),
  and surjectivity (the internal supremum `u` of the cut set of a real name `g`, whose cut is that of
  `g` by the least-upper-bound property).

* **The transport** (`Transfer.lean`, (F8) part 3).  Given `A : F.R → 𝒫 F.R` with values of internal
  outer measure `< 1`, the transported family `Atr F A = {(psi r, psi[A(r)])}` is a function
  `Rdot → 𝒫 Rdot` (`Atr_isFun`, by surjectivity and injectivity of `psi`), and its values have outer
  measure `< 1` (`Atr_values`): the eight clauses of `Sem.outerMeasureLtOne` for `A(r)` in `F` — the
  covering sequences `a b s : ω → F.R`, `aₙ < bₙ`, the cover, `s₀ = 0`, `s_{n+1} + aₙ = sₙ + bₙ`, the
  bound `ρ < 1` — are read through `psi` (`readings_*`, using order preservation, additivity and
  `0 ↦ 0`, `1 ↦ 1`), and the introduction rule `outerMeasureLtOne_of_readings` rebuilds the eight
  clauses for `Rdot` from these ground readings (with the names `rSeq` of ground sequences, and the
  uniqueness of internal successors `succ_unique`).  Theorem 3.2 in `V^{randomAlgebra ι}`
  (`exists_infinite_independent_of_omlt1`) then gives `X' ⊆ Rdot` infinite and independent for
  `Atr F A`, and the pull-back `Xpb F X' = {r ∈ F.R | psi r ∈ X'}` is infinite (`infinite_Xpb`: the
  injection `ω → X'` is pulled back along `psi`, using surjectivity for totality and injectivity for
  single-valuedness) and independent for `A` (`independent_Xpb`).  Hence `erdosProperty_of_COF` for
  every internal complete ordered field, and `erdos501_forced` by `forced_Erdos501_f_iff`.

**What remains** (see `PLAN.md`; steps S1–S6 and S8 = (F8) are done; both sentences are fully
proved to be forced by `𝔠⁺` random reals, both relative-consistency theorems are `sorry`-free, the
bridge `stdStructure_realize_Erdos501_f_iff` is proved, and **the first question is proved
independent of `ZFC`**, `independence_of_Erdos501`).  Only the paper's literal two-step
forcing `𝔹_col_random` (`erdos501_of_col_random`) is left as `sorry`: it would need the theory of
names in the product `Col × Random` (a σ-closed factor adds no reals, so the reals of the product
extension are those of the random extension); it is not needed for the consistency result and is
not pursued.

## Status

`lake build` succeeds.  The main theorems `erdos501_forced`, `erdos501_of_random`,
`neg_Erdos501_f_unprovable`, `erdos501_ex_forced`, `erdos501_ex_of_random`,
`neg_Erdos501_ex_f_unprovable` (`Main.lean`, `Transfer.lean`) are `sorry`-free, with axioms
`[propext, Classical.choice, Quot.sound]`, and so are all the units (F1)–(F8) behind them —
`ZFCCore.lean`, `DeltaSystem.lean`, `RandomForcing.lean`, `HomogeneousReading.lean`,
`BorelNames.lean`, `BinaryExpansion.lean`, `Semantics.lean`, `InternalReals.lean`,
`RealReading.lean`, `Envelopes.lean`, `Selection.lean`, `Recursion.lean`, `Assembly.lean`,
`InternalField.lean`, `InternalIso.lean`, `Transfer.lean` (`validation/Erdos501Audit.lean`); so is
the bridge `stdStructure_realize_Erdos501_f_iff` (`StdSemantics.lean`, `RealsInZFSet.lean`,
`ZFSetCOF.lean`, `Bridge.lean`); and so is the **independence theorem
`independence_of_Erdos501 : independent ZFC Erdos501_f`** with its ¬CH direction
(`OmegaClosed.lean`, `CheckReals.lean`, `Hechler.lean`).  The only `sorry` in the repository is the
literal assertion `erdos501_of_col_random` about the paper's two-step forcing (off-route; its
corollary is `neg_Erdos501_f_unprovable_of_col_random`).
