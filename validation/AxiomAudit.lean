import Solution

/-!
Run with:  lake env lean validation/AxiomAudit.lean   (or scripts/check-axioms.sh)

Prints the axiom dependencies of the seven comparator targets as proved in
`Solution.lean` (the Palomar-conformant challenge, statements in Mathlib's
`ModelTheory`) and in `SolutionFlypitch.lean` (the same results in Flypitch's
proof-theoretic terms), and of the intermediate results they rest on.  Any
occurrence of `sorryAx` marks a target that is not yet closed.

Both solutions declare the same seven names at top level, so only `Solution` is
imported here; `SolutionFlypitch.lean`'s theorems are one-line delegations to the
`Erdos501.*` results audited below.
-/

-- comparator targets, `Solution.lean` (`comparator.json`)
#print axioms erdos501_closed_infinite
#print axioms erdos501_closed_size3
#print axioms erdos501_hechler_of_CH
#print axioms erdos501_not_refutable
#print axioms erdos501_not_provable
#print axioms erdos501_independent
#print axioms erdos501_sentence_faithful

-- the bridge from Mathlib's first-order logic to Flypitch's (`Erdos501/FOL/`)
#print axioms Erdos501.FOL.tr_Erdos501
#print axioms Erdos501.FOL.toM_models_ZFC
#print axioms Erdos501.FOL.realize_Erdos501_iff
#print axioms Erdos501.FOL.erdos501_not_provable
#print axioms Erdos501.FOL.erdos501_not_refutable
#print axioms Erdos501.FOL.erdos501_independent

-- the same targets in Flypitch's terms (`SolutionFlypitch.lean`, `comparator-flypitch.json`)
#print axioms Erdos501.neg_erdos501_f_unprovable
#print axioms Erdos501.erdos501_f_unprovable
#print axioms Erdos501.erdos501_independent
#print axioms Erdos501.erdos501_sentence_faithful

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
