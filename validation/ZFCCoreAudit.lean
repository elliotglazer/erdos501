/-
Axiom audit for the ZFC core (`Erdos501/ZFCCore/*.lean`).

  lake env lean validation/ZFCCoreAudit.lean
-/
import Erdos501

open Erdos501

#print axioms pos_measure_Q
#print axioms infinite_measure_preservation
#print axioms prof_imp_free
#print axioms prof_imp_free'
