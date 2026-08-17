# Flypitch4 Validation

This directory collects validation notes for the Lean 4 `flypitch4` port.

The top-level `../VALIDATION.md` records the mechanical audit: build status,
axiom output, proof-hole search, and the committed cleanup of the collapse-side
nonsurjection proof.

The notes here focus on mathematical validation: whether the formal objects
match the intended CH-independence argument, where a port could accidentally
weaken the theorem, and which proof bridges deserve the most scrutiny.

## Notes

- `../AUDIT.md`: independent audit of the port (statement-level Lean 3 → Lean 4 comparison,
  build/axiom checks) and description of the alternative `¬CH` consistency proof via the
  `ℵ₂`-random algebra (`MeasureAlgebra.lean`, `RandomAlgebra.lean`, `ForcingRandom.lean`,
  `SummaryRandom.lean`); `AxiomAudit.lean` and `StatementShape.lean` cover its endpoints.

- `axiom-audit.md`: reusable `#print axioms` audit for the final theorem and
  intermediate CH/forcing endpoints.
- `mathematical-audit.md`: math-facing audit of the theorem path, CH statement,
  forcing endpoints, and the collapse-side object bridge.
- `predicate-comparison.md`: deeper comparison of the cardinal-comparison
  predicates and formula-realization lemmas.
- `statement-comparison.md`: targeted Lean 3 to Lean 4 statement comparison
  for the CH endpoints and reflection/collapse bridge.
- `AxiomAudit.lean`: Lean script backing `axiom-audit.md`.
- `DependencyCheck.lean`: Lean script showing that the random-algebra proof of
  `¬ (ZFC ⊢ₛ' CH_f)` does not depend on the Cohen algebra.
- `Erdos501Audit.lean`, `Erdos501Print.lean`: axiom/shape checks and pretty-printing for the
  Erdős #501 sentence `Erdos501_f` and the
  proof units (F1)–(F5) of
  `Flypitch4/Erdos501/{ZFCCore,RandomForcing,DeltaSystem,HomogeneousReading,BorelNames,BinaryExpansion}.lean`,
  the Boolean value of `Erdos501_f` (`Semantics.lean`), the internal reals (`InternalReals.lean`) and
  the reading of internal reals/covers as Borel data (`RealReading.lean`), the homogeneous envelopes
  (`Envelopes.lean`), the measurable selection from fullness (`Selection.lean`), the recursion of
  Theorem 3.2 on names (`Recursion.lean`), the name of the infinite independent set with
  `erdosProperty_Rdot` (`Assembly.lean`), the main theorems of `Main.lean`
  (`erdos501_ex_forced`, `neg_Erdos501_ex_f_unprovable`, `erdos501_of_random`,
  `neg_Erdos501_f_unprovable`, all proved), (F8) (`InternalField.lean`, `InternalIso.lean`,
  `Transfer.lean`: `erdos501_forced`), and the bridge (`StdSemantics.lean`, `RealsInZFSet.lean`,
  `ZFSetCOF.lean`, `Bridge.lean`: `stdStructure_realize_Erdos501_f_iff : stdStructure ⊨ₘ Erdos501_f
  ↔ erdos501_deepmind`, proved).
- `StatementShape.lean`: Lean elaboration checks for critical theorem shapes.

## Current Status

The strongest evidence gathered so far is:

- `independence_of_CH` builds from compiled Lean proof terms.
- `#print axioms independence_of_CH` reports only
  `[propext, Classical.choice, Quot.sound]`.
- Intermediate endpoint axiom checks report the same dependency set.
- The checked Lean 4 statements match the Lean 3 endpoint shapes.
- The checked cardinal-comparison predicates preserve the Lean 3 argument
  order and polarity.
- The suspicious omega-to-aleph1 collapse contradiction is now isolated as
  `no_pset_surj_omega_aleph_one`.

The remaining higher-value work is to expand `StatementShape.lean` with
additional guard examples for formula-realization lemmas, if we want CI-style
protection against accidental orientation changes.
