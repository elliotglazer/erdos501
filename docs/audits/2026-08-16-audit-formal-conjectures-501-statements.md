# Audit of `formal-conjectures/FormalConjectures/ErdosProblems/501.lean`

(Session audit, 2026‑08‑16.  This audit is what fixes the *shape* of the statements in `Challenge.lean`.)

Audited version: `google-deepmind/formal-conjectures` main at commit `e7f4b0e` (2026-08-16). The file was added in PR #3777 (2026-05-11, "Assisted by Claude", reviewed by Paul-Lez and mo271); the only later changes are the import rename (#4433) and the removal of some `simp only [true_iff]` lines (#4034). Toolchain of the repo: Lean `v4.27.0`, Mathlib `a3a10db` (tag `v4.27.0`). Compilation is taken from the repository's CI, which runs `lake --wfail build` on the default targets; every Mathlib definition the statements depend on was checked by reading the Mathlib source at that revision.

## Verdict

Both components of Erdős #501 are formalized correctly and faithfully. The first question is `Erdos501.erdos_501`; the second question is `Erdos501.erdos_501.variants.closed_size3` (with the stronger NPS87 form in `…variants.newelski_pawlikowski_seredynski`). No defect was found in any *statement*. The only genuine errors in the file are bibliographic: four of the six entries in the module docstring's reference list are wrong (wrong titles, journals, or author initials). Those are comments only and do not affect the mathematics.

## Component 1: the open question (`erdos_501`)

```lean
theorem erdos_501 : answer(sorry) ↔
    ∀ (A : ℝ → Set ℝ),
      (∀ x, Bornology.IsBounded (A x)) →
      (∀ x, volume.toOuterMeasure (A x) < 1) →
      ∃ X : Set ℝ, X.Infinite ∧ X.Pairwise (fun x y => x ∉ A y)
```

Informal statement (erdosproblems.com, verbatim in the docstring): "For every x ∈ ℝ let A_x ⊂ ℝ be a bounded set with outer measure < 1. Must there exist an infinite independent set, that is, some infinite X ⊆ ℝ such that x ∉ A_y for all x ≠ y ∈ X?" This is Erdős's Problem II.9 in *Some unsolved problems* (1961) and Problem 38(C) of Erdős–Hajnal, *Unsolved problems in set theory* (1971).

*Boundedness.* `Bornology.IsBounded (A x)` uses the bornology of the metric on ℝ, so it means `∃ C, ∀ x y ∈ A x, dist x y ≤ C`, equivalently `BddBelow ∧ BddAbove`. It is per-set boundedness, which is the only sensible reading: with a *uniform* bound the question would be trivial. Hechler's CH counterexample uses non-uniform bounds.

*Outer measure.* `volume.toOuterMeasure (A x)` is definitionally `volume (A x)`, and for an arbitrary, possibly non-measurable set Mathlib's `volume s` is `⨅ t ⊇ s, MeasurableSet t, volume t`; on ℝ `volume` is Lebesgue measure, whose value on arbitrary sets is exactly the classical Lebesgue outer measure. So the hypothesis is precisely λ*(A_x) < 1, compared in `ℝ≥0∞`.

*Independence.* `Set.Pairwise s r` is `∀ ⦃x⦄, x ∈ s → ∀ ⦃y⦄, y ∈ s → x ≠ y → r x y`, so `X.Pairwise (fun x y => x ∉ A y)` says `x ∉ A y` for every *ordered* pair of distinct elements, i.e. both `x ∉ A y` and `y ∉ A x` — the Erdős–Hajnal notion of independence. `X.Infinite` is `¬ X.Finite`. Whether or not `x ∈ A x` is irrelevant, as in the informal problem.

*Shape.* `answer(sorry) ↔ (∀ A, … → ∃ X, …)` is the repository's convention for a yes/no question whose answer is unknown; the right-hand side is the proposition P "every such family has an infinite independent set".

One structural remark: `hechler_CH` (below) is a ZFC theorem CH → ¬P, and Lean's type theory cannot refute CH, so P is not provable in Lean. If P is consistent with ZFC then neither `answer(True)` nor `answer(False)` is provable and this declaration can never be closed. An independence result has to be formalized separately as a statement about a first-order rendering of P (as in flypitch's `CH_f`) — which is what `Challenge.lean`'s `erdos501_independent` does.

## Component 2: the closed case (`closed_size3`, `newelski_pawlikowski_seredynski`, `gladysz_size2`)

```lean
theorem erdos_501.variants.closed_size3 : answer(True) ↔
    ∀ (A : ℝ → Set ℝ),
      (∀ x, IsClosed (A x)) →
      (∀ x, volume (A x) < 1) →
      ∃ X : Set ℝ, 3 ≤ X.ncard ∧ X.Pairwise (fun x y => x ∉ A y)
```

*Closedness and measure.* `IsClosed (A x)` is closedness in the usual topology of ℝ. `volume (A x) < 1` is Lebesgue measure < 1. Erdős's original and erdosproblems.com say "< 1"; the 1971 list appears to say "≤ 1". Immaterial for the truth value: the NPS87 argument (and the project's Lean proof, which only needs `μ (F x) ≤ C < ∞` and `μ univ = ∞`) works for any uniform bound.

*No boundedness hypothesis.* The closed variants do not assume `A x` bounded. This matches Erdős–Hajnal 38(B) and erdosproblems.com's second sentence. If one reads the informal question as also inheriting "bounded", the formal statement is a strengthening (fewer hypotheses), and the strengthening is true (NPS87 is stated without boundedness).

*Size 3.* `Set.ncard` is `0` on infinite sets, so `3 ≤ X.ncard` forces `X` finite with at least three elements; since independence is hereditary and `Set.exists_subset_card_eq`, the statement is equivalent to "there is an independent set of exactly three elements".

`newelski_pawlikowski_seredynski` (same hypotheses, `X.Infinite`) is the NPS87 theorem verbatim. `gladysz_size2` (`2 ≤ X.ncard`) is Gładysz's 1962 result.

## The remaining variants

`erdosHajnal_finite` (`answer(True)`): for every `n` and every family of bounded sets with outer measure < 1 there is a `Finset ℝ` of card ≥ n that is independent. Theorem 2 of Erdős–Hajnal, *Some remarks on set theory VIII* (Michigan Math. J. 7, 1960). Correct.

`hechler_CH` (`answer(True)`): `(ℵ₁ = 𝔠) → ∃ A, (∀ x, IsBounded (A x)) ∧ (∀ x, volume.toOuterMeasure (A x) < 1) ∧ ¬ ∃ X, X.Infinite ∧ X.Pairwise (…)`. With `open scoped Cardinal`, `ℵ₁` is `Cardinal.aleph 1` and `𝔠 = 2 ^ ℵ₀ = #ℝ`, so the antecedent is CH (the universe level of the two cardinals is left to Lean; all universe instances are equivalent via `lift`). The statement is a ZFC theorem, so `answer(True)` is right; proof: enumerate ℝ = {r_α : α < ω₁}, put A_y = {r_β : β < α(y), |r_β| ≤ |y| + 1} (countable, bounded, null); along an index-increasing sequence x₀, x₁, … in a putative infinite independent set one gets |x₀| > |x₁| + 1 > |x₂| + 2 > …, impossible.

## Bibliographic corrections for the module docstring of the formal-conjectures file

| key | as written in the file | correct entry |
|---|---|---|
| [ErHa60] | Erdős, Hajnal, *On some combinatorial problems involving complete graphs*, Acta Math. Acad. Sci. Hungar. (1960), 395–424 | P. Erdős, A. Hajnal, *Some remarks on set theory. VIII*, Michigan Math. J. **7** (1960), 187–191 |
| [Gl62] | Gladysz, S., *Some topological properties of independent sets*, Colloq. Math. (1962) | S. Gładysz, *Bemerkungen über die Unabhängigkeit der Punkte in bezug auf mengenwertige Funktionen*, Acta Math. Acad. Sci. Hungar. **13** (1962), 199–201 |
| [He72] | Hechler, S. H., *A dozen small uncountable cardinals*, TOPO 72, LNM (1972), 207–218 | S. H. Hechler, *Directed graphs over topological spaces: some set theoretical aspects*, Israel J. Math. **11** (1972), 231–248 (verify against erdosproblems.com's own reference tooltip) |
| [NPS87] | Newelski, L., Pawlikowski, J., and Seredyński, F., *Infinite independent sets in the closed case*, Acta Math. Acad. Sci. Hungar. (1987) | L. Newelski, J. Pawlikowski, W. Seredyński, *Infinite free set for small measure set mappings*, Proc. Amer. Math. Soc. **100** (1987), 335–339 |
| [Er61] | Erdős, *Some unsolved problems*, Magyar Tud. Akad. Mat. Kutató Int. Közl. 6 (1961), 221–254 | correct |
| [ErHa71] | Erdős, Hajnal, *Unsolved problems in set theory*, Proc. Sympos. Pure Math. XIII Part I (1971), 17–48 | correct |

## Relation to the development in this repository

`Erdos501.IsFreeSet F X := ∀ x ∈ X, ∀ y ∈ X, x ≠ y → x ∉ F y` unfolds to the same proposition as `X.Pairwise (fun x y => x ∉ F y)` (only the strict-implicit binder annotations differ, which the kernel ignores), so the bridge is `Iff.rfl`, or explicitly `fun h x hx y hy hxy => h hx hy hxy` / `fun h x hx y hy hxy => h x hx y hy hxy`.
