# Plan for the remaining units: (F6) Theorem 5.1 and the transfer (F7)

Status (see `README.md`): the units (F1)–(F5) of the paper's plan are formalized and proved, and
so are (F6)+(F7) *for the internal reals `Rdot`* (steps S1–S6 below, `Assembly.lean`:
`erdosProperty_Rdot : 𝔠⁺ ≤ #ι → ⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot`), whence
the **main theorems** of `Main.lean`: `erdos501_ex_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)]
Erdos501_ex_f` and `neg_Erdos501_ex_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_ex_f)` for the existential
sentence, and — by unit (F8), the internal isomorphism of every internal complete ordered field
with `Rdot` and the transport of the Erdős property (§6, `InternalField.lean`, `InternalIso.lean`,
`Transfer.lean`) — `erdos501_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f` and
`neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)` for the universal sentence — all fully proved.
The **¬CH direction** `Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` and the marquee theorem
`independence_of_Erdos501 : independent ZFC Erdos501_f` are proved in `OmegaClosed.lean`,
`CheckReals.lean`, `Hechler.lean` (Hechler's `CH` counterexample in the collapse model; §8).
The paper's two-step forcing `𝔹_col_random` (step S7) is not needed for the consistency result and
is not pursued.  The faithfulness of the rendering is also a theorem: the bridge
`stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind`
(`StdSemantics.lean`, `RealsInZFSet.lean`, `ZFSetCOF.lean`, `Bridge.lean`; §7).  This file records
the design (§§1–2 are the original design notes; §5 describes what was actually done for S4–S6; §6
what was done for (F8); §7 the bridge).

## 1. The shape of the missing argument

`Erdos501_f` (`Sentence.lean`) says: for every complete ordered field `(R, +, ·, <, 0, 1)` and every
`A : R → 𝒫(R)` with bounded values of outer measure `< 1`, there is an infinite independent set.  Its
Boolean value in `V 𝔹` unfolds (Flypitch's `forced_in`) to a statement about *all names*
`Ṙ, +̇, ·̇, <̇, 0̇, 1̇, Ȧ` — so the proof has to work with an arbitrary name `Ṙ` for a complete ordered
field, not with a fixed internal `ℝ`.  Two ways to organize this:

* (a) **Internal transfer** — prove inside `V 𝔹` the internal versions of Definition 3.1 and
  Theorem 3.2 (`ZFCCore.lean`), i.e. redo the ZFC core as Boolean-valued reasoning about names.
  This is the "Boolean-valued measure theory on names" of the rev10 audit's caveat (a).
* (b) **Set-model transfer** — pass to a set model and its generic extension `M[G]` (Flypitch has no
  countable-transitive-model forcing) — not available.
* (c) **Reflection through Mathlib** — a middle road that reuses `ZFCCore.lean` verbatim: show that,
  for the names that actually occur, the Boolean value of "`Ȧ` has an infinite independent set" is
  `≥ p` by *constructing the certificate as ground-model data indexed by the generic point* and
  invoking Theorem 3.2 fibrewise.  The obstruction is (3.1) (fullness of `Ż` against all Borel sets
  of the extension), which is a Boolean-valued and not a fibrewise statement; so (c) needs the
  fibrewise recursion of Theorem 3.2 to be replaced by a Boolean-valued recursion — the same work
  as (a) restricted to the objects at hand.

The realistic route is (a) restricted to what is needed: an internal treatment of *reals*, *Borel
sets of profiles* (already: `BorelNames.lean`), *open envelopes with codes*, *outer measure `< 1`*
and the *certificate predicate*, at the level of Boolean values of the specific formulas.

## 2. Internal objects still to be built (all in `bSet (randomAlgebra ι)`)

1. **Reals.**  Names for reals are subsets of `ω` (`mkReal`).  `Erdos501_f` speaks about elements of
   an arbitrary complete ordered field `Ṙ`; we need `⊤ ⊩ "every complete ordered field is isomorphic
   to the field of Dedekind cuts of ℚ"` (or restate `Erdos501_f` directly over Dedekind cuts —
   `Sentence.lean` chose the field-quantifier form to avoid constructing `ℝ` in first-order logic;
   `Bridge.lean` fixes its meaning).  Either way, an internal `ℝ̇` with names of reals `≃` canonical
   names `mkReal F` is needed, together with `‖r < s‖`, `‖r + s = t‖` for canonical names
   (Boolean values of Borel relations of the readings, as in `bv_eq_mkReal`).
2. **Open sets and outer measure.**  Codes `c : ℕ → ℚ × ℚ`, `U(c) = ⋃ (qₙ, q'ₙ)`, canonical names
   `mkCode` read from a measurable `Ω ι → codes`; `‖ẏ ∈ U(ċ)‖ = [{x | y(x) ∈ U(c(x))}]` and
   `‖λ(U(ċ)) < 1‖ = [{x | λ(U(c x)) < 1}]`; the internal outer measure `‖λ*(Ȧ) < 1‖ :=
   ⨆_{ċ} (‖λ(U(ċ)) < 1‖ ⊓ ‖Ȧ ⊆ U(ċ)‖)` for a name `Ȧ` of a set of reals, and the proof that this is
   the Boolean value of the formula `OuterMeasureLtOneF` of `Sentence.lean` (outer regularity of
   Lebesgue measure, internally: a maximum-principle argument over the countable choices of covers).
3. **Certificate predicate.**  `Prof(𝒜̇)` as a Boolean value built from the pieces of Definition 3.1
   (`ZFCCore.Certificate`): `Ω̌` (Cantor space, check name), `ν̌`, `Ż = profilesName J π`, `ẋ_m` (the
   canonical names of `m + ρ(ĝ(π a 0))`), `ċ_m` (envelope codes read from the homogeneous `F` and the
   truncation (5.8)); (3.1) is `fullness` (`BorelNames.lean`), (P2) is `map_profileTest` (`ZFCCore.lean`)
   once a measure-preserving `ρ : 2^ω → [0,1)` (binary expansion) is constructed, (P3) is the
   truncation, (P4) is the maximum-principle choice of the envelopes (5.4).
4. **Theorem 3.2 internally.**  Either a Boolean-valued rerun of `ZFCCore.lean` (recursion on names)
   or the reflection (c) above; this is (F7).

## 3. Suggested order and size estimates

| step | content | estimate |
|---|---|---|
| S1 | **done** (`BinaryExpansion.lean`): `binExp` with `cantorMeasure.map binExp = volume.restrict (Ico 0 1)`, via self-similarity of the distribution function + `Measure.ext_of_Iic` | — |
| S2 | **done** (`Semantics.lean`, `InternalReals.lean`): the Boolean value of `Erdos501_f` unfolded into predicates on names (`realize_Erdos501_f`, `forced_Erdos501_f_iff`); the internal reals `Rdot, plusDot, timesDot, ltDot, zeroDot, oneDot` (names built from measurable `f : Ω ι → ℝ`, `realName f = mkReal (code ∘ f)`), evaluation lemmas (`mem_Rdot`, `app2_opDot`, `lt_ltDot`, `le_ltDot_realName`, `bv_eq_realName`) and `completeOrderedField_Rdot : ⊤ ≤ Sem.completeOrderedField Rdot …` (all twenty axioms incl. Dedekind completeness) | — |
| S3 | **done** (`RealReading.lean`): every internal real is `realName g` (`realName_of_mem_Rdot`), internal sequences are sequences of readings (`exists_seq_of_isFun`), maximum principle for the witnesses of `Sem.outerMeasureLtOne` (`outerMeasureLtOne_elim`), open-set names `openName a b`, and `outerMeasureLtOne_reading`: the internal outer-measure hypothesis for `S` gives ground sequences `a b : ℕ → MeasReal ι` with `S ⊆ᴮ openName a b` and `λ(⋃ (aₙ x, bₙ x)) ≤ sumBound a b x < 1` on `Γ` | — |
| S4 | **done** (`Envelopes.lean`): `valSet A x` and `app_valSet`, `testPoint m α`, coding of families (`encodeFam`), and `exists_homogeneous_envelopes` — one Borel `E : 2^R × 2^ℕ → (ℤ → ℕ → ℝ × ℝ)` such that on `Γ`, for `a ∈ J`, `m`: `A(testPoint m (d a)) ⊆ᴮ openName (envA E (π a) m) (envB E (π a) m)` and the cover event holds; plus `Selection.lean`: countable suprema in the measure algebra and the measurable selection of a petal from fullness (`exists_selection_of_fullness`) | — |
| S5 | **absorbed into S6**: the certificate interface is not built as internal objects; the recursion is run on names directly (see §5) | — |
| S6 | **done** (`Recursion.lean`, `Assembly.lean`, ~1000 lines): Theorem 3.2 for `Rdot` as a **ground-model recursion on names** — `exists_stage_selection`, `stage`, `ae_good`, `tj_not_mem_removedX`; the name `Xname`, `infinite_Xname`, `independent_Xname`, `exists_infinite_independent_name`, and **`erdosProperty_Rdot`** | — |
| S7 | **resolved by restating over the random algebra** (`Main.lean`): the assertion is proved for `V (randomAlgebra RandomIndex)` (𝔠⁺ random reals over the ground model, no collapse); the literal `𝔹_col_random` version (`erdos501_of_col_random`) would need the theory of names in the product `Col × Random` and is not pursued | — |
| S8 | **done** (`InternalField.lean`, `InternalIso.lean`, `Transfer.lean`, ~3350 lines): unit (F8) of §4, the internal isomorphism `psi F : F.R ≅ Rdot` for every internal complete ordered field `F` and the transport of the Erdős property along it, `erdosProperty_of_COF`; hence `erdos501_forced : ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f` | — |

The `𝔠⁺`-coordinate formulation already removes the need for `CH`; both `⊤ ⊩[V (randomAlgebra
RandomIndex)] Erdos501_ex_f` (`erdos501_ex_of_random`) and `⊤ ⊩[V (randomAlgebra RandomIndex)]
Erdos501_f` (`erdos501_of_random`) are proved.

## 4. The quantifier over all complete ordered fields: unit (F8)

`forced_Erdos501_f_iff` (`Semantics.lean`) shows that `⊤ ⊩ Erdos501_f` means: for **all** names
`R plus times lt zero one`, `Sem.completeOrderedField R … ≤ Sem.erdosProperty R …`.  Steps S3–S6
establish `⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot` for the *concrete* internal
reals `Rdot` of `InternalReals.lean` (S2 shows `⊤ ≤ Sem.completeOrderedField Rdot …`).  To pass from
`Rdot` to an arbitrary internal complete ordered field one needs, inside `V 𝔹`, that any two complete
ordered fields are isomorphic and that the Erdős property is invariant under isomorphism — the
theorem of `ZFC` that also justifies the choice of the sentence (`Sentence.lean`).  This is a new
unit, (F8), not in the paper's list (there it is absorbed in "the reals").  Options:

* (a) a Boolean-valued proof (internal `ℕ_R`, `ℚ_R`, the Archimedean property from completeness,
  the embedding `ℚ_R → R'` and its extension by suprema; then invariance of `Sem.erdosProperty`),
  ~2000–4000 lines of `bSet` reasoning; or
* (b) a *two-valued* proof in an arbitrary model `M ⊨ ZFC` (Flypitch's `Structure L_ZFC`) of the
  sentence `χ₁ := "(∃ R … COF ∧ Erdős) → ∀ R … COF → Erdős"`, transported to `V 𝔹` by Flypitch's
  **completeness theorem** (`Completeness.lean`: `ZFC ⊨ χ₁ → ZFC ⊢ χ₁`) and **Boolean soundness**
  (`Bfol.lean`: `ZFC ⊢ χ₁ → ⊤ ⊩[V 𝔹] χ₁`), after which `⊤ ⊩ Erdos501_f` follows from
  `⊤ ⊩ ∃ R … (COF ∧ Erdős)`, witnessed by `Rdot` (S2–S6).  Two-valued reasoning inside `M` avoids
  the Boolean bookkeeping but must build the isomorphism as an element of `M` (comprehension
  instances for first-order definable properties, obtainable with the `Sem`-style unfolding of
  `Semantics.lean` applied to `M`).

Either way, S3–S6 for `Rdot` come first: they are needed in both options, and yield the
intermediate theorem "`V (randomAlgebra ι)` has a complete ordered field with the Erdős property" —
this is now `completeOrderedField_and_erdosProperty_Rdot` (`Assembly.lean`).  For option (b) the
witness `Rdot` gives `⊤ ⊩ ∃ R … (COF ∧ Erdős)` after packaging the six names as an existential
(the `Sem`-unfolding of `Semantics.lean` applied to the sentence `∃ R plus times lt zero one, COF ∧
ErdosProperty`).

## 5. How (F6)/(F7) were carried out for `Rdot` (steps S4–S6, all done)

The only internal notions occurring in `Sem.erdosProperty Rdot …` are functions, subsets,
`Sem.bounded`, `Sem.outerMeasureLtOne`, `Sem.infinite`, `Sem.independent`.  So the internal
measure theory of the paper's Theorem 3.2 (σ-finite measures in `V[G]`, the sets `Q(C_j)`) does
**not** have to be replayed inside `V 𝔹`: the recursion of Theorem 3.2 can be run in the ground
model *on names*, with all measure-theoretic statements about Borel sets read from the generic
(`borelNameP T B'`, `measGtP`) checked fibrewise by ground-model measure theory, and only the
*conclusion* — a name `X` with `‖X ⊆ Rdot ∧ infinite ∧ independent‖ = ⊤` (on `Γ`) — being
Boolean-valued.  Concretely, given a name `A` with `Γ ≤ Sem.isFun Rdot (𝒫 Rdot) A` and the
hypothesis on its values:

* **S4 (envelopes).**  For each profile test point `ẋ_{m,a} = realName (fun x => m + binExp (x (π a 0)))`
  (`map_profileTest_binExp` gives (P2)), `A(ẋ_{m,a})` is a name `Ax` with
  `Γ ≤ Sem.outerMeasureLtOne Rdot … Ax` (from the hypothesis via `Sem.isFun`); S3 gives
  `a b : ℕ → MeasReal ι` with `Ax ⊆ᴮ openName a b` and `λ(⋃ (aₙ x, bₙ x)) < 1` on `Γ`.  Code the
  sequence `(aₙ, bₙ)` as one name for a subset of `ω` (`mkReal` of a coding of `ℕ → ℝ × ℝ`), and
  apply the homogeneous reading `homogeneous_reading` to the `𝔠⁺` names `ċ_{m,a}` (`a` ranging over
  a set of size `𝔠⁺` of petals): one Borel `F_m : 2^R × 2^ℕ → codes` with `ċ_{m,a} = F_m(ĝ↾R, ĝ∘π_a)`
  for `a ∈ J`; the truncation (5.8) is `sumBound a b < 1` (or a fixed rational bound after refining
  `J` by pigeonhole).
* **S5 (the certificate data as names).**  The profiles `Ż = profilesName J π`, the test points
  `ẋ_m(ż) = m + binExp (ż 0)`, the envelopes `U_m(z) = ⋃ (aₙ, bₙ)` decoded from `F_m(ĝ↾R, z)`; (3.1)
  is `fullness`, (P2) is `map_profileTest_binExp`, (P3) is `volume_iUnion_Ioo_lt_one` on the cover
  event, (P4) is `Ax ⊆ᴮ openName a b` transported along the homogeneous reading.
* **S6 (the recursion), in "function form".**  Run the recursion of
  `ZFCCore.exists_infinite_independent_of_certificate` *pointwise in the generic point `x`*, with
  all choices measurable of countable range: at stage `j` we have a Borel set `C_j(x) ⊆ ℤ × 2^P`
  depending on `x` only through the countable support `T_j` (the root `R` and the petals of the
  earlier choices), with `μ(C_j(x)) = ∞`; the good set `Q(C_j(x))` has positive measure (Lemma 2.1
  applied fibrewise), so for some `m` the section `Q(C_j(x))_m` has positive `ν`-measure, and
  `exists_selection_of_fullness` (`Selection.lean`) chooses measurably an index `a_j(x) ∈ J`
  (countably many values) with `(x↾T_j, x ∘ π_{a_j(x)}) ∈ Q(C_j(x))_m`; put
  `t_j(x) = (m_j(x), x ∘ π_{a_j(x)})`, `C_{j+1}(x) = C_j(x) \ (E_{t_j} ∪ E^{t_j} ∪ xx⁻¹{xx t_j})`
  (Lemma 2.2 keeps `μ = ∞`), and `T_{j+1} = T_j ∪ ⋃_k range (π (a_k))` over the countable range.
  Here `E_x = {(t, s) | xx t ∈ U_x s}` with `U_x (m, z) = ⋃ₙ (E (x↾R, z) m n)` the homogeneous
  envelopes of S4 (truncated to the cover event, so that (P3) holds everywhere), and
  `xx (m, z) = m + binExp (z 0)`.  The name `X` has elements `testPoint m (d a)` with Boolean values
  `[{x | ∃ j, (m_j x, a_j x) = (m, a)}]`; it is infinite (`Sem.infinite`, via the name of the
  function `j ↦ testPoint (m_j) (d a_j)`) and independent (`Sem.independent`): on the piece where
  `(m, a)` is chosen at stage `i` and `(m', a')` at stage `j > i`, `t_j ∉ E_{t_i} ∪ E^{t_i}` says
  `xx t_i ∉ U_x t_j` and `xx t_j ∉ U_x t_i`, i.e. `testPoint m (d a) ∉ openName …` for the envelope
  of `A(testPoint m' (d a'))` and vice versa, whence `x_i ∉ A(x_j)` by (P4).

  **As implemented** (`Recursion.lean`, `Assembly.lean`): the σ-finite space is `SS = ℤ × Prof` with
  `μS = count ⊗ νP`; `envSet E t s` is the truncated envelope, `Erel E ⊆ Root R × (SS × SS)` the
  measurable relation, `ErelX E x = Erel E (x↾R)`; `QX E C x = Q μS (ErelX E x) (C x)` (Lemma 2.1,
  `QX_pos`); a stage is a `structure Stage R` (`C`, its graph measurable, a countable support `T ⊇ R`,
  invariance of `C` under agreement on `T`); `exists_stage_selection` produces `cand : ℕ → ℤ × D` and
  a measurable `sel : Ω ι → ℕ` (invariant under agreement on `T ∪ ⋃ₖ range (π (cand k).2)`) with
  `tpt π cand sel x ∈ QX E C x` a.e. on `{μS (C x) = ∞}`; `stepStage` removes `removedX E x (t_j x)`;
  `stage j`, `tj j x`; `ae_good`; `tj_not_mem_removedX`.  Then `Xname`, `fname`, `selVal j k = [sel j
  = k]`, and the theorems `infinite_Xname`, `independent_Xname`, `exists_infinite_independent_name`,
  `erdosProperty_Rdot`.  The hypothesis `𝔠⁺ ≤ #ι` enters only through
  `exists_homogeneous_envelopes` (which needs `𝔠⁺` coordinates for the Δ-system/pigeonhole of Prop.
  4.4); the passage to the subtype `J` makes `hπ`, `hdisj`, `π a 0 = d a` hold for *all* `a`.

## 6. Plan for (F8): the internal isomorphism `R ≅ Rdot` (Boolean-valued option (a))

Only `plus`, `lt`, `zero`, `one` occur in `Sem.erdosProperty`, so an isomorphism of *ordered
additive groups with `1`* suffices for the transfer, and it can be built from the **dyadic**
rationals (no internal multiplication of cuts):

* internal naturals/dyadics of `R` by maximum-principle recursion on external `ℕ`: `nR 0 = zero`,
  `nR (n+1) = ` a name `u` with `app2 plus (nR n) one u`; halves `hR 0 = one`, `hR (k+1) = ` a name `u`
  with `app2 plus u u (hR k)` (existence from the field axioms, once); dyadics `dR (m, k) = m · hR k`
  (signed iterated sums); their order and additive arithmetic on `Γ' = Γ ⊓ COF(R)`;
* the Archimedean property `Γ' ≤ ⨆ n, lt ltR r (nR n)` from `Sem.complete` (a bounded `{nR n}` would
  have a supremum `s`, and `s - 1` would not be an upper bound), and density of the dyadics;
* the readings `f_i x := sup {d ∈ dyadics | x ∈ [dR d < R.func i]}` (via `cutReal`), the name
  `ψ := ⟨R.type, fun i => pair (R.func i) (realName f_i), R.bval⟩`, and on `Γ'`: `isFun R Rdot ψ`,
  order-preserving (hence injective), surjective (internal completeness of `R` applied to the cut
  set of a `realName g`), `ψ(0) = 0`, `ψ(1) = 1`, `ψ(r + r') = ψ r + ψ r'` (`csSup_add` pointwise);
* transfer: for `A : R → 𝒫 R` with `outerMeasureLtOne` values, the transported name `A' : Rdot → 𝒫 Rdot`
  (`A' (ψ r) = ψ[A r]`), its values have `outerMeasureLtOne` (transport of the covering sequences and
  partial sums along `ψ`, using additivity and `ψ 1 = 1`), `erdosProperty_Rdot` gives `X' ⊆ Rdot`, and
  `X = ψ⁻¹[X']` is infinite and independent for `A`.  Then `forced_Erdos501_f_iff` gives
  `⊤ ⊩[V (randomAlgebra ι)] Erdos501_f` directly (no detour through the syntactic
  `ZFC ⊢ Erdos501_ex_f → Erdos501_f`, which would be the two-valued option (b) of §4).

Estimate: 2500–3500 lines of Boolean-valued reasoning in the style of `InternalReals.lean`.

**Status: done.** Part 1 — the internal ordered-field toolkit, dyadics, Archimedean property, floor
and density — `InternalField.lean` (1300 lines, generic in `β`; structure `Fld β` of six names,
`Fld.COF`, `Fld.add/mul/neg/inv` by the maximum principle, `≡[Γ]` calc-equivalence, `arch`,
`exists_floor`, `dense`).  Part 2 — the readings `rd F r` of the dyadic cuts, the reading lemma, the
name `psi F` and its properties (function, order-preserving and -reflecting, injective, additive,
`0 ↦ 0`, `1 ↦ 1`, surjective) — `InternalIso.lean` (1130 lines).  Part 3 — the introduction rule
`outerMeasureLtOne_of_readings` for `Sem.outerMeasureLtOne Rdot …` from ground sequences (the
converse of `outerMeasureLtOne_reading`), the readings of the covering sequences of `F`
(`readings_*`), the transported family `Atr F A` (`Atr_isFun`, `Atr_values`), the pull-back `Xpb F X'`
(`infinite_Xpb`, `independent_Xpb`), `erdosProperty_of_COF` and `erdos501_forced` — `Transfer.lean`
(920 lines).  Note that the isomorphism transports only `plus`, `lt`, `zero`, `one` (the Erdős
property does not mention `times`), so no internal multiplication of cuts was needed.

## 7. The bridge: `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` (done)

The two-valued analogue of §4's option (b), carried out in Mathlib's `ZFSet` (the standard model)
rather than inside `ZFC`-provability: it certifies that `Erdos501_f` says exactly what DeepMind's
`erdos_501` says.

* `StdSemantics.lean`: `stdStructure : Structure L_ZFC` (`ZFSet` with `∅`, Kuratowski pairs, `ω`,
  `𝒫`, `⋃`, `∈`), the two-valued predicates `StdSem.*` mirroring `Sem.*`, and the mechanical
  computation `realize_Erdos501_f_std : (stdStructure ⊨ₘ Erdos501_f) ↔ StdSem.erdos501` (the same
  `simp` unfolding as `realize_Erdos501_f`, with `rfl`-lemmas for the standard interpretation of
  the symbols); a `ZFSet` toolkit (`natZ n = mk (PSet.ofNat n)`, `mem_omega_iff`, `natZ_injective`,
  `succ_natZ`, and the values `fval f x`, `opval op x y` of internal functions/operations).
* `RealsInZFSet.lean` (⇒): the code `cutZ r = {natZ (encode q) | q < r}` of a real (injective by
  density of `ℚ`), the complete ordered field `Rz = range cutZ` with `plusZ`, `timesZ` (sets of
  triples), `ltZ`, `zeroZ`, `oneZ` and `completeOrderedField_Rz` (twenty axioms, each a two-line
  transfer of the corresponding fact about `ℝ`; completeness via `sSup`); the copies `setZ s`,
  `famZ A`, `seqZ f`; the **covering lemma** `exists_cover_of_volume_lt_one` (`volume s < 1 → ∃ a b r,
  aₙ < bₙ ∧ s ⊆ ⋃ (aₙ, bₙ) ∧ ∀ n, ∑_{i<n} (bᵢ - aᵢ) ≤ r ∧ r < 1`), proved from
  `volume = StieltjesFunction.id.outer = OuterMeasure.ofFunction length` by choosing almost optimal
  intervals `Ioc` for the sets of a cover with `∑ length < 1` and widening them by a geometric slack;
  hence `outerMeasureLtOne_setZ`, `bounded_setZ`, and `erdos501_deepmind_of_std` (the internal
  infinite independent set pulls back along `cutZ`, the internal injection `ω → X` giving an
  injection `ℕ → ℝ`).
* `ZFSetCOF.lean` (⇐): a bundle `COF` of six sets with `completeOrderedField`; on
  `Carrier F = {x // x ∈ F.R}` the operations `opval F.plus`, `opval F.times`, the order `lt F.ltR`,
  chosen inverses; the instances `AddCommGroup`, `CommRing`, `Field`, `LinearOrder`,
  `IsOrderedAddMonoid`, `IsStrictOrderedRing` (via `IsStrictOrderedRing.of_mul_pos`; `0 < 1` is
  derived from the axioms), `SupSet` (the internal least upper bound when it exists, `0` otherwise)
  and `ConditionallyCompleteLinearOrder` (via `conditionallyCompleteLatticeOfLatticeOfsSup`), all
  verified from the internal axioms; then `realIso : ℝ ≃+*o Carrier F` is Mathlib's
  `ConditionallyCompleteLinearOrderedField.inducedOrderRingIso`.  Transport: `pull A r = {y | ofR y ∈
  A(ofR r)}` is bounded (`isBounded_pull`) and of outer measure `< 1` (`volume_pull_lt_one`: the
  internal covering sequences are read through `toR`, the partial sums are computed by induction from
  the internal recursion, and `volume ≤ ∑ ofReal (bₙ - aₙ) ≤ ofReal r < 1`); DeepMind's proposition
  gives `X' ⊆ ℝ`, whose push-forward `push X' = {ofR y | y ∈ X'} ⊆ R` is infinite (`infinite_push`,
  from `Set.Infinite.natEmbedding`) and independent (`independent_push`); hence
  `erdosProperty_of_deepmind` for every `F` and `erdos501_std_of_deepmind`.
* `Bridge.lean`: `stdStructure_realize_Erdos501_f_iff` from the three.

Sizes: `StdSemantics.lean` 440 lines, `RealsInZFSet.lean` 545, `ZFSetCOF.lean` 620, `Bridge.lean` 50.
No `sorry`; axioms `[propext, Classical.choice, Quot.sound]`.

## 8. The ¬CH direction: `independence_of_Erdos501` (done)

`Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Erdos501_f)` via `⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`, where
`𝔹_collapse = Col(ω₁, ℝ)` of `ForcingCH.lean` (`collapse_algebra.CH_true : ⊤ ≤ CH`).  Hechler's
counterexample, run Boolean-valuedly for the check-name reals.

* `OmegaClosed.lean`: **ω-closed refinement.**  For a dense ω-closed `D ⊆ 𝔹`
  (`Flypitch.DenseOmegaClosed`, e.g. `Collapse.D_col` = the principal opens of the collapse poset),
  `exists_forall_of_denseOmegaClosed` makes countably many choices simultaneously below any nonzero
  `Γ` (recursion picking a `D`-element below the current piece at each step; `iInf ∈ D` by ω-closure
  is nonzero).  Derived: `exists_decide_of_denseOmegaClosed` (decide a sequence of Boolean values),
  `exists_witness_of_denseOmegaClosed`.  This is the only use of the collapse's `(ω,∞)`-distributivity.
* `CheckReals.lean`: **the check reals.**  `codeP r` = the `PSet` of codes of rationals `< r`,
  `rname r = check (codeP r)` (`rname_bv_eq_of_ne`, distinct reals name definitely-distinct sets),
  `Rc = {rname r}`, `plusC`/`timesC` (triples), `ltC` (pairs), `zeroC`/`oneC`.  Evaluation lemmas
  `app2_opC`/`lt_ltC` with intro/elim forms decide `+`, `·`, `<` from the reals; the nineteen
  order-field axioms (`isOp2_opC`, `assoc_opC`, …, `mulPos_C`) hold for generic `𝔹`; Dedekind
  completeness `complete_Rc` needs a dense ω-closed subset — on a nonzero piece the cut
  `{q | ∃ s ∈ S, q < s}` is decided completely, so `sSup` of the decided reals is the least upper
  bound.  `completeOrderedField_Rc` / `completeOrderedField_Rc_collapse`.
* `Hechler.lean`: **the counterexample.**  The generic surjection `π_af : ℵ₁̌ ↠ 𝒫(ω)̌` of
  `ForcingCH.lean` gives, for each real `r`, its generic preimages `{i | gen i r}`
  (`gen i r = π_af i (codeIdx r)`; `gen_wide`, `gen_anti`).  `A_r = {s | |s| ≤ |r|+1 ∧ s ≺ r}` where
  `s ≺ r` (`memAEv r s`) means some preimage of `s` lies strictly below every preimage of `r`.
  `Aname` is a function `Rc → 𝒫(Rc)` (`isFun_Aname`); each `A_r` is bounded (`bounded_Aset`) and,
  being countable, of outer measure `< 1` (`outerMeasureLtOne_Aset`: on the piece where the generic
  maps `i₀ ↦ r`, `A_r` is enumerated along a ground enumeration of the `< i₀` predecessors, and the
  intervals `(s - δₙ, s + δₙ)`, `δₙ = 1/2^{n+3}`, have partial sums `≤ 1/2`).  The combinatorial core
  `no_descent`: there is no injective `w : ℕ → Ordinal` with `v : ℕ → ℝ≥0` such that
  `w k < w l → v l + 1 < v k` (floor `⌊v⌋₊` + argmin recursion builds a strictly decreasing ordinal
  chain, contradicting `not_strictAnti_of_wellFoundedLT`).  `no_infinite_independent`: if `X ⊆ Rc`
  is infinite and independent, refine (ω-closed) to a nonzero piece deciding an injective sequence
  `rₖ ∈ X` with *least* preimages `iₖ` (`leastEv`, `exists_least_of_gen`); for `toT iₙ < toT iₘ`,
  `memAEv (rₘ)(rₙ)` holds, so independence gives `¬(|rₙ| ≤ |rₘ|+1)`, i.e. `|rₘ|+1 < |rₙ|` — the
  `no_descent` hypothesis, contradiction.  Hence `erdosProperty_Rc_eq_bot`, `erdos501_eq_bot`,
  `neg_erdos501_forced_collapse : ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`, `Erdos501_f_unprovable`, and
  **`independence_of_Erdos501 : independent ZFC Erdos501_f`** (with `neg_Erdos501_f_unprovable`).

Sizes: `OmegaClosed.lean` 155 lines, `CheckReals.lean` 715, `Hechler.lean` 913.
No `sorry`; axioms `[propext, Classical.choice, Quot.sound]`.
