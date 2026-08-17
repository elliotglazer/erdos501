import Flypitch4.Summary
import Flypitch4.SummaryRandom

/-!
This file is intentionally outside the `Flypitch4` library tree. Run it with:

  lake env lean validation/AxiomAudit.lean

It prints the axiom dependencies of the final theorem and the intermediate
CH/forcing endpoints that are most relevant to the port validation.
-/

#print axioms independence_of_CH
#print axioms CH_unprovable
#print axioms neg_CH_unprovable
#print axioms CH_f_unprovable
#print axioms neg_CH_f_unprovable
#print axioms V_𝔹_cohen_models_neg_CH
#print axioms V_𝔹_collapse_models_CH
#print axioms CH_f_is_CH
#print axioms collapse_algebra.CH_true
#print axioms collapse_algebra.CH₂_true
#print axioms collapse_algebra.aleph_one_not_lt_powerset_omega
#print axioms collapse_algebra.aleph_one_check_le_of_omega_lt_collapse
#print axioms collapse_algebra.omega_lt_aleph_one_collapse
#print axioms collapse_algebra.surjection_reflect
#print axioms collapse_algebra.no_pset_surj_omega_aleph_one

-- Alternative proof of `CH_unprovable` via the ℵ₂-random algebra
#print axioms CH_unprovable_random
#print axioms independence_of_CH_random
#print axioms V_𝔹_random_models_neg_CH
#print axioms bSet.neg_CH_random
#print axioms bSet.neg_CH_of_CCC_of_indep
#print axioms Flypitch.𝔹_random_CCC
#print axioms Flypitch.MeasureAlgebra.CCC_measureAlgebra
#print axioms Flypitch.MeasureAlgebra.instCompleteBooleanAlgebra
#print axioms Flypitch.RandomAlgebra.iInf_biimp_χ_eq_bot
