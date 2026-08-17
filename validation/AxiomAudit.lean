import Solution

/-!
Run with:  lake env lean validation/AxiomAudit.lean   (or scripts/check-axioms.sh)

Prints the axiom dependencies of the five comparator targets as proved in
`Solution.lean`, and of the intermediate results they rest on.  Any occurrence
of `sorryAx` marks a target that is not yet closed.
-/

-- comparator targets
#print axioms erdos501_closed_infinite
#print axioms erdos501_closed_size3
#print axioms erdos501_hechler_of_CH
#print axioms erdos501_independent
#print axioms erdos501_sentence_faithful

-- Flypitch endpoints the independence statement is modelled on
#print axioms independence_of_CH
#print axioms fundamental_theorem_of_forcing
