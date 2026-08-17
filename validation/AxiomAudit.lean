import Solution

/-!
Run with:  lake env lean validation/AxiomAudit.lean   (or scripts/check-axioms.sh)

Prints the axiom dependencies of the seven comparator targets as proved in
`Solution.lean`, and of the intermediate results they rest on.  Any occurrence
of `sorryAx` marks a target that is not yet closed.
-/

-- comparator targets
#print axioms erdos501_closed_infinite
#print axioms erdos501_closed_size3
#print axioms erdos501_hechler_of_CH
#print axioms erdos501_not_refutable
#print axioms erdos501_not_provable
#print axioms erdos501_independent
#print axioms erdos501_sentence_faithful

-- the forcing-side endpoints (`Flypitch4/Erdos501/`)
#print axioms Flypitch.Erdos501.Erdos501_f
#print axioms Flypitch.Erdos501.erdos501_of_random
#print axioms Flypitch.Erdos501.neg_Erdos501_f_unprovable
#print axioms Flypitch.Erdos501.Hechler.neg_erdos501_forced_collapse
#print axioms Flypitch.Erdos501.Hechler.Erdos501_f_unprovable
#print axioms Flypitch.Erdos501.Hechler.independence_of_Erdos501
#print axioms Flypitch.Erdos501.stdStructure_realize_Erdos501_f_iff

-- Flypitch endpoints the independence statement is modelled on
#print axioms independence_of_CH
#print axioms fundamental_theorem_of_forcing
