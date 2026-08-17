# Erdős Problem #501 in Lean 4

Formalization of both questions of [Erdős problem #501](https://www.erdosproblems.com/501)
(Erdős 1961, Problem II.9; Erdős–Hajnal 1971, Problem 38 (B)/(C)):

> For every `x ∈ ℝ` let `A_x ⊂ ℝ` be a bounded set with outer measure `< 1`.
> Must there exist an infinite independent set, i.e. an infinite `X ⊆ ℝ` with
> `x ∉ A_y` for all distinct `x, y ∈ X`?
> If the sets `A_x` are closed and of measure `< 1`, must there exist an
> independent set of size `3`?

**Second question — yes**, even an infinite independent set exists
(Newelski–Pawlikowski–Seredyński 1987; formalized here without any boundedness
hypothesis).
**First question — independent of ZFC**: `CH` gives a counterexample (Hechler
1972), while adding `𝔠⁺` random reals gives a positive answer (E. Glazer, 2026;
see `docs/paper/`).  Both are formalized here: Hechler's counterexample at
Mathlib level, and the consistency of a positive answer in the language of
Flypitch (first-order `ZFC`, Boolean-valued models): the sentence `Erdos501_f`
is forced by the random algebra with `𝔠⁺` coordinates, so
`¬ (ZFC ⊢ₛ' ∼Erdos501_f)`, and `Erdos501_f` is faithful (in the standard
`ZFSet` interpretation it is equivalent to the Mathlib statement).  The one
remaining piece is the *first-order* form of the negative direction,
`¬ (ZFC ⊢ₛ' Erdos501_f)` (Hechler's construction inside the Boolean-valued
collapse extension, where `CH` holds) — see [`docs/STATUS.md`](docs/STATUS.md).

The repository is laid out as a **comparator challenge**
([leanprover/comparator](https://github.com/leanprover/comparator)): the trusted
statements are in [`Challenge.lean`](Challenge.lean), the proofs in
[`Solution.lean`](Solution.lean), and `config.json` / `config-proved.json` drive
the judge.  See [`docs/COMPARATOR.md`](docs/COMPARATOR.md).

## The seven targets

| target | statement (informal) | status |
|---|---|---|
| `erdos501_closed_infinite` | closed `A_x` of measure `< 1` ⇒ infinite independent set | proved (`Erdos501/Closed.lean`) |
| `erdos501_closed_size3` | closed `A_x` of measure `< 1` ⇒ independent set of size 3 | proved (`Erdos501/Closed.lean`) |
| `erdos501_hechler_of_CH` | `ℵ₁ = 𝔠` ⇒ a family of bounded null sets with no infinite independent set | proved (`Erdos501/Hechler.lean`) |
| `erdos501_not_refutable` | `¬ (ZFC ⊢ₛ' ∼Erdos501_f)` — `𝔠⁺` random reals force `Erdos501_f` | proved (`Flypitch4/Erdos501/Main.lean`) |
| `erdos501_not_provable` | `¬ (ZFC ⊢ₛ' Erdos501_f)` — Hechler in the collapse extension | **open** (unit H3 in `docs/STATUS.md`) |
| `erdos501_independent` | `independent ZFC Erdos501_f` (the two above) | open in the `not_provable` component |
| `erdos501_sentence_faithful` | `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` | proved (`Flypitch4/Erdos501/Bridge.lean`) |

`config-proved.json` lists the five proved targets and **passes the comparator**
(see `docs/COMPARATOR.md`); `config.json` lists all seven and is the open target.

## Layout

```
Challenge.lean, Solution.lean, config.json, config-proved.json   comparator challenge
Erdos501.lean, Erdos501/         the Mathlib-level development
  Closed.lean                      NPS87 (second question)
  Hechler.lean                     CH ⇒ ¬P
  ZFCCore/                         Lemma 2.1/2.2, Def. 3.1, Thm 3.2 of the paper (ZFC, no forcing)
  Independence.lean                assembly of `independent ZFC Erdos501_f` (one `sorry`: unit H3)
Flypitch4.lean, Flypitch4/       vendored Lean 4 port of Flypitch (Han–van Doorn; port by
                                 I. Klatzco + Claude), plus
  MeasureAlgebra, RandomAlgebra,   measure algebras, the random algebra, ¬CH via random reals
  ForcingRandom, SummaryRandom
  Erdos501/                        the forcing development for #501 (namespace `Flypitch.Erdos501`):
    Sentence, Semantics,             `Erdos501_f` and its Boolean value
    StdSemantics, RealsInZFSet,      the standard interpretation and the bridge (`stdStructure_realize_Erdos501_f_iff`)
    ZFSetCOF, Bridge
    RandomForcing, DeltaSystem,      units F3–F5 (Borel reading, Δ-system, homogeneous reading, fullness)
    HomogeneousReading, BorelNames
    ZFCCore, BinaryExpansion,        units F6–F8: the certificate inside V^𝔹, internal reals,
    InternalReals, RealReading,      envelopes, selection, recursion, assembly, internal fields ≅ Rdot
    Envelopes, Selection, Recursion,
    Assembly, InternalField,
    InternalIso, Transfer
    Main                             `erdos501_of_random`, `neg_Erdos501_f_unprovable`
    ColRandom                        the literal Col × Random algebra (statement only, off-route)
third_party/flypitch4/           upstream license, README, validation notes, audit at 83a5988
validation/                      `#print axioms` scripts (AxiomAudit: targets; Erdos501Audit: forcing tree)
scripts/                         install/run comparator, axiom audit
docs/                            STATUS, PROVENANCE, COMPARATOR, PORTING-NOTES, audits/, paper/
```

## Building

```sh
# Lean v4.34.0-rc1, Mathlib 355bc1e (see lean-toolchain / lake-manifest.json)
lake exe cache get
lake build                       # Flypitch4, Erdos501, Challenge, Solution
scripts/check-axioms.sh          # axioms of every target (sorryAx = not closed)
```

The proofs are pure Lean; no `native_decide`, no extra axioms.  The
declarations depending on `sorry` are exactly `Erdos501.erdos501_f_unprovable`
(unit H3, hence `erdos501_not_provable` and `erdos501_independent`) and the
off-route assertion `Flypitch.Erdos501.erdos501_of_col_random`.

## Mathematical sources

* P. Erdős, *Some unsolved problems*, Magyar Tud. Akad. Mat. Kutató Int. Közl. 6 (1961), 221–254 (Problem II.9).
* P. Erdős, A. Hajnal, *Unsolved problems in set theory*, Proc. Sympos. Pure Math. XIII/1 (1971), 17–48 (Problem 38).
* P. Erdős, A. Hajnal, *Some remarks on set theory VIII*, Michigan Math. J. 7 (1960), 187–191 (arbitrarily large finite independent sets).
* S. H. Hechler, *Directed graphs over topological spaces: some set theoretical aspects*, Israel J. Math. 11 (1972), 231–248 (CH counterexample).
* L. Newelski, J. Pawlikowski, W. Seredyński, *Infinite free set for small measure set mappings*, Proc. AMS 100 (1987), 335–339 (closed case).
* E. Glazer, *Erdős Problem 501 after adding ω₂ random reals* (2026), `docs/paper/erdos501_random_profiles_rev10.pdf`.
* J. M. Han, F. van Doorn, *A formal proof of the independence of the continuum hypothesis*, CPP 2020 (Flypitch).

## License

Apache License 2.0 (see `LICENSE`).  The `Flypitch4` library is derived from
Flypitch (Copyright 2019 The Flypitch Project, Apache 2.0) and its Lean 4 port
by Ian Klatzco (Apache 2.0); see `NOTICE` and `third_party/flypitch4/`.
Statement shapes follow `google-deepmind/formal-conjectures` (Apache 2.0).
