# Flypitch4 Port Validation Notes

This records the validation work performed on the Lean 4 `flypitch4` port,
with particular attention to whether the CH independence result was backed by
real Lean proof terms or by hidden stubs deeper in the object tree.

For a more mathematical audit of the theorem path and the collapse-side object
bridge, see `validation/mathematical-audit.md`.

## Scope

The main theorem checked was:

```lean
theorem independence_of_CH : independent ZFC CH_f
```

The review followed the path from the final theorem down through the main
semantic and forcing layers:

- `SentTheory`, `ssatisfied`, `forced_in`, `ZFC`, and `CH_f`
- the Boolean-valued model definitions around `bSet`
- the `check` bridge from ground-model `PSet` objects into Boolean-valued names
- the Cohen and collapse forcing endpoints used for the two consistency sides
- the sensitive collapse-side reflection argument in `ForcingCH.lean`

## Mechanical Checks

The port was built with:

```sh
cd flypitch4
lake build
```

That completed successfully.

The final theorem's axiom dependencies were checked with Lean using:

```lean
#print axioms independence_of_CH
```

Lean reported only the expected foundational dependencies:

```text
[propext, Classical.choice, Quot.sound]
```

No additional project axioms showed up in the final theorem.

We also searched for active proof holes:

```sh
rg -n "sorry|admit" flypitch4/Flypitch4 flypitch4
```

The relevant imported `.lean` files did not contain active `sorry` or `admit`
terms on the path to `independence_of_CH`. The search did find comment-only
references and an untracked backup file, `Flypitch4/BvmExtras2.lean.bak`, which
contains old `sorry` text but is not part of the build.

## Manual Audit Points

The high-level theorem in `Summary.lean` was checked to make sure it is composed
from the intended CH and not-CH forcing results rather than from an axiom.

The definitions of satisfaction, set theory, and CH were inspected to confirm
that the final theorem is about the intended objects:

- `independent ZFC CH_f`
- `ZFC` as the set-theoretic theory being modeled
- `CH_f` as the formal continuum hypothesis statement
- semantic satisfaction through the model machinery rather than a direct axiom

The Boolean-valued forcing path was then followed into the named endpoints. The
critical concern was not just that the theorem builds, but that the object-level
bridges do not silently replace a difficult statement with an assumption.

## Deeper Collapse Check

The most sensitive area found was in:

```text
Flypitch4/ForcingCH.lean
```

Two lemmas used the same nontrivial contradiction:

- `surjection_reflect`
- `omega_lt_aleph_one_collapse`

Both needed to rule out a reflected ground-model surjection from `PSet.omega`
onto `pSet_aleph1`. Inline duplicated proofs made this harder to audit, and the
comments around one copy still referred to an earlier universe-workaround
approach.

That proof was factored into:

```lean
lemma no_pset_surj_omega_aleph_one {h : PSet.{u}}
    (hh_func : PSet.is_func PSet.omega pSet_aleph1 h) :
    Not (PSet.is_surj PSet.omega pSet_aleph1 h)
```

The lemma proves that any `PSet` function from omega to aleph1 cannot be
surjective. The argument extracts a type-level surjection from a hypothetical
`PSet.is_surj`, obtains:

```lean
#(pSet_aleph1.Type) <= #(PSet.omega.Type)
```

and contradicts the established cardinal inequality:

```lean
PSet.omega_lt_aleph_one
```

Both call sites now use this shared lemma directly:

```lean
have hh_not_surj : Not (PSet.is_surj PSet.omega pSet_aleph1 h) :=
  no_pset_surj_omega_aleph_one hh_func
```

This makes the collapse-side contradiction explicit and reusable instead of
buried twice inside larger forcing proofs.

After that change, the affected target was rebuilt with:

```sh
cd flypitch4
lake build Flypitch4.ForcingCH
```

That completed successfully. The build reported existing linter warnings in
the project, but no Lean errors.

The proof factoring was committed and pushed as:

```text
8596072 Factor omega to aleph one nonsurjection proof
```

## Conclusion

The validation did not find an active hidden `sorry`, `admit`, or project axiom
behind `independence_of_CH`. The final theorem depends only on Lean's expected
classical/foundational axioms reported by `#print axioms`.

The deepest suspicious point found during the audit was the collapse-side
omega-to-aleph1 nonsurjection contradiction. That was strengthened from a pair
of duplicated inline proofs into the named lemma
`no_pset_surj_omega_aleph_one`, and the relevant target still builds.

This is a port-integrity validation, not a full mathematical re-review of every
lemma in the development. It gives evidence that the Lean 4 port is connected
through real compiled proof terms at the checked endpoints and that the most
suspicious deeper object-level bridge has been made auditable.
