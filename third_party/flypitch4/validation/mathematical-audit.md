# Mathematical Audit Of The Flypitch4 CH Port

This note focuses on the mathematical risks in the Lean 4 port, rather than the
basic mechanics of whether the project builds.

The working question was:

> Is the Lean 4 `independence_of_CH` theorem still proving the intended CH
> independence result, or could something have been weakened or hidden deeper in
> the object tree?

## What Would Count As A Bad Port

A successful build is not enough. The important mathematical failure modes are:

- The final theorem has the right name but a weaker statement.
- `ZFC` or `CH_f` no longer denotes the intended set-theoretic objects.
- Semantic satisfaction is bypassed or weakened.
- A forcing endpoint proves a weaker Boolean-valued statement than intended.
- The `check` bridge from ground-model `PSet` objects into `bSet` names loses
  the statement being reflected.
- A difficult cardinal contradiction is replaced by a hidden assumption.

The audit concentrated on those risks.

## Final Theorem Shape

The final theorem is in `Flypitch4/Summary.lean`. Schematically:

```text
def independent {L : Language} (T : SentTheory L) (f : sentence L) : Prop :=
  not_provable T f and not_provable T (not f)

theorem independence_of_CH : independent ZFC CH_f :=
  ...
```

In the source, this uses the project's Lean notation for syntactic provability.
Mathematically, the theorem states the expected two-sided independence result:

- CH is not provable from ZFC.
- Not-CH is not provable from ZFC.

The theorem is assembled from:

- `CH_unprovable`
- `neg_CH_unprovable`

The theorem is therefore only as strong as those two forcing endpoints and the
definitions of `ZFC`, `CH_f`, and provability.

## Semantic Layer

The semantic consequence relation is in `Flypitch4/Fol.lean`. Schematically:

```text
def ssatisfied (T : SentTheory L) (f : sentence L) : Prop :=
  forall {S : Structure L}, Nonempty S -> all_realize_sentence S T -> S models f
```

The important point is that `ssatisfied` quantifies over nonempty first-order
structures satisfying all sentences of the theory. The port also proves the
bridge:

```text
ssatisfied T f <-> T.fst semantically_entails f.fst
```

This is the expected semantic layer for the completeness and unprovability
arguments. The audit did not find a replacement of semantic consequence by an
axiom or an empty condition.

## ZFC And CH Objects

The ZFC theory is in `Flypitch4/Zfc.lean`. Schematically:

```text
def ZFC : SentTheory L_ZFC :=
  {emptyset, ordered_pairs, extensionality, union, powerset, infinity,
   regularity, zorns_lemma}
  union collection_schema
```

This matches the expected shape of the development: finite named axioms plus
the collection schema.

The CH sentence is also in `Flypitch4/Zfc.lean`:

```lean
def CH_f : sentence L_ZFC := ...
```

It is connected to the Boolean-valued CH object by a lemma of this shape:

```text
lemma CH_f_is_CH : boolean_value_of CH_f = CH2
```

The key mathematical point is that `CH_f` is not just a placeholder sentence.
It is connected by simplification lemmas to the Boolean-valued cardinal
comparison used by the forcing argument.

## Boolean-Valued Forcing Layer

The Boolean-valued forcing relation is in `Flypitch4/Bfol.lean`. Schematically:

```text
def forced_in (x : beta) (S : bStructure L beta) (f : sentence L) : Prop :=
  x <= boolean_value_of f in S

def all_forced_in (x : beta) (S : bStructure L beta) (T : SentTheory L) : Prop :=
  x <= infimum of all boolean values of sentences in T
```

This is the expected Boolean-valued semantics shape: a Boolean condition forces
a sentence when it is below the Boolean truth value of that sentence.

The forcing theorem for ZFC has this mathematical shape:

```text
theorem bSet_models_ZFC : top forces_all ZFC
```

In `Summary.lean`, this is exposed as:

```text
theorem fundamental_theorem_of_forcing :
    top forces_all ZFC
```

This gives the model-theoretic consistency side used by the independence
argument.

## CH Endpoint Shape

The two theorem endpoints in `Summary.lean` have this mathematical shape:

```text
theorem CH_unprovable : CH is not provable from ZFC
theorem neg_CH_unprovable : not-CH is not provable from ZFC
```

These are the correct endpoints for independence. The mathematical audit then
looked deeper to see whether the forcing arguments behind them were proving
real CH and not-CH behavior, rather than a weakened formal statement.

## The Critical Collapse-Side Bridge

The highest-risk place found was in `Flypitch4/ForcingCH.lean`.

The collapse argument needs to rule out a ground-model surjection:

```lean
PSet.omega -> pSet_aleph1
```

The suspicious part was not the final theorem statement. It was the object
bridge:

1. Start with a Boolean-valued statement that a function is surjective.
2. Reflect that Boolean-valued function back to a checked ground-model `PSet`
   function.
3. Use cardinality to show no such ground-model surjection exists.

The two relevant lemmas are:

```lean
surjection_reflect
omega_lt_aleph_one_collapse
```

Both used the same contradiction. That contradiction is now factored as:

```lean
lemma no_pset_surj_omega_aleph_one {h : PSet.{u}}
    (hh_func : PSet.is_func PSet.omega pSet_aleph1 h) :
    Not (PSet.is_surj PSet.omega pSet_aleph1 h)
```

Mathematically, this lemma says:

> If `h` is a `PSet` function from omega to aleph1, then `h` cannot be
> surjective.

The proof pattern is:

1. Assume `PSet.is_surj PSet.omega pSet_aleph1 h`.
2. Use functionality to choose a unique output in `pSet_aleph1` for each input
   in `PSet.omega`.
3. Build a type-level function:

   ```lean
   G : PSet.omega.Type -> pSet_aleph1.Type
   ```

4. Use `PSet.is_surj` to prove `G` is type-level surjective.
5. Convert that surjection into a cardinal inequality:

   ```lean
   #(pSet_aleph1.Type) <= #(PSet.omega.Type)
   ```

6. Rewrite the two sides to aleph1 and aleph0.
7. Contradict:

   ```lean
   PSet.omega_lt_aleph_one
   ```

This is exactly the cardinal obstruction the collapse argument needs. It is no
longer buried inside larger forcing proofs.

## Why This Matters

The collapse proof is the place where a false or weakened reflection lemma could
make the port look complete while proving too little. The factored lemma makes
the relevant mathematical content explicit:

- the object being reflected is a real `PSet` function,
- the target is the constructed `pSet_aleph1`,
- surjectivity is the actual `PSet.is_surj` predicate,
- the contradiction is cardinal, not assumed.

This reduces the chance that the proof is accidentally using a weaker
statement such as "not this particular encoded function" or "not surjective
under an unrelated predicate."

## Current Mathematical Confidence

The port has good evidence at the checked endpoints:

- The final theorem has the expected independence shape.
- `ZFC` and `CH_f` are connected to the intended first-order and
  Boolean-valued objects.
- The forcing layer uses Boolean truth values and conditions in the expected
  way.
- The most suspicious collapse-side object bridge was made explicit and still
  compiles.
- The final theorem has no unexpected project axioms in `#print axioms`.

The most important remaining caveat is statement equivalence with the Lean 3
source. A Lean 4 theorem can be fully proved and still be the wrong theorem if
one of the ported statements was weakened.

## Follow-Up Checks

A follow-up pass added `statement-comparison.md`, `predicate-comparison.md`,
`axiom-audit.md`, `AxiomAudit.lean`, and `StatementShape.lean`. Those cover
endpoint statement comparison against Lean 3, lower-level predicate orientation,
intermediate axiom profiles, and executable theorem-shape checks.

The next useful checks below that level are:

1. Check that `pSet_aleph1` is definitionally or propositionally tied to
   `PSet.card_ex (Cardinal.aleph 1)` in the expected way.
2. Add more theorem-shape assertions for formula-realization lemmas if future
   CI should guard against orientation drift.

The highest-value mathematical work now is item 1, because the collapse proof
uses `pSet_aleph1` as the named ground-model aleph1 object throughout the
reflection and cardinality arguments.
