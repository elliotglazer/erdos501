/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Erdős Problem #501 — comparator challenge (trusted statements)

This file is the *trusted* half of a comparator challenge
(https://github.com/leanprover/comparator): it states, with `sorry`, exactly
what `Solution.lean` proves.  It imports **Mathlib only**.

## The problem (erdosproblems.com/501)

Erdős (1961), Erdős–Hajnal (1971, Problem 38): for every real `x` let `A x ⊆ ℝ`
be a bounded set of Lebesgue outer measure `< 1`.

* First question: must there be an infinite *independent* set, i.e. an infinite
  `X ⊆ ℝ` with `x ∉ A y` for all distinct `x, y ∈ X`?
* Second question: if the sets `A x` are closed and of measure `< 1`, must
  there be an independent set of size `3`?

The formal shape of the hypotheses follows `google-deepmind/formal-conjectures`
(`FormalConjectures/ErdosProblems/501.lean`): `Bornology.IsBounded (A x)`,
`volume.toOuterMeasure (A x) < 1` (definitionally `volume (A x)`, Lebesgue
*outer* measure on an arbitrary set), independence `X.Pairwise (fun x y => x ∉ A y)`.

## The seven targets

1. `erdos501_closed_infinite` — second question, strong form (Newelski–
   Pawlikowski–Seredyński 1987): closed sets of measure `< 1` admit an
   *infinite* independent set.
2. `erdos501_closed_size3` — second question as asked: an independent set of
   size `3`.
3. `erdos501_hechler_of_CH` — Hechler (1972): under `ℵ₁ = 𝔠` the first question
   has a negative answer (a theorem of ZFC, stated at Mathlib level).
4. `erdos501_not_refutable` — the first question is *consistent with ZFC*: `ZFC`
   does not entail the negation of its first-order rendering `Erdos501`
   (E. Glazer 2026: it holds after adding `𝔠⁺` random reals).
5. `erdos501_not_provable` — its negation is consistent with ZFC: `ZFC` does not
   entail `Erdos501` (Hechler's counterexample under CH, in the collapse
   extension).
6. `erdos501_independent` — 4 ∧ 5: `Erdos501` is *independent of ZFC*.
7. `erdos501_sentence_faithful` — the rendering is faithful: in Mathlib's
   `ZFSet`, `Erdos501` holds iff the Mathlib-level statement of the first
   question holds.

## How independence is stated (Mathlib's `ModelTheory`)

`ZFC` is a first-order theory (`Erdos501.FOL.ZFC`) in the language
`Erdos501.FOL.L` of set theory with the function symbols `∅`, `(·,·)`, `ω`, `𝒫`,
`⋃` and the relation symbol `∈`, and `Erdos501` (`Erdos501.FOL.Erdos501`) is a
sentence of that language.  Independence is stated *semantically*, with
Mathlib's `Theory.ModelsBoundedFormula` (`⊨ᵇ`):
`¬ (ZFC ⊨ᵇ Erdos501)` says that not every model of `ZFC` satisfies `Erdos501`,
i.e. some model of `ZFC` satisfies its negation; `¬ (ZFC ⊨ᵇ ∼Erdos501)` says
that some model satisfies `Erdos501`.  By Gödel's completeness theorem this is
the same as: neither `Erdos501` nor `∼Erdos501` is provable from `ZFC`.
(Mathlib has no proof calculus for first-order logic; the semantic form is the
faithful Mathlib statement.  The proofs in `Solution.lean` come from
Boolean-valued models via the completeness theorem of the Flypitch
development, so they establish unprovability as well.)  `⊨ᵇ` quantifies over
Mathlib's `ModelType`s of `ZFC` with carrier in `Type 0`; by the
Löwenheim–Skolem theorem (Mathlib's `Theory.Model.isSatisfiable`) this is no
restriction — a model in any universe yields one in `Type 0`.

The axioms of `ZFC` are those of Han–van Doorn's Flypitch formalization of
ZFC (the theory in which the independence of CH was verified): extensionality,
empty set, ordered pairs (the pairing symbol is injective), union, power set,
infinity (`ω` is the least inductive ordinal), regularity, Zorn's lemma, and the
*strong collection* scheme.  This axiom system is equivalent to the usual
ZFC (strong collection gives replacement, hence separation and pairing; Zorn's
lemma is equivalent to choice); in particular every model of it is a model of
ZFC, so independence from it is independence from ZFC.

## Reading guide — what a referee has to check by hand

Everything below Part A is a *definition*; the comparator guarantees only that
`Solution.lean` proves *these* statements from the standard axioms.  What the
statements mean is for the reader to check:

* `L`, `Func`, `Rel` — the language;
* the axioms `axiomOfEmptyset, …, zornsLemma`, `collectionAxiom` and the theory
  `ZFC` — that this is (an axiomatization equivalent to) ZFC;
* the sentence `Erdos501` — that it says "every complete ordered field has the
  Erdős property" with the intended meaning of "bounded", "outer measure `< 1`",
  "infinite" and "independent" (the docstrings of the combinators spell out the
  rendering).  Target 7 reduces this audit to the audit of `zfsetStructure` and
  of the Mathlib-level statement: in Mathlib's `ZFSet` the sentence is
  *equivalent* to the `formal-conjectures` proposition;
* `zfsetStructure` — the standard interpretation of the symbols in `ZFSet`
  (`∅`, `ZFSet.omega`, `ZFSet.powerset`, `ZFSet.sUnion`, Kuratowski `ZFSet.pair`, `∈`).

Formulas are written with de Bruijn *levels* through the depth-polymorphic
combinators of Part A (`allF fun x => …` binds a variable and passes its level
to the body); the only place where explicit variable arithmetic occurs is
`collectionAxiom`, whose docstring lists the levels of every variable.

## Limitations and conventions

* Independence is proved for the sentence `Erdos501`, i.e. for the first
  question rendered inside first-order ZFC ("every complete ordered field has
  the Erdős property"); target 7 certifies that this rendering is equivalent,
  in `ZFSet`, to the Mathlib statement.
* `erdos501_hechler_of_CH` takes the continuum hypothesis as `(ℵ₁ : Cardinal.{u}) = 𝔠`.
* `erdos501_closed_size3` states "an independent set of size 3" as
  `3 ≤ X.ncard`; `Set.ncard` is `0` on infinite sets, so this asserts a *finite*
  independent set with at least three elements.  `erdos501_closed_infinite`
  gives the infinite one.
* Outer measure `< 1` is rendered, inside the sentence, as the existence of a
  cover by countably many open intervals of total length `< 1` — the definition
  of Lebesgue outer measure; boundedness as "bounded above and below";
  "infinite" as "`ω` injects into `X`" (equivalent to "not finite" under
  choice, which `ZFC` includes as Zorn's lemma).
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph
import Mathlib.Data.Set.Card
import Mathlib.ModelTheory.Satisfiability
import Mathlib.SetTheory.ZFC.Basic

open MeasureTheory
open scoped Cardinal FirstOrder
open FirstOrder FirstOrder.Language

universe u

/-! ## Part A — the language, the theory `ZFC` and the sentence `Erdos501`

Everything in this part is a *definition* (no proofs); it is repeated verbatim in
`Erdos501/FOL/Statement.lean` so that the comparator can check that the
statements proved in `Solution.lean` are literally these. -/

namespace Erdos501.FOL

/-! ### The language `L` of set theory -/

/-- Function symbols: `∅` (arity 0), `ω` (arity 0), `𝒫` (arity 1), `⋃` (arity 1),
the ordered pair `(·,·)` (arity 2). -/
inductive Func : ℕ → Type
  | emptyset : Func 0
  | omega : Func 0
  | powerset : Func 1
  | union : Func 1
  | pair : Func 2

/-- Relation symbols: `∈` (arity 2). -/
inductive Rel : ℕ → Type
  | mem : Rel 2

/-- The first-order language of set theory used here: `∅, ω, 𝒫, ⋃, (·,·)` and `∈`. -/
abbrev L : Language := ⟨Func, Rel⟩

/-! ### Depth-polymorphic formulas

Formulas of Mathlib's `ModelTheory` are `L.BoundedFormula Empty n` with `n` bound
variables `&0, …, &(n-1)`; a quantifier `∀'`/`∃'` binds the *last* variable
`&n`.  So `&ℓ` is the variable of de Bruijn *level* `ℓ` (`0` = outermost).  We
build formulas through *depth-polymorphic* formulas `Fm := ∀ n, L.BoundedFormula Empty n`
and terms `Tm := ∀ n, L.Term (Empty ⊕ Fin n)`: `allF fun x => φ x` binds a new
variable and passes its level `x` to the body, so that scoping is checked by
Lean and no lifting is ever needed; a sentence is obtained by evaluating at
depth `0` (`toSentence`). -/

/-- Depth-polymorphic formulas. -/
abbrev Fm : Type := ∀ n : ℕ, L.BoundedFormula Empty n

/-- Depth-polymorphic terms. -/
abbrev Tm : Type := ∀ n : ℕ, L.Term (Empty ⊕ Fin n)

/-- The variable of de Bruijn level `ℓ` (`0` = outermost).  (For `ℓ ≥ n` — never
used — it is the constant `∅`.) -/
def varT (ℓ : ℕ) : Tm := fun n =>
  if h : ℓ < n then Term.var (Sum.inr ⟨ℓ, h⟩) else Term.func Func.emptyset Fin.elim0

/-- The constant `∅`. -/
def empT : Tm := fun _ => Term.func Func.emptyset Fin.elim0

/-- The constant `ω`. -/
def omT : Tm := fun _ => Term.func Func.omega Fin.elim0

/-- The power set `𝒫 t`. -/
def powT (t : Tm) : Tm := fun n => Term.func Func.powerset ![t n]

/-- The union `⋃ t`. -/
def unionT (t : Tm) : Tm := fun n => Term.func Func.union ![t n]

/-- The ordered pair `(s, t)`. -/
def pairT (s t : Tm) : Tm := fun n => Term.func Func.pair ![s n, t n]

/-- `s ∈ t`. -/
def memF (s t : Tm) : Fm := fun n => Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (s n) (t n)

/-- `s = t`. -/
def eqF (s t : Tm) : Fm := fun n => Term.bdEqual (s n) (t n)

def andF (φ ψ : Fm) : Fm := fun n => φ n ⊓ ψ n
def orF (φ ψ : Fm) : Fm := fun n => φ n ⊔ ψ n
def impF (φ ψ : Fm) : Fm := fun n => (φ n).imp (ψ n)
def iffF (φ ψ : Fm) : Fm := fun n => (φ n).iff (ψ n)
def notF (φ : Fm) : Fm := fun n => (φ n).not

/-- `∀ x, φ x`; the body receives the *level* of the bound variable. -/
def allF (φ : ℕ → Fm) : Fm := fun n => (φ n (n + 1)).all

/-- `∃ x, φ x`; the body receives the *level* of the bound variable. -/
def exF (φ : ℕ → Fm) : Fm := fun n => (φ n (n + 1)).ex

/-- `∀ x ∈ t, φ x`. -/
def allIn (t : Tm) (φ : ℕ → Fm) : Fm := allF fun x => impF (memF (varT x) t) (φ x)

/-- `∃ x ∈ t, φ x`. -/
def exIn (t : Tm) (φ : ℕ → Fm) : Fm := exF fun x => andF (memF (varT x) t) (φ x)

/-- Conjunction of a list of formulas (`⊤` for the empty list). -/
def andsF : List Fm → Fm
  | [] => notF (fun _ => ⊥)
  | [φ] => φ
  | φ :: φs => andF φ (andsF φs)

/-- The sentence denoted by a depth-polymorphic formula (evaluation at depth `0`). -/
def toSentence (φ : Fm) : L.Sentence := φ 0

/-- `s ⊆ t`. -/
def subsetF (s t : Tm) : Fm := allF fun z => impF (memF (varT z) s) (memF (varT z) t)

/-! ### The theory `ZFC` -/

/-- `∀ x, x ∉ ∅`. -/
def axiomOfEmptyset : L.Sentence := toSentence <|
  allF fun x => notF (memF (varT x) empT)

/-- `∀ x y z w, (x, y) = (z, w) ↔ x = z ∧ y = w`: the pairing symbol produces
ordered pairs. -/
def axiomOfOrderedPairs : L.Sentence := toSentence <|
  allF fun x => allF fun y => allF fun z => allF fun w =>
    iffF (eqF (pairT (varT x) (varT y)) (pairT (varT z) (varT w)))
      (andF (eqF (varT x) (varT z)) (eqF (varT y) (varT w)))

/-- `∀ x y, (∀ z, z ∈ x ↔ z ∈ y) → x = y`. -/
def axiomOfExtensionality : L.Sentence := toSentence <|
  allF fun x => allF fun y =>
    impF (allF fun z => iffF (memF (varT z) (varT x)) (memF (varT z) (varT y)))
      (eqF (varT x) (varT y))

/-- `∀ u x, x ∈ ⋃ u ↔ ∃ y, y ∈ u ∧ x ∈ y`. -/
def axiomOfUnion : L.Sentence := toSentence <|
  allF fun u => allF fun x =>
    iffF (memF (varT x) (unionT (varT u)))
      (exF fun y => andF (memF (varT y) (varT u)) (memF (varT x) (varT y)))

/-- `∀ z y, y ∈ 𝒫 z ↔ ∀ x, x ∈ y → x ∈ z`. -/
def axiomOfPowerset : L.Sentence := toSentence <|
  allF fun z => allF fun y =>
    iffF (memF (varT y) (powT (varT z)))
      (allF fun x => impF (memF (varT x) (varT y)) (memF (varT x) (varT z)))

/-- `a` (a variable level) is an ordinal: `∈` is trichotomous and well-founded on
`a`, and `a` is transitive. -/
def ordF (a : ℕ) : Fm :=
  andF
    (andF
      -- ∈-trichotomy on `a`
      (allF fun y => impF (memF (varT y) (varT a)) (allF fun z => impF (memF (varT z) (varT a))
        (orF (orF (eqF (varT y) (varT z)) (memF (varT y) (varT z))) (memF (varT z) (varT y)))))
      -- ∈-well-foundedness on `a`: every nonempty subset has an ∈-minimal element
      (allF fun y => impF (subsetF (varT y) (varT a)) (impF (notF (eqF (varT y) empT))
        (exF fun z => andF (memF (varT z) (varT y))
          (allF fun w => impF (memF (varT w) (varT y)) (notF (memF (varT w) (varT z))))))))
    -- transitivity of `a`
    (allF fun y => impF (memF (varT y) (varT a)) (subsetF (varT y) (varT a)))

/-- Infinity: `∅ ∈ ω`, `ω` is closed under "there is a larger element", `ω` is an
ordinal, and `ω` is contained in every ordinal `a` with `∅ ∈ a` closed under
"there is a larger element" — i.e. `ω` is the least infinite ordinal. -/
def axiomOfInfinity : L.Sentence := toSentence <|
  andF
    (andF
      (andF
        (memF empT omT)
        (allF fun x => impF (memF (varT x) omT)
          (exF fun y => andF (memF (varT y) omT) (memF (varT x) (varT y)))))
      (exF fun a => andF (ordF a) (eqF omT (varT a))))
    (allF fun a => impF (ordF a) (impF
      (andF (memF empT (varT a))
        (allF fun x => impF (memF (varT x) (varT a))
          (exF fun y => andF (memF (varT y) (varT a)) (memF (varT x) (varT y)))))
      (subsetF omT (varT a))))

/-- `∀ x, x ≠ ∅ → ∃ y ∈ x, ∀ z ∈ x, z ∉ y`. -/
def axiomOfRegularity : L.Sentence := toSentence <|
  allF fun x => impF (notF (eqF (varT x) empT))
    (exF fun y => andF (memF (varT y) (varT x))
      (allF fun z => impF (memF (varT z) (varT x)) (notF (memF (varT z) (varT y)))))

/-- Zorn's lemma: if `x ≠ ∅` and the union of every chain `y ⊆ x` (a subset of `x`
linearly ordered by `⊆`) belongs to `x`, then `x` has a `⊆`-maximal element. -/
def zornsLemma : L.Sentence := toSentence <|
  allF fun x => impF (notF (eqF (varT x) empT)) (impF
    (allF fun y => impF
      (andF (subsetF (varT y) (varT x))
        (allF fun w₁ => allF fun w₂ =>
          impF (andF (memF (varT w₁) (varT y)) (memF (varT w₂) (varT y)))
            (orF (subsetF (varT w₁) (varT w₂)) (subsetF (varT w₂) (varT w₁)))))
      (memF (unionT (varT y)) (varT x)))
    (exF fun m => andF (memF (varT m) (varT x))
      (allF fun z => impF (memF (varT z) (varT x))
        (impF (subsetF (varT m) (varT z)) (eqF (varT m) (varT z))))))

/-- Strong collection for the formula `ψ`, whose bound variables are the `n`
parameters `&0, …, &(n-1)`, `x = &n` and `y = &(n+1)`:

`∀ params, ∀ u, (∀ x ∈ u, ∃ y, ψ) → ∃ v, (∀ x ∈ u, ∃ y ∈ v, ψ) ∧ (∀ y ∈ v, ∃ x ∈ u, ψ)`.

`ψ.liftAt k n` is `ψ` with `k` new variables inserted at level `n` (i.e. below
`x` and `y`, above the parameters); in the last conjunct the roles of the two
innermost variables are exchanged by introducing a copy `y'` of `y`.  The
levels of the variables in the three clauses are (`p` = parameters):
`p, u, x, y`; `p, u, v, x, y`; `p, u, v, y, x, y'`. -/
def collectionAxiom (n : ℕ) (ψ : L.BoundedFormula Empty (n + 2)) : L.Sentence :=
  BoundedFormula.alls (n := n + 1) <|
    BoundedFormula.imp
      -- ∀ x ∈ u, ∃ y, ψ                                    (levels: p, u, x, y)
      (BoundedFormula.all (BoundedFormula.imp (Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (Term.var (Sum.inr ⟨n + 1, by omega⟩)) (Term.var (Sum.inr ⟨n, by omega⟩))) (BoundedFormula.ex (ψ.liftAt 1 n))))
      (BoundedFormula.ex
        -- ∀ x ∈ u, ∃ y ∈ v, ψ                              (levels: p, u, v, x, y)
        ((BoundedFormula.all (BoundedFormula.imp (Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (Term.var (Sum.inr ⟨n + 2, by omega⟩)) (Term.var (Sum.inr ⟨n, by omega⟩))) (BoundedFormula.ex ((Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (Term.var (Sum.inr ⟨n + 3, by omega⟩)) (Term.var (Sum.inr ⟨n + 1, by omega⟩))) ⊓ (ψ.liftAt 2 n))))) ⊓
         -- ∀ y ∈ v, ∃ x ∈ u, ∃ y', y' = y ∧ ψ              (levels: p, u, v, y, x, y')
         (BoundedFormula.all (BoundedFormula.imp (Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (Term.var (Sum.inr ⟨n + 2, by omega⟩)) (Term.var (Sum.inr ⟨n + 1, by omega⟩))) (BoundedFormula.ex ((Relations.boundedFormula₂ (Rel.mem : L.Relations 2) (Term.var (Sum.inr ⟨n + 3, by omega⟩)) (Term.var (Sum.inr ⟨n, by omega⟩))) ⊓ (BoundedFormula.ex ((Term.bdEqual (Term.var (Sum.inr ⟨n + 4, by omega⟩)) (Term.var (Sum.inr ⟨n + 2, by omega⟩))) ⊓ (ψ.liftAt 3 n)))))))))

/-- **The theory `ZFC`**: extensionality, empty set, ordered pairs, union, power
set, infinity, regularity, Zorn's lemma, and the strong collection scheme.  This
is the axiom system of Han–van Doorn's Flypitch formalization of ZFC; it is
equivalent to the usual ZFC. -/
def ZFC : L.Theory :=
  {axiomOfEmptyset, axiomOfOrderedPairs, axiomOfExtensionality, axiomOfUnion,
    axiomOfPowerset, axiomOfInfinity, axiomOfRegularity, zornsLemma} ∪
  ⋃ n : ℕ, Set.range (collectionAxiom n)

/-! ### The sentence `Erdos501`

We follow DeepMind's formalization of the first question and render it as
follows.

* **The real numbers.**  Rather than constructing `ℝ` inside set theory, the
  sentence quantifies over *all* complete ordered fields `(R, +, ·, <, 0, 1)`
  given as sets (`+`, `·` as sets of triples `((x, y), z)`, `<` as a set of pairs)
  and asserts the Erdős property for each of them.  ZFC proves that any two
  complete ordered fields are isomorphic and the Erdős property is invariant
  under isomorphism, so this is ZFC-equivalent to the property for `ℝ`.
* **Bounded.**  `∃ m₁ m₂ ∈ R, ∀ y ∈ A_x, m₁ < y < m₂` (`boundedF`).
* **Outer measure `< 1`.**  Lebesgue outer measure is the infimum of `∑ (bₙ - aₙ)`
  over covers by countably many open intervals; it is `< 1` iff there is a cover
  `(aₙ, bₙ)ₙ∈ω` with all partial sums `sₙ = ∑_{k<n} (b_k - a_k)` (defined by
  `s₀ = 0`, `s_{n+1} + aₙ = sₙ + bₙ`) bounded by some `r < 1`
  (`outerMeasureLtOneF`).
* **Infinite.**  `ω` injects into `X` (`infiniteF`; ZFC-equivalent to "not
  finite" by choice).
* **Independent.**  `∀ x y ∈ X, x ≠ y → x ∉ A(y)` (`independentF`). -/

/-- `x < y`, for an order relation `lt` given as a set of ordered pairs. -/
def ltF (lt x y : Tm) : Fm := memF (pairT x y) lt

/-- `x ≤ y`, i.e. `x < y ∨ x = y`. -/
def leF (lt x y : Tm) : Fm := orF (ltF lt x y) (eqF x y)

/-- `f(x) = y`, for a function `f` given as a set of ordered pairs. -/
def appF (f x y : Tm) : Fm := memF (pairT x y) f

/-- `op(x, y) = z`, for a binary operation `op` given as a set of pairs `((x, y), z)`. -/
def app2F (op x y z : Tm) : Fm := memF (pairT (pairT x y) z) op

/-- `f` is a (total, single-valued) function from `dom` to `cod`: every `x ∈ dom`
has exactly one `f`-value, and it lies in `cod`. -/
def isFunF (dom cod f : Tm) : Fm :=
  allIn dom fun x => exIn cod fun y =>
    andF (appF f (varT x) (varT y))
      (allF fun y' => impF (appF f (varT x) (varT y')) (eqF (varT y') (varT y)))

/-- `op` is a binary operation on `R`: every pair `(x, y) ∈ R × R` has exactly one
`op`-value, and it lies in `R`. -/
def isOp2F (R op : Tm) : Fm :=
  allIn R fun x => allIn R fun y => exIn R fun z =>
    andF (app2F op (varT x) (varT y) (varT z))
      (allF fun z' => impF (app2F op (varT x) (varT y) (varT z')) (eqF (varT z') (varT z)))

/-- `m = n ∪ {n}` (the successor of `n`). -/
def succF (n m : Tm) : Fm :=
  allF fun z => iffF (memF (varT z) m) (orF (memF (varT z) n) (eqF (varT z) n))

/-- `(R, plus, times, lt, zero, one)` is a complete ordered field: `plus`, `times`
are binary operations on `R`, `zero, one ∈ R`, the field axioms, the axioms of a
total order compatible with `+` and `·`, and Dedekind completeness (every
nonempty subset of `R` with an upper bound has a least upper bound). -/
def completeOrderedFieldF (R plus times lt zero one : Tm) : Fm :=
  andsF [
    isOp2F R plus,
    isOp2F R times,
    memF zero R,
    memF one R,
    -- `+` is associative: x + y = u → u + z = v → y + z = w → x + w = w' → v = w'
    allIn R fun x => allIn R fun y => allIn R fun z =>
      allF fun u => allF fun v => allF fun w => allF fun w' =>
        impF (app2F plus (varT x) (varT y) (varT u)) <| impF (app2F plus (varT u) (varT z) (varT v)) <|
        impF (app2F plus (varT y) (varT z) (varT w)) <| impF (app2F plus (varT x) (varT w) (varT w')) <|
        eqF (varT v) (varT w'),
    -- `+` is commutative
    allIn R fun x => allIn R fun y => allF fun u =>
      impF (app2F plus (varT x) (varT y) (varT u)) (app2F plus (varT y) (varT x) (varT u)),
    -- x + 0 = x
    allIn R fun x => app2F plus (varT x) zero (varT x),
    -- additive inverses
    allIn R fun x => exIn R fun y => app2F plus (varT x) (varT y) zero,
    -- `·` is associative
    allIn R fun x => allIn R fun y => allIn R fun z =>
      allF fun u => allF fun v => allF fun w => allF fun w' =>
        impF (app2F times (varT x) (varT y) (varT u)) <| impF (app2F times (varT u) (varT z) (varT v)) <|
        impF (app2F times (varT y) (varT z) (varT w)) <| impF (app2F times (varT x) (varT w) (varT w')) <|
        eqF (varT v) (varT w'),
    -- `·` is commutative
    allIn R fun x => allIn R fun y => allF fun u =>
      impF (app2F times (varT x) (varT y) (varT u)) (app2F times (varT y) (varT x) (varT u)),
    -- x · 1 = x
    allIn R fun x => app2F times (varT x) one (varT x),
    -- multiplicative inverses of nonzero elements
    allIn R fun x => impF (notF (eqF (varT x) zero)) (exIn R fun y => app2F times (varT x) (varT y) one),
    -- 0 ≠ 1
    notF (eqF zero one),
    -- distributivity: y + z = u → x · u = v → x · y = w → x · z = t → w + t = t' → v = t'
    allIn R fun x => allIn R fun y => allIn R fun z =>
      allF fun u => allF fun v => allF fun w => allF fun t => allF fun t' =>
        impF (app2F plus (varT y) (varT z) (varT u)) <| impF (app2F times (varT x) (varT u) (varT v)) <|
        impF (app2F times (varT x) (varT y) (varT w)) <| impF (app2F times (varT x) (varT z) (varT t)) <|
        impF (app2F plus (varT w) (varT t) (varT t')) <| eqF (varT v) (varT t'),
    -- `<` is irreflexive
    allIn R fun x => notF (ltF lt (varT x) (varT x)),
    -- `<` is transitive
    allIn R fun x => allIn R fun y => allIn R fun z =>
      impF (ltF lt (varT x) (varT y)) <| impF (ltF lt (varT y) (varT z)) <| ltF lt (varT x) (varT z),
    -- `<` is total
    allIn R fun x => allIn R fun y =>
      orF (ltF lt (varT x) (varT y)) (orF (eqF (varT x) (varT y)) (ltF lt (varT y) (varT x))),
    -- `<` is compatible with `+`: x < y → x + z = u → y + z = v → u < v
    allIn R fun x => allIn R fun y => allIn R fun z => allF fun u => allF fun v =>
      impF (ltF lt (varT x) (varT y)) <| impF (app2F plus (varT x) (varT z) (varT u)) <|
      impF (app2F plus (varT y) (varT z) (varT v)) <| ltF lt (varT u) (varT v),
    -- products of positive elements are positive: 0 < x → 0 < y → x · y = u → 0 < u
    allIn R fun x => allIn R fun y => allF fun u =>
      impF (ltF lt zero (varT x)) <| impF (ltF lt zero (varT y)) <|
      impF (app2F times (varT x) (varT y) (varT u)) <| ltF lt zero (varT u),
    -- Dedekind completeness: every nonempty bounded-above `S ⊆ R` has a least upper bound
    allIn (powT R) fun S =>
      impF (notF (eqF (varT S) empT)) <|
      impF (exIn R fun b => allIn (varT S) fun s => leF lt (varT s) (varT b)) <|
      exIn R fun u =>
        andF (allIn (varT S) fun s => leF lt (varT s) (varT u))
          (allIn R fun v => impF (allIn (varT S) fun s => leF lt (varT s) (varT v))
            (leF lt (varT u) (varT v)))
  ]

/-- `S` is bounded (above and below) in `(R, <)`: `∃ m₁ m₂ ∈ R, ∀ y ∈ S, m₁ < y < m₂`.
This renders `Bornology.IsBounded (A x)`. -/
def boundedF (R lt S : Tm) : Fm :=
  exIn R fun m₁ => exIn R fun m₂ => allIn S fun y =>
    andF (ltF lt (varT m₁) (varT y)) (ltF lt (varT y) (varT m₂))

/-- The Lebesgue outer measure of `S ⊆ R` is `< 1`: there are sequences
`a, b : ω → R` with `aₙ < bₙ`, such that the open intervals `(aₙ, bₙ)` cover `S`,
and whose total length `∑ₙ (bₙ - aₙ)` is `< 1`; the total length is expressed
through the partial sums `s : ω → R`, `s 0 = 0`, `s (n+1) + aₙ = s n + bₙ`, all of
which are `≤ r` for some `r < 1`.  This renders `volume.toOuterMeasure (A x) < 1`. -/
def outerMeasureLtOneF (R plus lt zero one S : Tm) : Fm :=
  exF fun a => exF fun b => exF fun s => andsF [
    isFunF omT R (varT a),
    isFunF omT R (varT b),
    isFunF omT R (varT s),
    -- the intervals are nondegenerate: ∀ n ∈ ω, aₙ < bₙ
    allIn omT fun n => allF fun u => allF fun v =>
      impF (appF (varT a) (varT n) (varT u)) <| impF (appF (varT b) (varT n) (varT v)) <|
      ltF lt (varT u) (varT v),
    -- they cover `S`: ∀ y ∈ S, ∃ n ∈ ω, aₙ < y < bₙ
    allIn S fun y => exIn omT fun n => exF fun u => exF fun v =>
      andF (appF (varT a) (varT n) (varT u)) <| andF (appF (varT b) (varT n) (varT v)) <|
      andF (ltF lt (varT u) (varT y)) (ltF lt (varT y) (varT v)),
    -- s 0 = 0
    appF (varT s) empT zero,
    -- s (n+1) + aₙ = s n + bₙ
    allIn omT fun n => allF fun m => impF (succF (varT n) (varT m)) <|
      allF fun u => allF fun v => allF fun w => allF fun w' => allF fun t => allF fun t' =>
        impF (appF (varT a) (varT n) (varT u)) <| impF (appF (varT b) (varT n) (varT v)) <|
        impF (appF (varT s) (varT n) (varT w)) <| impF (appF (varT s) (varT m) (varT w')) <|
        impF (app2F plus (varT w') (varT u) (varT t)) <| impF (app2F plus (varT w) (varT v) (varT t')) <|
        eqF (varT t) (varT t'),
    -- the partial sums are bounded by some r < 1
    exIn R fun r => andF (ltF lt (varT r) one)
      (allIn omT fun n => allF fun w => impF (appF (varT s) (varT n) (varT w)) (leF lt (varT w) (varT r)))
  ]

/-- `X` is infinite: `ω` injects into `X`.  This renders `X.Infinite`. -/
def infiniteF (X : Tm) : Fm :=
  exF fun f => andF (isFunF omT X (varT f))
    (allIn omT fun n => allIn omT fun m => allF fun u =>
      impF (appF (varT f) (varT n) (varT u)) <| impF (appF (varT f) (varT m) (varT u)) <|
      eqF (varT n) (varT m))

/-- `X` is independent for the family `A`: `∀ x y ∈ X, x ≠ y → x ∉ A(y)`.
This renders `X.Pairwise (fun x y => x ∉ A y)`. -/
def independentF (A X : Tm) : Fm :=
  allIn X fun x => allIn X fun y => impF (notF (eqF (varT x) (varT y)))
    (allF fun Ay => impF (appF A (varT y) (varT Ay)) (notF (memF (varT x) (varT Ay))))

/-- The Erdős property for the complete ordered field `(R, plus, times, lt, zero, one)`:
for every function `A : R → 𝒫(R)` such that every `A(x)` is bounded and has outer
measure `< 1`, there is an infinite independent `X ⊆ R`. -/
def erdosPropertyF (R plus lt zero one : Tm) : Fm :=
  allF fun A => impF (isFunF R (powT R) (varT A)) <|
    impF (allIn R fun x => allF fun Ax => impF (appF (varT A) (varT x) (varT Ax))
      (andF (boundedF R lt (varT Ax)) (outerMeasureLtOneF R plus lt zero one (varT Ax)))) <|
    exIn (powT R) fun X => andF (infiniteF (varT X)) (independentF (varT A) (varT X))

set_option linter.dupNamespace false in
/-- **Erdős problem #501, first question, as a sentence of `L`**: for every complete
ordered field `(R, +, ·, <, 0, 1)`, every family `⟨A_x : x ∈ R⟩` of bounded subsets
of `R` of outer measure `< 1` has an infinite independent set. -/
def Erdos501 : L.Sentence :=
  toSentence <|
    allF fun R => allF fun plus => allF fun times => allF fun lt => allF fun zeroR => allF fun oneR =>
      impF (completeOrderedFieldF (varT R) (varT plus) (varT times) (varT lt) (varT zeroR) (varT oneR))
        (erdosPropertyF (varT R) (varT plus) (varT lt) (varT zeroR) (varT oneR))

/-! ### The standard interpretation in Mathlib's `ZFSet` -/

/-- Mathlib's `ZFSet` as an `L`-structure: `∅ ↦ ∅`, `ω ↦ ω`, `𝒫 ↦ powerset`,
`⋃ ↦ sUnion`, `(·,·) ↦ Kuratowski pair`, `∈ ↦ ∈`. -/
noncomputable instance zfsetStructure : L.Structure ZFSet.{0} where
  funMap {n} f xs :=
    match n, f, xs with
    | _, Func.emptyset, _ => ∅
    | _, Func.omega, _ => ZFSet.omega
    | _, Func.powerset, xs => ZFSet.powerset (xs 0)
    | _, Func.union, xs => ZFSet.sUnion (xs 0)
    | _, Func.pair, xs => ZFSet.pair (xs 0) (xs 1)
  RelMap {n} r xs :=
    match n, r, xs with
    | _, Rel.mem, xs => xs 0 ∈ xs 1

end Erdos501.FOL

/-! ## Part B — the statements -/

open Erdos501.FOL

/-! ### Second question: closed sets of measure `< 1` -/

/-- Newelski–Pawlikowski–Seredyński (Proc. AMS 100 (1987) 335–339): if every
`A x` is closed of Lebesgue measure `< 1` then there is an infinite independent
set.  (No boundedness hypothesis is needed.) -/
theorem erdos501_closed_infinite :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-- The second question of #501 as asked: an independent set of size `3`
(`Set.ncard` is `0` on infinite sets, so this forces a finite independent set
with at least three elements). -/
theorem erdos501_closed_size3 :
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, 3 ≤ X.ncard ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-! ### First question: Hechler's counterexample under `CH` -/

/-- Hechler (Israel J. Math. 11 (1972) 231–248): if `ℵ₁ = 𝔠` then there is a
family of bounded sets of outer measure `< 1` with no infinite independent set.
This is a theorem of ZFC, so it holds in Lean outright; the hypothesis `CH` is a
genuine hypothesis of the theorem.  (Hechler's construction in fact yields
countable, null sets — a stronger property this compared statement does not
assert; it is available in `Erdos501/Hechler.lean`.) -/
theorem erdos501_hechler_of_CH :
    ((ℵ₁ : Cardinal.{u}) = 𝔠) →
    ∃ (A : ℝ → Set ℝ),
      (∀ x, Bornology.IsBounded (A x)) ∧
      (∀ x, volume.toOuterMeasure (A x) < 1) ∧
      ¬ ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry

/-! ### First question: independence from `ZFC` -/

/-- **A positive answer is consistent with ZFC**: `ZFC` does not entail the negation
of `Erdos501` — some model of `ZFC` satisfies `Erdos501` (E. Glazer, 2026: it holds
after adding `𝔠⁺` random reals; formalized through the Boolean-valued model of the
random algebra and the completeness theorem). -/
theorem erdos501_not_refutable : ¬ (ZFC ⊨ᵇ ∼Erdos501) := by
  sorry

/-- **A negative answer is consistent with ZFC**: `ZFC` does not entail `Erdos501` —
some model of `ZFC` satisfies its negation (Hechler's counterexample under `CH`,
formalized through the Boolean-valued model of the collapse algebra
`Col(ω₁, 𝒫(ω))`, where `CH` holds). -/
theorem erdos501_not_provable : ¬ (ZFC ⊨ᵇ Erdos501) := by
  sorry

/-- **The first question of Erdős #501 is independent of ZFC**: neither `Erdos501`
nor its negation is a consequence of `ZFC`. -/
theorem erdos501_independent : ¬ (ZFC ⊨ᵇ Erdos501) ∧ ¬ (ZFC ⊨ᵇ ∼Erdos501) := by
  sorry

/-- **Faithfulness of the rendering**: in Mathlib's `ZFSet` (with the standard
interpretation of `∅, ω, 𝒫, ⋃, (·,·), ∈`), the sentence `Erdos501` holds iff the
Mathlib-level statement of the first question — verbatim the proposition of
`formal-conjectures`' `erdos_501` — holds. -/
theorem erdos501_sentence_faithful :
    (ZFSet.{0} ⊨ Erdos501) ↔
      ∀ (A : ℝ → Set ℝ),
        (∀ x, Bornology.IsBounded (A x)) →
        (∀ x, volume.toOuterMeasure (A x) < 1) →
        ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y) := by
  sorry
