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
1972), while adding `ω₂` random reals to a model of `CH` gives a positive answer
(E. Glazer, 2026; see `docs/paper/`).  The negative direction is formalized at
Mathlib level; the independence statement itself is formalized in the language
of Flypitch (first-order `ZFC`, Boolean-valued models) and is the open part of
this repository — see [`docs/STATUS.md`](docs/STATUS.md).

The repository is laid out as a **comparator challenge**
([leanprover/comparator](https://github.com/leanprover/comparator)): the trusted
statements are in [`Challenge.lean`](Challenge.lean), the proofs in
[`Solution.lean`](Solution.lean), and `config.json` / `config-zfc.json` drive
the judge.  See [`docs/COMPARATOR.md`](docs/COMPARATOR.md).

## The five targets

| target | statement (informal) | status |
|---|---|---|
| `erdos501_closed_infinite` | closed `A_x` of measure `< 1` ⇒ infinite independent set | proved (`Erdos501/Closed.lean`) |
| `erdos501_closed_size3` | closed `A_x` of measure `< 1` ⇒ independent set of size 3 | proved (`Erdos501/Closed.lean`) |
| `erdos501_hechler_of_CH` | `ℵ₁ = 𝔠` ⇒ a family of bounded null sets with no infinite independent set | proved (`Erdos501/Hechler.lean`) |
| `erdos501_independent` | `independent ZFC Erdos501_f` | **open** (units H3, F3, F5, F6, F7 in `docs/STATUS.md`) |
| `erdos501_sentence_faithful` | `stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind` | **open** |

`config-zfc.json` lists the first three and **passes the comparator** (see
`docs/COMPARATOR.md`); `config.json` lists all five and is the open target.

## Layout

```
Challenge.lean, Solution.lean, config.json, config-zfc.json   comparator challenge
Erdos501.lean, Erdos501/         the development
  Closed.lean                      NPS87 (second question)
  Hechler.lean                     CH ⇒ ¬P
  ZFCCore/                         Lemma 2.1/2.2, Def. 3.1, Thm 3.2 of the paper (ZFC, no forcing)
  Sentence.lean, Bridge.lean       first-order rendering of P; standard interpretation in ZFSet
  Forcing/                         countable-support/Borel reading, homogeneous reading, Δ-system,
                                   Col(ω₁,ℝ) × (𝔠⁺ random reals) Boolean algebra
  Independence.lean                assembly of `independent ZFC Erdos501_f`
Flypitch4.lean, Flypitch4/       vendored Lean 4 port of Flypitch (Han–van Doorn; port by
                                 I. Klatzco + Claude), plus measure/random-algebra additions
third_party/flypitch4/           upstream license, README, validation notes
validation/AxiomAudit.lean       `#print axioms` of all targets
scripts/                         install/run comparator, axiom audit
docs/                            STATUS, PROVENANCE, COMPARATOR, audits/, paper/
```

## Building

```sh
# Lean v4.34.0-rc1, Mathlib 355bc1e (see lean-toolchain / lake-manifest.json)
lake exe cache get
lake build                       # Flypitch4, Erdos501, Challenge, Solution
scripts/check-axioms.sh          # axioms of every target (sorryAx = not closed)
```

The proofs are pure Lean; no `native_decide`, no extra axioms.  Files that
depend on `sorry` are exactly the open targets and their supporting units.

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
