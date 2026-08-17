import Flypitch4.Erdos501.ColRandom
import Flypitch4.Erdos501.Bridge
import Flypitch4.Erdos501.RandomForcing
import Flypitch4.Erdos501.DeltaSystem
import Flypitch4.Erdos501.HomogeneousReading
import Flypitch4.Erdos501.BorelNames
import Flypitch4.Erdos501.ZFCCore
import Flypitch4.Erdos501.BinaryExpansion
import Flypitch4.Erdos501.Semantics
import Flypitch4.Erdos501.InternalReals
import Flypitch4.Erdos501.RealReading
import Flypitch4.Erdos501.Envelopes
import Flypitch4.Erdos501.Selection
import Flypitch4.Erdos501.Recursion
import Flypitch4.Erdos501.Assembly
import Flypitch4.Erdos501.Main
import Flypitch4.Erdos501.InternalField
import Flypitch4.Erdos501.InternalIso
import Flypitch4.Erdos501.Transfer
import Flypitch4.Erdos501.StdSemantics
import Flypitch4.Erdos501.RealsInZFSet
import Flypitch4.Erdos501.ZFSetCOF
import Flypitch4.Erdos501.Hechler
import Flypitch4.PrintFormula

/-!
Run with `lake env lean validation/Erdos501Audit.lean`.

* The sentence `Erdos501_f` is a closed, axiom-free object (`#print axioms` reports nothing).
* The paper's forcing notion `𝔹_col_random` (defined for reference in `ColRandom.lean`, unused) is
  a nontrivial complete Boolean algebra (no axioms beyond the standard ones).
* **Main theorems** (`Main.lean`), all **fully proved** (axioms `[propext, Classical.choice, Quot.sound]`):
  `erdos501_ex_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_ex_f`,
  `erdos501_ex_of_random`, `neg_Erdos501_ex_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_ex_f)` (existential
  form), and, via the internal isomorphism of every internal complete ordered field with `Rdot`
  (unit (F8), `Transfer.lean`: `erdos501_forced : 𝔠⁺ ≤ #ι → ⊤ ⊩[V (randomAlgebra ι)] Erdos501_f`),
  `erdos501_of_random : ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f` and
  **`neg_Erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)`** — the relative consistency of a positive
  answer to Erdős #501 (first question) for the universal sentence.
* `InternalField.lean` ((F8), part 1): for an arbitrary internal complete ordered field `F` (six
  names with `Γ ≤ F.COF`), names for the operations by the maximum principle, the ordered-group
  laws, `0 < 1`, halving, the internal dyadics `dyR m k = m/2^k` with their order and additive
  arithmetic, the Archimedean property (`arch`) and the density of the dyadics (`dense`); no `sorryAx`.
* `Transfer.lean` ((F8), part 3): the introduction rule `outerMeasureLtOne_of_readings` for
  `Sem.outerMeasureLtOne Rdot …` from ground readings, the transported family `Atr F A` (`Atr_isFun`,
  `Atr_values`), the pull-back `Xpb F X'` (`infinite_Xpb`, `independent_Xpb`), and
  `erdosProperty_of_COF : 𝔠⁺ ≤ #ι → Γ ≤ F.COF → Γ ≤ Sem.erdosProperty F.R F.plus F.ltR F.zero F.one`,
  whence `erdos501_forced`; no `sorryAx`.
* `InternalIso.lean` ((F8), part 2): the reading `rd F r` of an element `r` of an internal complete
  ordered field `F` (the real with dyadic cut `‖dyR d < r‖`), the reading lemma
  (`lt_dyR_le_mk_rd`, `mk_rd_le_lt_dyR`), the name `psi F : F.R → Rdot` (`psi_isFun`, `app_psi_of`,
  `eq_of_app_psi`), which preserves and reflects `<` (`rd_lt_of_lt`, `lt_of_rd_lt`), is injective
  (`eq_of_rd_eq`), additive (`rd_add`), sends `zero, one` to `0, 1` (`rd_zero`, `rd_one`) and is
  surjective (`psi_surj`, `psi_surj_app`); no `sorryAx`.
* No declaration depends on `sorryAx`.  (The literal assertion `erdos501_of_col_random` about the
  paper's two-step forcing, formerly stated with `sorry` in `ColRandom.lean`, was removed on
  2026-08-17; the formalized route uses the random algebra alone.)
* **The bridge** (`Bridge.lean`), fully proved: `stdStructure_realize_Erdos501_f_iff :
  stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` — in the standard model `ZFSet` the sentence holds
  iff DeepMind's proposition holds.  Its ingredients: the two-valued unfolding `realize_Erdos501_f_std`
  (`StdSemantics.lean`); the coding of `ℝ` as a complete ordered field `Rz` in `ZFSet`
  (`RealsInZFSet.completeOrderedField_Rz`), the covering lemma `exists_cover_of_volume_lt_one` and
  `RealsInZFSet.erdos501_deepmind_of_std`; the instances `Field`, `LinearOrder`, `IsStrictOrderedRing`,
  `ConditionallyCompleteLinearOrder` on the carrier of an internal complete ordered field, the
  isomorphism `ZFSetCOF.COF.realIso : ℝ ≃+*o Carrier F` and `ZFSetCOF.erdos501_std_of_deepmind`;
  no `sorryAx`.
* The random-forcing units of `RandomForcing.lean` ((F4) Theorems 4.1, 4.2 and (F5) Theorem 4.5)
  are fully proved: their axioms are the standard `[propext, Classical.choice, Quot.sound]` and no
  `sorryAx`.
* The Δ-system lemma `delta_system_countable` ((F3), `DeltaSystem.lean`) and the homogeneous reading
  `homogeneous_reading` ((F4) Prop. 4.4, `HomogeneousReading.lean`) are fully proved (no `sorryAx`).
* The names for Borel sets (`BorelNames.lean`: `borelName`, `borelNameP`, `profileName`,
  `profilesName`, `bv_eq_mkReal`, `mem_borelName_mkReal`, `mem_borelName`,
  `mem_borelNameP_profileName`, `iSup_mem_profilesName`) and Theorem 4.5 with names (`fullness`) are
  fully proved (no `sorryAx`).
* The ZFC core (`ZFCCore.lean`): (F1) Lemma 2.1 `measure_Q_pos`, Lemma 2.2
  `measure_diff_eq_top_of_mem_Q`, and (F2) Theorem 3.2 `exists_infinite_independent_of_certificate`
  (for the certificate interface `Certificate`, Definition 3.1) are fully proved (no `sorryAx`).
* The Boolean value of `Erdos501_f` in `V β` is computed in `Semantics.lean`
  (`realize_Erdos501_f : ⟦Erdos501_f⟧[V β] = Sem.erdos501`, `forced_Erdos501_f_iff`), and the
  internal reals `Rdot` of `V (randomAlgebra ι)` are proved to be a complete ordered field in
  `InternalReals.lean` (`completeOrderedField_Rdot`); both without `sorryAx`.
* `RealReading.lean` (step S3): every internal real is canonical (`realName_of_mem_Rdot`),
  internal sequences of reals are sequences of readings (`exists_seq_of_isFun`), the maximum
  principle for the outer-measure witnesses (`outerMeasureLtOne_elim`, via `B_ext_realize`), and
  the reading of the internal outer-measure hypothesis as a ground-model open cover of measure
  `< 1` (`outerMeasureLtOne_reading`, `volume_iUnion_Ioo_lt_one`); no `sorryAx`.
* `Envelopes.lean` (step S4): the value `valSet A x` of a function name (`app_valSet`), the profile
  test points `testPoint m α`, and the homogeneous envelopes `exists_homogeneous_envelopes`
  ((5.4)–(5.8): one Borel `E : 2^R × 2^ℕ → (ℤ → ℕ → ℝ × ℝ)` reading, for `𝔠⁺` petals, open covers
  of measure `< 1` of the values `A(testPoint m (d a))`); no `sorryAx`.
* `Selection.lean` (towards S6): every supremum in the measure algebra is a countable supremum
  (`exists_countable_iSup_eq`), and the measurable selection of a petal from the fullness lemma
  (`exists_seq_of_fullness`, `exists_selection_of_fullness`); no `sorryAx`.
* `Recursion.lean` (step S6, part 1): the recursion of Theorem 3.2 run in the ground model,
  pointwise in the generic point, with measurable choices (`exists_stage_selection`, `stage`,
  `ae_good`, `tj_not_mem_removedX`); no `sorryAx`.
* `Assembly.lean` (step S6, part 2): the name `Xname` of the infinite independent set, its
  properties `infinite_Xname`, `independent_Xname`, the packaging `exists_infinite_independent_name`,
  and **`erdosProperty_Rdot : 𝔠⁺ ≤ #ι → ⊤ ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot`**
  (Theorem 3.2 inside `V (randomAlgebra ι)`), together with
  `completeOrderedField_and_erdosProperty_Rdot`; no `sorryAx`.
-/

open Fol Flypitch Flypitch.Erdos501

#print axioms Flypitch.Erdos501.Erdos501_f
#print axioms Flypitch.Erdos501.𝔹_col_random
#print axioms Flypitch.Erdos501.𝔹_col_random.instNontrivialCBA
#print axioms Flypitch.Erdos501.mk_RandomIndex
-- MAIN THEOREMS (`Main.lean`): the existential form, fully proved
#print axioms Flypitch.Erdos501.Erdos501_ex_f
#print axioms Flypitch.Erdos501.realize_Erdos501_ex_f
#print axioms Flypitch.Erdos501.forced_Erdos501_ex_f_of
#print axioms Flypitch.Erdos501.erdos501_ex_forced
#print axioms Flypitch.Erdos501.erdos501_ex_of_random
#print axioms Flypitch.Erdos501.V_random_models_ZFC
#print axioms Flypitch.Erdos501.neg_Erdos501_ex_f_unprovable
-- the universal form (via (F8), `Transfer.lean`), fully proved
#print axioms Flypitch.Erdos501.RandomForcing.outerMeasureLtOne_of_readings
#print axioms Flypitch.Erdos501.RandomForcing.Atr_isFun
#print axioms Flypitch.Erdos501.RandomForcing.Atr_values
#print axioms Flypitch.Erdos501.RandomForcing.infinite_Xpb
#print axioms Flypitch.Erdos501.RandomForcing.independent_Xpb
#print axioms Flypitch.Erdos501.RandomForcing.erdosProperty_of_COF
#print axioms Flypitch.Erdos501.RandomForcing.erdos501_forced
#print axioms Flypitch.Erdos501.erdos501_of_random
#print axioms Flypitch.Erdos501.neg_Erdos501_f_unprovable
-- THE BRIDGE (`StdSemantics.lean`, `RealsInZFSet.lean`, `ZFSetCOF.lean`, `Bridge.lean`), fully proved
#print axioms Flypitch.Erdos501.stdStructure
#print axioms Flypitch.Erdos501.erdos501_deepmind
#print axioms Flypitch.Erdos501.realize_Erdos501_f_std
#print axioms Flypitch.Erdos501.StdSem.mem_omega_iff
#print axioms Flypitch.Erdos501.StdSem.natZ_injective
#print axioms Flypitch.Erdos501.RealsInZFSet.cutZ_injective
#print axioms Flypitch.Erdos501.RealsInZFSet.completeOrderedField_Rz
#print axioms Flypitch.Erdos501.RealsInZFSet.exists_cover_of_volume_lt_one
#print axioms Flypitch.Erdos501.RealsInZFSet.outerMeasureLtOne_setZ
#print axioms Flypitch.Erdos501.RealsInZFSet.erdos501_deepmind_of_std
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.instFieldCarrier
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.instConditionallyCompleteLinearOrderCarrier
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.instIsStrictOrderedRingCarrier
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.realIso
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.volume_pull_lt_one
#print axioms Flypitch.Erdos501.ZFSetCOF.COF.erdosProperty_of_deepmind
#print axioms Flypitch.Erdos501.ZFSetCOF.erdos501_std_of_deepmind
#print axioms Flypitch.Erdos501.stdStructure_realize_Erdos501_f_iff

-- (F4)–(F6): random-forcing units, fully proved (no `sorryAx`)
#print axioms Flypitch.Erdos501.RandomForcing.exists_countable_support
#print axioms Flypitch.Erdos501.RandomForcing.exists_rep_countable_support
#print axioms Flypitch.Erdos501.RandomForcing.mkReal
#print axioms Flypitch.Erdos501.RandomForcing.mkReal_definite
#print axioms Flypitch.Erdos501.RandomForcing.mem_mkReal
#print axioms Flypitch.Erdos501.RandomForcing.genericReal
#print axioms Flypitch.Erdos501.RandomForcing.eq_of_forall_of_nat_mem_eq
#print axioms Flypitch.Erdos501.RandomForcing.exists_mkReal_bv_eq
#print axioms Flypitch.Erdos501.RandomForcing.exists_mkReal_restrict_bv_eq
#print axioms Flypitch.Erdos501.RandomForcing.map_restrict
#print axioms Flypitch.Erdos501.RandomForcing.map_eval
#print axioms Flypitch.Erdos501.RandomForcing.iIndepFun_eval
#print axioms Flypitch.Erdos501.RandomForcing.comap_restrict_eq
#print axioms Flypitch.Erdos501.RandomForcing.indepFun_restrict_restrict
#print axioms Flypitch.Erdos501.RandomForcing.indepFun_restrict_eval
#print axioms Flypitch.Erdos501.RandomForcing.map_restrict_prod_restrict
#print axioms Flypitch.Erdos501.RandomForcing.μ_random_restrict_prod_restrict
#print axioms Flypitch.Erdos501.RandomForcing.map_restrict_prod_eval
#print axioms Flypitch.Erdos501.RandomForcing.μ_random_restrict_prod_eval
#print axioms Flypitch.Erdos501.RandomForcing.measure_restrict_prod_eval
#print axioms Flypitch.Erdos501.RandomForcing.measure_pos_of_fiber_pos_ae
#print axioms Flypitch.Erdos501.RandomForcing.measure_pos_of_fiber_pos
#print axioms Flypitch.Erdos501.RandomForcing.bot_lt_inf_mk_of_fiber_pos
#print axioms Flypitch.Erdos501.RandomForcing.exists_not_mem_of_countable
#print axioms Flypitch.Erdos501.RandomForcing.exists_mem_not_mem_of_countable
#print axioms Flypitch.Erdos501.RandomForcing.exists_fresh_of_fiber_pos
#print axioms Flypitch.Erdos501.RandomForcing.map_comp_injective
#print axioms Flypitch.Erdos501.RandomForcing.indepFun_restrict_comp
#print axioms Flypitch.Erdos501.RandomForcing.map_restrict_prod_comp
#print axioms Flypitch.Erdos501.RandomForcing.measure_restrict_prod_of_map
#print axioms Flypitch.Erdos501.RandomForcing.measure_pos_of_fiber_pos_of_map
#print axioms Flypitch.Erdos501.RandomForcing.bot_lt_inf_mk_of_fiber_pos_comp
#print axioms Flypitch.Erdos501.RandomForcing.exists_fresh_petal_of_fiber_pos
-- (F3) Δ-system lemma and (F4) Prop. 4.4, both proved
#print axioms Flypitch.Erdos501.delta_system_countable
#print axioms Flypitch.Erdos501.RandomForcing.card_measurableSet_le_continuum
#print axioms Flypitch.Erdos501.RandomForcing.card_measurable_le_continuum
#print axioms Flypitch.Erdos501.RandomForcing.homogeneous_reading
-- names for Borel sets and Theorem 4.5 with names (no `sorryAx`)
#print axioms Flypitch.Erdos501.RandomForcing.bv_eq_mkReal
#print axioms Flypitch.Erdos501.RandomForcing.borelName
#print axioms Flypitch.Erdos501.RandomForcing.mem_borelName_mkReal
#print axioms Flypitch.Erdos501.RandomForcing.mem_borelName_le_subset_omega
#print axioms Flypitch.Erdos501.RandomForcing.mem_borelName
#print axioms Flypitch.Erdos501.RandomForcing.profileName
#print axioms Flypitch.Erdos501.RandomForcing.profilesName
#print axioms Flypitch.Erdos501.RandomForcing.borelNameP
#print axioms Flypitch.Erdos501.RandomForcing.mem_borelNameP_profileName
#print axioms Flypitch.Erdos501.RandomForcing.iSup_mem_profilesName
#print axioms Flypitch.Erdos501.RandomForcing.measGtP
#print axioms Flypitch.Erdos501.RandomForcing.exists_countable_restrict_preimage
#print axioms Flypitch.Erdos501.RandomForcing.fullness
-- the ZFC core: (F1) Lemmas 2.1, 2.2 and (F2) Theorem 3.2, all proved
#print axioms Flypitch.Erdos501.ZFCCore.measurableSet_Q
#print axioms Flypitch.Erdos501.ZFCCore.measure_Q_pos
#print axioms Flypitch.Erdos501.ZFCCore.measure_diff_eq_top_of_mem_Q
#print axioms Flypitch.Erdos501.ZFCCore.Certificate
#print axioms Flypitch.Erdos501.ZFCCore.tsum_volume_inter_Ico
#print axioms Flypitch.Erdos501.ZFCCore.exists_infinite_independent_of_certificate
#print axioms Flypitch.Erdos501.ZFCCore.erdos501_deepmind_of_certificate
#print axioms Flypitch.Erdos501.ZFCCore.map_profileTest
-- binary expansion is measure preserving (S1), (P2) for the profile test points
#print axioms Flypitch.Erdos501.ZFCCore.binExp
#print axioms Flypitch.Erdos501.ZFCCore.map_zero_shift
#print axioms Flypitch.Erdos501.ZFCCore.F_dyadic
#print axioms Flypitch.Erdos501.ZFCCore.map_binExp
#print axioms Flypitch.Erdos501.ZFCCore.map_profileTest_binExp
-- the Boolean value of `Erdos501_f` (`Semantics.lean`), no `sorryAx`
#print axioms Flypitch.Erdos501.Sem.erdos501
#print axioms Flypitch.Erdos501.realize_Erdos501_f
#print axioms Flypitch.Erdos501.forced_Erdos501_f_iff
-- the internal reals `Rdot` form a complete ordered field (`InternalReals.lean`, step S2), no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.code_injective
#print axioms Flypitch.Erdos501.RandomForcing.realName
#print axioms Flypitch.Erdos501.RandomForcing.bv_eq_realName
#print axioms Flypitch.Erdos501.RandomForcing.Rdot
#print axioms Flypitch.Erdos501.RandomForcing.mem_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.app2_opDot
#print axioms Flypitch.Erdos501.RandomForcing.lt_ltDot
#print axioms Flypitch.Erdos501.RandomForcing.isOp2_opDot
#print axioms Flypitch.Erdos501.RandomForcing.assoc_opDot
#print axioms Flypitch.Erdos501.RandomForcing.distrib_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.mulInv_timesDot
#print axioms Flypitch.Erdos501.RandomForcing.total_ltDot
#print axioms Flypitch.Erdos501.RandomForcing.addCompat_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.mulPos_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.complete_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.completeOrderedField_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.erdosProperty_Rdot_of_forced
-- reading internal reals, sequences and covers (`RealReading.lean`, step S3), no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.eq_of_forall_of_nat_mem_eq'
#print axioms Flypitch.Erdos501.RandomForcing.exists_mkReal_of_subset_omega
#print axioms Flypitch.Erdos501.RandomForcing.decode_code
#print axioms Flypitch.Erdos501.RandomForcing.realName_of_mem_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.app_valName
#print axioms Flypitch.Erdos501.RandomForcing.exists_seq_of_isFun
#print axioms Flypitch.Erdos501.RandomForcing.B_ext_realize
#print axioms Flypitch.Erdos501.RandomForcing.realize_omBody₃
#print axioms Flypitch.Erdos501.RandomForcing.outerMeasureLtOne_elim
#print axioms Flypitch.Erdos501.RandomForcing.mem_openName_realName
#print axioms Flypitch.Erdos501.RandomForcing.succ_of_nat
#print axioms Flypitch.Erdos501.RandomForcing.outerMeasureLtOne_reading
#print axioms Flypitch.Erdos501.RandomForcing.volume_iUnion_Ioo_lt_one
-- homogeneous envelopes (`Envelopes.lean`, step S4), no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.eq_of_forall_realName_mem_eq'
#print axioms Flypitch.Erdos501.RandomForcing.app_valSet
#print axioms Flypitch.Erdos501.RandomForcing.decodeFam_encodeFam
#print axioms Flypitch.Erdos501.RandomForcing.testPoint
#print axioms Flypitch.Erdos501.RandomForcing.openName_congr_ae
#print axioms Flypitch.Erdos501.RandomForcing.exists_homogeneous_envelopes
-- measurable selection from fullness (`Selection.lean`), no `sorryAx`
#print axioms Flypitch.MeasureAlgebra.exists_countable_iSup_eq
#print axioms Flypitch.Erdos501.RandomForcing.measurable_firstIndex
#print axioms Flypitch.Erdos501.RandomForcing.exists_seq_of_fullness
#print axioms Flypitch.Erdos501.RandomForcing.exists_selection_of_fullness
-- the recursion of Theorem 3.2 on names (`Recursion.lean`, step S6 part 1), no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.μS_preimage_xx
#print axioms Flypitch.Erdos501.RandomForcing.μS_section_ErelX_le_one
#print axioms Flypitch.Erdos501.RandomForcing.QX_pos
#print axioms Flypitch.Erdos501.RandomForcing.exists_stage_selection
#print axioms Flypitch.Erdos501.RandomForcing.stage
#print axioms Flypitch.Erdos501.RandomForcing.ae_good
#print axioms Flypitch.Erdos501.RandomForcing.tj_not_mem_removedX
-- the name of the infinite independent set (`Assembly.lean`, step S6 part 2), no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.Xname
#print axioms Flypitch.Erdos501.RandomForcing.infinite_Xname
#print axioms Flypitch.Erdos501.RandomForcing.independent_Xname
#print axioms Flypitch.Erdos501.RandomForcing.exists_infinite_independent_name
#print axioms Flypitch.Erdos501.RandomForcing.erdosProperty_Rdot
#print axioms Flypitch.Erdos501.RandomForcing.completeOrderedField_and_erdosProperty_Rdot
-- (F8) part 1 (`InternalField.lean`): internal complete ordered fields, no `sorryAx`
#print axioms Flypitch.Erdos501.Fld.opN
#print axioms Flypitch.Erdos501.Fld.add_assoc
#print axioms Flypitch.Erdos501.Fld.zero_lt_one
#print axioms Flypitch.Erdos501.Fld.half_add_half
#print axioms Flypitch.Erdos501.Fld.dyR_add
#print axioms Flypitch.Erdos501.Fld.dyR_lt_of_cross
#print axioms Flypitch.Erdos501.Fld.arch
#print axioms Flypitch.Erdos501.Fld.exists_floor
#print axioms Flypitch.Erdos501.Fld.dense
-- (F8) part 2 (`InternalIso.lean`): the internal isomorphism `F ≅ Rdot`, no `sorryAx`
#print axioms Flypitch.Erdos501.RandomForcing.rd
#print axioms Flypitch.Erdos501.RandomForcing.psi
#print axioms Flypitch.Erdos501.RandomForcing.mem_iff_lt_dyReal
#print axioms Flypitch.Erdos501.RandomForcing.lt_dyR_le_mk_rd
#print axioms Flypitch.Erdos501.RandomForcing.mk_rd_le_lt_dyR
#print axioms Flypitch.Erdos501.RandomForcing.psi_isFun
#print axioms Flypitch.Erdos501.RandomForcing.app_psi_of
#print axioms Flypitch.Erdos501.RandomForcing.eq_of_app_psi
#print axioms Flypitch.Erdos501.RandomForcing.rd_lt_of_lt
#print axioms Flypitch.Erdos501.RandomForcing.lt_of_rd_lt
#print axioms Flypitch.Erdos501.RandomForcing.eq_of_rd_eq
#print axioms Flypitch.Erdos501.RandomForcing.rd_add
#print axioms Flypitch.Erdos501.RandomForcing.rd_zero
#print axioms Flypitch.Erdos501.RandomForcing.rd_one
#print axioms Flypitch.Erdos501.RandomForcing.psi_surj
#print axioms Flypitch.Erdos501.RandomForcing.psi_surj_app
-- (F2) shape check: a certificate yields an infinite independent set
example {A : ℝ → Set ℝ} {Ω : Type} [MeasurableSpace Ω] (cert : Flypitch.Erdos501.ZFCCore.Certificate A Ω) :
    ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) :=
  Flypitch.Erdos501.ZFCCore.exists_infinite_independent_of_certificate cert

-- (F4)–(F6) shape checks
section
open Flypitch.Erdos501.RandomForcing MeasureTheory ProbabilityTheory
open scoped bSet
variable {ι : Type}
-- (F4): every name for a subset of `ω` is read by a Borel function of countably many coordinates
example (xdot : bSet (randomAlgebra ι)) (hx : ⊤ ≤ xdot ⊆ᴮ bSet.omega) :
    ∃ (S : Set ι) (F : (S → (ℕ → Bool)) → (ℕ → Bool)) (hF : Measurable F),
      S.Countable ∧ ⊤ ≤ xdot =ᴮ mkReal (F ∘ S.restrict) (hF.comp S.measurable_restrict) :=
  exists_mkReal_restrict_bv_eq xdot hx
-- (F5): `𝔹(T ⊔ P) = 𝔹(T) ⊗ 𝔹(P)`
example {T P : Set ι} (h : Disjoint T P) :
    IndepFun (T.restrict (π := fun _ => ℕ → Bool)) (P.restrict (π := fun _ => ℕ → Bool))
      (RandomAlgebra.μ_random ι) :=
  indepFun_restrict_restrict h
-- Theorem 4.5 with names: `‖ν(Ḃ) > ε‖ ≤ ‖Ḃ ∩ Ż ≠ ∅‖`
example {A : Type} {J : Set A} (hJ : ¬ J.Countable) {π : A → ℕ → ι}
    (hπ : ∀ a, Function.Injective (π a))
    (hdisj : ∀ a b, a ≠ b → Disjoint (Set.range (π a)) (Set.range (π b)))
    (T : Set ι) (hT : T.Countable) {B' : Set ((T → (ℕ → Bool)) × (ℕ → (ℕ → Bool)))}
    (hB' : MeasurableSet B') {ε : ENNReal} (hε : 0 < ε) :
    measGtP T hB' ε ≤
      ⨆ z : bSet (randomAlgebra ι), z ∈ᴮ profilesName J π ⊓ z ∈ᴮ borelNameP T hB' := by
  rw [iSup_mem_profilesName]
  exact fullness T hB' hJ hπ hdisj hT hε
-- Theorem 4.5: the generic real at a fresh coordinate is random over `𝔹(T)`
example (T : Set ι) (α : ι) (hα : α ∉ T) {Q : Set (T → (ℕ → Bool))} (hQ : MeasurableSet Q)
    {B : Set ((T → (ℕ → Bool)) × (ℕ → Bool))} (hB : MeasurableSet B) {ε : ENNReal} (hε : 0 < ε)
    (hQpos : 0 < Measure.infinitePi (fun _ : T => RandomAlgebra.cantorMeasure) Q)
    (hfib : ∀ t ∈ Q, ε ≤ RandomAlgebra.cantorMeasure (Prod.mk t ⁻¹' B)) :
    0 < RandomAlgebra.μ_random ι {x | T.restrict x ∈ Q ∧ (T.restrict x, x α) ∈ B} :=
  measure_pos_of_fiber_pos T α hα hQ hB hε hQpos hfib
end

-- shape checks
example : sentence L_ZFC := Erdos501_f
example : sentence L_ZFC := Erdos501_ex_f
example : ¬ Fol.SentTheory.sprovable ZFC (bd_not Erdos501_f : sentence L_ZFC) :=
  neg_Erdos501_f_unprovable
-- the main theorems
example {ι : Type} (hι : Order.succ Cardinal.continuum ≤ Cardinal.mk ι) :
    Fol.forced_in (⊤ : randomAlgebra ι) (V (randomAlgebra ι)) Erdos501_ex_f :=
  erdos501_ex_forced hι
example : Fol.forced_in (⊤ : 𝔹_random_succ_continuum) (V 𝔹_random_succ_continuum) Erdos501_ex_f :=
  erdos501_ex_of_random
example : ¬ Fol.SentTheory.sprovable ZFC (bd_not Erdos501_ex_f : sentence L_ZFC) :=
  neg_Erdos501_ex_f_unprovable
example {ι : Type} (hι : Order.succ Cardinal.continuum ≤ Cardinal.mk ι) :
    Fol.forced_in (⊤ : randomAlgebra ι) (V (randomAlgebra ι)) Erdos501_f :=
  Flypitch.Erdos501.RandomForcing.erdos501_forced hι
example : Fol.forced_in (⊤ : 𝔹_random_succ_continuum) (V 𝔹_random_succ_continuum) Erdos501_f :=
  erdos501_of_random
-- the bridge
example : (stdStructure ⊨ₘ Erdos501_f) ↔ erdos501_deepmind := stdStructure_realize_Erdos501_f_iff
noncomputable example (F : Flypitch.Erdos501.ZFSetCOF.COF) :
    ℝ ≃+*o Flypitch.Erdos501.ZFSetCOF.COF.Carrier F :=
  Flypitch.Erdos501.ZFSetCOF.COF.realIso
example : Flypitch.Erdos501.StdSem.completeOrderedField Flypitch.Erdos501.RealsInZFSet.Rz
    Flypitch.Erdos501.RealsInZFSet.plusZ Flypitch.Erdos501.RealsInZFSet.timesZ
    Flypitch.Erdos501.RealsInZFSet.ltZ Flypitch.Erdos501.RealsInZFSet.zeroZ
    Flypitch.Erdos501.RealsInZFSet.oneZ := Flypitch.Erdos501.RealsInZFSet.completeOrderedField_Rz
example : 𝔹_col_random =
    Flypitch.RegularOpens (Topology.WithLowerSet
      ({b : collapse_algebra.𝔹_collapse // ⊥ < b} × {b : randomAlgebra RandomIndex // ⊥ < b})) := rfl

-- THE ¬CH DIRECTION (Hechler): `Erdos501_f_unprovable`, `independence_of_Erdos501`, fully proved
#print axioms Flypitch.Erdos501.Hechler.no_descent
#print axioms Flypitch.Erdos501.CheckReals.completeOrderedField_Rc
#print axioms Flypitch.Erdos501.CheckReals.completeOrderedField_Rc_collapse
#print axioms Flypitch.Erdos501.exists_forall_of_denseOmegaClosed
#print axioms Flypitch.Erdos501.Hechler.isFun_Aname
#print axioms Flypitch.Erdos501.Hechler.bounded_Aset
#print axioms Flypitch.Erdos501.Hechler.outerMeasureLtOne_Aset
#print axioms Flypitch.Erdos501.Hechler.no_infinite_independent
#print axioms Flypitch.Erdos501.Hechler.erdos501_eq_bot
#print axioms Flypitch.Erdos501.Hechler.neg_erdos501_forced_collapse
#print axioms Flypitch.Erdos501.Hechler.Erdos501_f_unprovable
#print axioms Flypitch.Erdos501.Hechler.independence_of_Erdos501

-- shape checks for the ¬CH direction
example : (⊤ : collapse_algebra.𝔹_collapse) ⊩[V collapse_algebra.𝔹_collapse]
    (bd_not Erdos501_f : sentence L_ZFC) := Flypitch.Erdos501.Hechler.neg_erdos501_forced_collapse
example : ¬ Fol.SentTheory.sprovable ZFC Erdos501_f := Flypitch.Erdos501.Hechler.Erdos501_f_unprovable
example : independent ZFC Erdos501_f := Flypitch.Erdos501.Hechler.independence_of_Erdos501

-- the sentence is a concrete (computable) object: its printed form
#eval IO.println s!"|Erdos501_f| = {(print_formula Erdos501_f).length} characters"

-- shape checks for `Semantics.lean` and `InternalReals.lean`
section
open Flypitch.Erdos501 Flypitch.Erdos501.RandomForcing
open scoped bSet Flypitch
variable {β : Type} [NontrivialCompleteBooleanAlgebra β] {ι : Type}
-- `Erdos501_f` is forced iff every complete ordered field of names has the Erdős property
example {Γ : β} : (Γ ⊩[V β] Erdos501_f) ↔
    ∀ R plus times ltR zero one : bSet β,
      Γ ⊓ Sem.completeOrderedField R plus times ltR zero one ≤ Sem.erdosProperty R plus ltR zero one :=
  forced_Erdos501_f_iff
-- the internal reals are a complete ordered field
example : ⊤ ≤ Sem.completeOrderedField (Rdot : bSet (randomAlgebra ι)) plusDot timesDot ltDot
    zeroDot oneDot :=
  completeOrderedField_Rdot
-- (S3) the internal outer-measure hypothesis is read as a ground-model open cover of measure `< 1`
example {Γ : randomAlgebra ι} {S : bSet (randomAlgebra ι)} (hS : Γ ≤ S ⊆ᴮ Rdot)
    (h : Γ ≤ Sem.outerMeasureLtOne Rdot plusDot ltDot zeroDot oneDot S) :
    ∃ a b : ℕ → MeasReal ι,
      Γ ≤ MeasureAlgebra.mk (RandomAlgebra.μ_random ι) (coverEvent (seqFun a) (seqFun b))
        (measurableSet_coverEvent (measurable_seqFun a) (measurable_seqFun b)) ∧
      Γ ≤ S ⊆ᴮ openName a b :=
  outerMeasureLtOne_reading hS h
example (a b : ℕ → MeasReal ι) {x : RandomAlgebra.Ω ι} (hx : x ∈ coverEvent (seqFun a) (seqFun b)) :
    MeasureTheory.volume (⋃ n, Set.Ioo ((a n).1 x) ((b n).1 x)) < 1 :=
  volume_iUnion_Ioo_lt_one hx
-- (S6) Theorem 3.2 in `V (randomAlgebra ι)`: for `𝔠⁺ ≤ #ι`, `Rdot` has the Erdős property
example (hι : Order.succ Cardinal.continuum ≤ Cardinal.mk ι) :
    (⊤ : randomAlgebra ι) ≤ Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot :=
  erdosProperty_Rdot hι
example (hι : Order.succ Cardinal.continuum ≤ Cardinal.mk ι) :
    (⊤ : randomAlgebra ι) ≤ Sem.completeOrderedField Rdot plusDot timesDot ltDot zeroDot oneDot ⊓
      Sem.erdosProperty Rdot plusDot ltDot zeroDot oneDot :=
  completeOrderedField_and_erdosProperty_Rdot hι
end
