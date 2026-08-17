import Flypitch4.Summary

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
