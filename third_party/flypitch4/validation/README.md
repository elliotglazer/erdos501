# Flypitch4 Validation

This directory collects validation notes for the Lean 4 `flypitch4` port.

The top-level `../VALIDATION.md` records the mechanical audit: build status,
axiom output, proof-hole search, and the committed cleanup of the collapse-side
nonsurjection proof.

The notes here focus on mathematical validation: whether the formal objects
match the intended CH-independence argument, where a port could accidentally
weaken the theorem, and which proof bridges deserve the most scrutiny.

## Notes

- `axiom-audit.md`: reusable `#print axioms` audit for the final theorem and
  intermediate CH/forcing endpoints.
- `mathematical-audit.md`: math-facing audit of the theorem path, CH statement,
  forcing endpoints, and the collapse-side object bridge.
- `predicate-comparison.md`: deeper comparison of the cardinal-comparison
  predicates and formula-realization lemmas.
- `statement-comparison.md`: targeted Lean 3 to Lean 4 statement comparison
  for the CH endpoints and reflection/collapse bridge.
- `AxiomAudit.lean`: Lean script backing `axiom-audit.md`.
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
