# Erdős Problem #501 in Lean 4

[![CI](https://github.com/elliotglazer/erdos501/actions/workflows/ci.yml/badge.svg)](https://github.com/elliotglazer/erdos501/actions/workflows/ci.yml)

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
1972), while adding `𝔠⁺` random reals gives a positive answer (E. Glazer, Sol, 2026;
see `docs/paper/`).  Both directions are formalized, and the independence is
stated in Mathlib's own first-order logic (`Mathlib.ModelTheory`): the theory
`ZFC` and the sentence `Erdos501` ("every complete ordered field has the Erdős
property") are defined in [`Challenge.lean`](Challenge.lean), which imports
Mathlib only, and the targets

```
erdos501_not_provable  : ¬ (ZFC ⊨ᵇ Erdos501)     -- some model of ZFC satisfies ¬Erdos501
erdos501_not_refutable : ¬ (ZFC ⊨ᵇ ∼Erdos501)    -- some model of ZFC satisfies Erdos501
erdos501_independent   : both
```

are proved from the standard axioms.  A seventh target certifies that the
rendering is faithful: in Mathlib's `ZFSet`, `Erdos501` is equivalent to the
Mathlib statement of the first question (verbatim the proposition of
`google-deepmind/formal-conjectures`).  As far as we know this is the first
Erdős problem whose resolution is a formally verified independence result: in
the erdosproblems.com database (`teorth/erdosproblems`, `data/problems.yaml`,
1217 problems, snapshot of 2026‑08‑17) #1119, #1123 and #1127 are marked
"independent", #474/#736/#739 "not provable" and #1154/#1169/#1174/#1176 "not
disprovable", all with `formal_status: unformalized`; #501 is listed as open
(with its statement formalized in `formal-conjectures`).

The repository is laid out as a **comparator challenge**
([leanprover/comparator](https://github.com/leanprover/comparator)) following the
[Palomar registry](https://palomar-registry.org/how-to-submit) conventions:
trusted statements in [`Challenge.lean`](Challenge.lean) (Mathlib only), proofs in
[`Solution.lean`](Solution.lean), judged by [`comparator.json`](comparator.json);
metadata in [`formalization.yaml`](formalization.yaml).  A second pair
[`ChallengeFlypitch.lean`](ChallengeFlypitch.lean) / [`SolutionFlypitch.lean`](SolutionFlypitch.lean)
/ [`comparator-flypitch.json`](comparator-flypitch.json) states the same results
in the proof-theoretic terms of the vendored Flypitch development
(`independent ZFC Erdos501_f`, i.e. `¬ (ZFC ⊢ₛ' Erdos501_f) ∧ ¬ (ZFC ⊢ₛ' ∼Erdos501_f)`,
the exact shape of Flypitch's `independence_of_CH`).  Both pass the comparator
(`docs/COMPARATOR.md`).  See [`docs/STATUS.md`](docs/STATUS.md) for the map of
the proof.

## Background and discussion

**Result** (E. Glazer and Sol, 2026): the first question is *independent of ZFC*
— both answers are relatively consistent with ZFC — and the second question has
a positive resolution; all of it is formalized in Lean and checked by the
comparator (the seven targets below).

The problem was already mostly resolved: Newelski–Pawlikowski–Seredyński had
positively resolved the second question, Hechler had shown the consistency of a
negative answer to the first, and Sungchul Lee had shown that a positive answer
to the first follows from a real‑valued measurable (RVM) cardinal (equiconsistent
with a measurable cardinal).  It remained to drop the large‑cardinal hypothesis:
it is routine to transfer reasonably combinatorial `Π²₁` consequences of an RVM
to the extension of an arbitrary model of `CH` by `ω₂` random reals, and applying
that standard technology gives the positive answer with no large cardinals — so
neither truth value adds consistency strength.  That transfer is the argument in
[`docs/paper/`](docs/paper/), and it is what this repository formalizes, together
with Hechler's counterexample and the Newelski–Pawlikowski–Seredyński closed case.

The discussion is on the [erdosproblems.com forum thread for
#501](https://www.erdosproblems.com/forum/thread/501) (Sungchul Lee's relative
result, assisted by GPT‑5.5 Pro; Nat Sothanaphan's independence observation; and
the transfer to random reals), and the full claim is recorded on Elliot Glazer's
[proof‑claims page](https://www.erdosproblems.com/forum/user/ElliotGlazer/proof-claims).

## The seven targets (`Challenge.lean`, `comparator.json`)

| target | statement | proof |
|---|---|---|
| `erdos501_closed_infinite` | closed `A_x` of measure `< 1` ⇒ infinite independent set | `Erdos501/Closed.lean` (NPS87) |
| `erdos501_closed_size3` | closed `A_x` of measure `< 1` ⇒ independent set of size 3 (`3 ≤ X.ncard`) | `Erdos501/Closed.lean` |
| `erdos501_hechler_of_CH` | `ℵ₁ = 𝔠` ⇒ a family of bounded sets of outer measure `< 1` with no infinite independent set | `Erdos501/Hechler.lean` (Hechler 1972) |
| `erdos501_not_refutable` | `¬ (ZFC ⊨ᵇ ∼Erdos501)` — `𝔠⁺` random reals force `Erdos501` | `Erdos501/FOL/Independence.lean` ← `Flypitch4/Erdos501/Main.lean` |
| `erdos501_not_provable` | `¬ (ZFC ⊨ᵇ Erdos501)` — Hechler in the collapse extension, where `CH` holds | `Erdos501/FOL/Independence.lean` ← `Flypitch4/Erdos501/Hechler.lean` |
| `erdos501_independent` | the two above | `Erdos501/FOL/Independence.lean` |
| `erdos501_sentence_faithful` | `(ZFSet ⊨ Erdos501) ↔` the Mathlib statement of the first question | `Erdos501/FOL/Sentence.lean` ← `Flypitch4/Erdos501/Bridge.lean` |

Every target depends only on `propext`, `Classical.choice`, `Quot.sound`
(`docs/audits/2026-08-19-axiom-audit-targets-355bc1e.txt`); no declaration in
the repository depends on `sorryAx` — the only `sorry`s are the statements of the
two Challenge files.  The proofs are pure Lean; no `native_decide`, no extra axioms.

## How to read the Challenge

`Challenge.lean` has two parts.  **Part A** is a sequence of *definitions*
(no proofs): the language `L` of set theory (`∅, ω, 𝒫, ⋃, (·,·), ∈`), the theory
`ZFC : L.Theory` — Flypitch's axiomatization (extensionality, empty set, ordered
pairs, union, power set, infinity, regularity, Zorn's lemma, and the strong
collection scheme), which is equivalent to the usual ZFC — the sentence
`Erdos501 : L.Sentence`, and the standard `L`-structure `zfsetStructure` on
Mathlib's `ZFSet`.  Formulas are written with depth-polymorphic combinators
(`allF fun x => …` binds a variable and hands its de Bruijn *level* to the body),
so that the sentence can be read like ordinary set theory; the only explicit
variable arithmetic is in `collectionAxiom`, whose docstring lists the levels.
**Part B** states the seven targets with `sorry`.  Independence is stated
semantically with Mathlib's `Theory.ModelsBoundedFormula` (`⊨ᵇ`), which is
Mathlib's notion of first-order consequence (Mathlib has no proof calculus); by
Gödel's completeness theorem `¬ (ZFC ⊨ᵇ φ)` is the same as `¬ (ZFC ⊢ φ)`, and the
underlying Flypitch results are indeed the syntactic ones (second challenge pair).

What a referee has to check by hand is therefore: that `ZFC` is ZFC, that
`Erdos501` says "every complete ordered field has the Erdős property" (target 7
reduces this to the audit of `zfsetStructure` and of the Mathlib-level statement),
and that the Mathlib-level statements are the two questions of #501.  The header
of `Challenge.lean` and `docs/COMPARATOR.md` spell out these points, the
conventions (`CH` as `ℵ₁ = 𝔠`, "size 3" as `3 ≤ X.ncard`, "outer measure `< 1`"
inside the sentence as a countable open-interval cover of total length `< 1`) and
the limitations.

## How the proof goes

* **Closed case** (`Erdos501/Closed.lean`): NPS87's argument at Mathlib level.
* **Hechler under CH** (`Erdos501/Hechler.lean`): from `ℵ₁ = 𝔠`, a family of
  countable null sets with no infinite independent set — a theorem of ZFC.
* **Forcing** (`Flypitch4/Erdos501/`, namespace `Flypitch.Erdos501`), in the
  Boolean-valued universe `V 𝔹` of the vendored Lean 4 port of Flypitch
  (Han–van Doorn's framework for the independence of CH):
  the `L_ZFC`-sentence `Erdos501_f` is forced by the random algebra with `𝔠⁺`
  coordinates (`erdos501_of_random`; the paper's Δ-system, homogeneous reading,
  fullness of the fresh profiles, and the ZFC core "certificate ⇒ infinite
  independent set", transferred into `V 𝔹` through internal complete ordered
  fields), so `¬ (ZFC ⊢ₛ' ∼Erdos501_f)` by Boolean-valued soundness; its negation
  is forced by the collapse algebra `Col(ω₁, 𝒫(ω))` (Hechler's construction inside
  `V 𝔹_collapse`, where `CH` holds), so `¬ (ZFC ⊢ₛ' Erdos501_f)`.
* **Faithfulness** (`Flypitch4/Erdos501/{StdSemantics,RealsInZFSet,ZFSetCOF,Bridge}.lean`):
  in the standard `ZFSet` structure, `Erdos501_f` ↔ the Mathlib statement.
* **Bridge to Mathlib's first-order logic** (`Erdos501/FOL/`): the Challenge's
  `L`, `ZFC`, `Erdos501` are translated to Flypitch's (`tr`, de Bruijn levels ↦
  indices); the translation preserves realization (`realize_tr`), the eight fixed
  axioms and the sentence translate to Flypitch's *by definitional unfolding*
  (`tr_Erdos501 : tr Erdos501 = Erdos501_f := rfl`), the strong collection scheme is
  transferred semantically (`Collection.lean`), so every Flypitch model of ZFC is a
  model of the Challenge's `ZFC` (`toM_models_ZFC`).  Flypitch's completeness theorem
  turns unprovability into two-valued models, and Mathlib's `Theory.Model.isSatisfiable`
  (Löwenheim–Skolem) and `models_iff_not_satisfiable` give `¬ (ZFC ⊨ᵇ ·)`.

## Layout

```
Challenge.lean, Solution.lean, comparator.json                 the comparator challenge (Mathlib-only Challenge)
ChallengeFlypitch.lean, SolutionFlypitch.lean, comparator-flypitch.json
                                                               the same results in Flypitch's terms
formalization.yaml               metadata (mathlib-initiative formalization.yaml v0.4 / Palomar)
Erdos501.lean, Erdos501/         the Mathlib-level development
  Closed.lean                      NPS87 (second question)
  Hechler.lean                     CH ⇒ ¬P
  ZFCCore/                         Lemma 2.1/2.2, Def. 3.1, Thm 3.2 of the paper (ZFC, no forcing)
  Independence.lean                assembly of `independent ZFC Erdos501_f` (Flypitch's terms)
  FOL/                             bridge to Mathlib's ModelTheory:
    Statement.lean                   Part A of Challenge.lean, verbatim (generated by scripts/sync-statement.py)
    Translate.lean                   `tr`, `toM`, `realize_tr`
    FolLemmas.lean                   two-valued lift/substitution lemmas for Flypitch formulas
    Collection.lean                  the strong collection scheme on both sides
    Axioms.lean                      `toM_models_ZFC`
    Sentence.lean                    `tr_Erdos501 := rfl`, `zfsetStructure = toM stdStructure`, faithfulness
    Independence.lean                `¬ (ZFC ⊨ᵇ Erdos501)`, `¬ (ZFC ⊨ᵇ ∼Erdos501)`
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
    OmegaClosed, CheckReals,         the other direction: ω-closed refinement, the check-name reals as an
    Hechler                          internal complete ordered field, Hechler's family in V^{𝔹_collapse}:
                                     `neg_erdos501_forced_collapse`, `Erdos501_f_unprovable`,
                                     `independence_of_Erdos501`
    ColRandom                        `RandomIndex` (𝔠⁺), `𝔹_random_succ_continuum`; the paper's Col × Random
                                     algebra (definition only, for reference)
third_party/flypitch4/           upstream license, README, validation notes, audit at 83a5988
validation/                      `#print axioms` scripts (AxiomAudit: targets; Erdos501Audit: forcing tree)
scripts/                         install/run comparator, axiom audit, Challenge/Statement sync
docs/                            STATUS, PROVENANCE, COMPARATOR, PORTING-NOTES, audits/, paper/
```

## Building

```sh
# Lean v4.34.0-rc1, Mathlib 355bc1e (see lean-toolchain / lake-manifest.json)
lake exe cache get
lake build                       # Flypitch4, Erdos501, both Challenge/Solution pairs
scripts/check-axioms.sh          # axioms of every target (sorryAx = not closed)
scripts/sync-statement.py --check  # Challenge.lean Part A == Erdos501/FOL/Statement.lean
scripts/install-comparator-tools.sh && export PATH="$PWD/.tools/bin:$PATH"
scripts/run-comparator.sh comparator.json            # "Your solution is okay!"
scripts/run-comparator.sh comparator-flypitch.json
```

## Provenance and process

This work was directed by Elliot Glazer.  The mathematical argument of the
positive direction — transferring the real‑valued‑measurable consequence to the
`ω₂`‑random‑reals extension of a model of `CH` (`docs/paper/`) — was produced with
GPT‑5.6 ("Sol"); every line of Lean in this repository was written by Claude
(Anthropic) — Fable 5 and Opus 4.8 — in the claude.ai project "Formalizing Erdős
501", following the route (Flypitch's Boolean‑valued models; the Mathlib
`ModelTheory` statement) chosen with the author, who reviewed the statements.  See
`formalization.yaml` (`automation`, `review`) and `docs/PROVENANCE.md` for the
origin of each component and the pins it was verified at.  Mechanical checks
(build, axiom audits, comparator on both configurations) run in CI.

## Mathematical sources

* P. Erdős, *Some unsolved problems*, Magyar Tud. Akad. Mat. Kutató Int. Közl. 6 (1961), 221–254 (Problem II.9).
* P. Erdős, A. Hajnal, *Unsolved problems in set theory*, Proc. Sympos. Pure Math. XIII/1 (1971), 17–48 (Problem 38).
* P. Erdős, A. Hajnal, *Some remarks on set theory VIII*, Michigan Math. J. 7 (1960), 187–191 (arbitrarily large finite independent sets).
* S. H. Hechler, *Directed graphs over topological spaces: some set theoretical aspects*, Israel J. Math. 11 (1972), 231–248 (CH counterexample).
* L. Newelski, J. Pawlikowski, W. Seredyński, *Infinite free set for small measure set mappings*, Proc. AMS 100 (1987), 335–339 (closed case).
* E. Glazer, Sol, *Erdős Problem 501 after adding ω₂ random reals* (2026), `docs/paper/erdos501_random_profiles_rev10.pdf`.
* J. M. Han, F. van Doorn, *A formal proof of the independence of the continuum hypothesis*, CPP 2020 (Flypitch).

## License

Apache License 2.0 (see `LICENSE`).  The `Flypitch4` library is derived from
Flypitch (Copyright 2019 The Flypitch Project, Apache 2.0) and its Lean 4 port
by Ian Klatzco (Apache 2.0); see `NOTICE` and `third_party/flypitch4/`.
Statement shapes follow `google-deepmind/formal-conjectures` (Apache 2.0).
