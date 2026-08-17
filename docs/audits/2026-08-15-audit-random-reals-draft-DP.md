# Audit of "Erdős Problem 501 in extensions by ω₂ random reals" (draft dated Aug 15, 2026)

## Verdict

The paper does **not** establish Con(ZFC + P). The chain

    ω₂ random reals over CH  ⟹  shr(N) < cov(N)  ⟹  DP  ⟹  P

breaks at the middle arrow. The principle DP, exactly as the paper defines it (with *lower outer density*), is **refutable in ZFC** by a two‑line Bernstein‑set example, so Theorem 2.2 ("shr(N) < cov(N) implies DP") is false and Theorem 1.2 is vacuous. Worse for the strategy, the conclusion of the Selection Lemma 4.1 is itself refutable in ZFC, so no correct density principle can be substituted for DP without changing the argument. Everything else in the paper (the two measure lemmas, the recursion of Section 5 given Lemma 4.1, the CH counterexample, and the citation of Laczkovich–Miller) checks out.

The negative half of Theorem 1.3, Con(ZFC + ¬P), is correct and classical (Hechler under CH; L ⊨ CH). The positive half is unproven.

---

## 1. Parts that are correct

**Lemma 3.1 (exact isomorphism).** Correct. The standard isomorphism theorem gives a bimeasurable normalized measure‑preserving bijection between conull Borel subsets; the leftover null sets have cardinality 𝔠 (they were arranged to contain null Cantor sets) and are matched by an arbitrary bijection. Every subset of a null set is completed‑measurable, so θ and θ⁻¹ preserve completed measurability and normalized measure, and (2), (3) follow because outer (inner) measure is an infimum (supremum) over completed‑measurable supersets (subsets).

**Lemma 3.2 (disjoint‑block estimate).** Correct: for measurable F ⊆ ⋃Eₙ, λ(F) = Σλ(F ∩ Pₙ) ≤ Σλ_*(Eₙ).

**Section 5 (recursion), given Lemma 4.1.** Correct. The bookkeeping λ_*(Cₙ₊₁) = ∞ uses (1) with F ⊆ Eₙ of finite measure > R + K, and removing a point does not change inner measure. The independence check (xⱼ ∉ A_{xᵢ} because xⱼ ∈ Cᵢ₊₁ ⊆ ℝ ∖ A_{xᵢ}; xᵢ ∉ A_{xⱼ} because xⱼ ∉ B_{xᵢ}) is right.

**Section 6 (CH ⟹ ¬P).** Correct; this is Hechler's construction. Each A_y is countable and contained in [−(|y|+1), |y|+1]; along an increasing‑index sequence in a putative infinite independent set, |x₀| > |x₁| + 1 > |x₂| + 2 > … is impossible.

**Proposition 2.1 (Laczkovich–Miller).** Correctly cited. Lemma 8 of Laczkovich–Miller (Colloq. Math. 69, 1996; arXiv math/9411206) states exactly the two facts used, for the extension of a CH ground model by the measure algebra on 2^{ω₂}: ℝ is not a union of ℵ₁ null sets, and every set of positive outer measure has a positive‑outer‑measure subset of size ℵ₁. Hence shr(N) = ℵ₁ < cov(N) there.

**"shr(N) < cov(N) ⟹ no weak Sierpiński set."** This is the cardinal‑invariant implication the paper alludes to in Theorem 2.2, and it is a genuine (easy) theorem: if H_x is conull for every x and Y = {y : H^y null} had positive outer measure, take Y′ ⊆ Y non‑null with |Y′| ≤ shr(N) < cov(N); some x avoids ⋃_{y∈Y′} H^y, so Y′ ⊆ I ∖ H_x is null, contradiction. So the *input* to Humke–Laczkovich's Theorem 9 is available in the random model. The problem is what Theorem 9 says.

---

## 2. The fatal error: DP as stated is false in ZFC

The paper defines (p. 2–3)

    d̲*(E,t) = liminf_{h↓0} λ*(E ∩ [t−h, t+h]) / 2h      (lower OUTER density)

and DP: *if H ⊆ I × ℝ satisfies d̲*(H_u, 0) = 1 for every u ∈ I, then for every δ > 0, d̲*({t : λ*(H^t) > 1 − δ}, 0) = 1.*

**Counterexample (ZFC).** Let P ⊆ ℝ be a Bernstein set (both P and ℝ ∖ P meet every uncountable closed set, hence both have full outer measure). Put

    H = ([0, ½] × P) ∪ ((½, 1] × (ℝ ∖ P)) ⊆ I × ℝ.

* For u ∈ [0, ½], H_u = P; for u ∈ (½, 1], H_u = ℝ ∖ P. Both have full outer measure, so λ*(H_u ∩ [−h, h]) = 2h for all h and d̲*(H_u, 0) = 1 for every u ∈ I. The hypothesis of DP holds.
* For t ∈ P, H^t = [0, ½]; for t ∉ P, H^t = (½, 1]. So λ*(H^t) = ½ for every t ∈ ℝ.
* Take δ = ½: {t : λ*(H^t) > ½} = ∅, whose lower outer density at 0 is 0, not 1.

So DP fails outright, in ZFC. Consequently Theorem 2.2 is false (in every model, in particular in the random model), Lemma 4.1 has a false hypothesis, and Theorem 1.2/1.1 are not proved.

**Why the paper believed DP.** Theorem 9 of Humke–Laczkovich (Trans. AMS 357 (2005)) does have the shape "if every section H_x has lower density 1 at 0 then, for every δ, {y : λ*(H^y) > 1−δ} has lower outer density 1 at 0", under "no weak Sierpiński set". But the density in the *hypothesis* there must be the **inner** lower density (sections containing measurable sets of density 1), not the outer one:

* the outer version is refuted in ZFC by the example above, whereas Humke–Laczkovich's hypothesis is consistent;
* their proof (pp. 40–41) fixes the scales hₙ coming from the failure of the conclusion and then invokes the strong law of large numbers on the product space I^ω to get liminf (1/n)Σ f_i(x, y_i) = 1 for ν‑a.e. ȳ; that step needs measurable *kernels* of the rescaled sections (1/hₙ)(H_x ∩ [0,hₙ]) of measure → 1, i.e. λ_*(H_x ∩ [0,hₙ])/hₙ → 1. With merely outer density → 1 the exceptional set is not ν‑null (e.g. if every rescaled section is Bernstein‑like, the set of ȳ with all y_i outside the sections has full outer measure);
* the paper's own notion of "symmetrically approximately continuous" is defined via a *measurable* set having density point 0, i.e. inner density, and Theorems 10–12 feed such sets into Theorem 9.

(In the copy of [5] I could access, sub/superscripts on the density symbols are not recoverable from the text layer, so I cannot quote the notation letter for letter; the mathematical point above does not depend on it.)

**Why the misreading matters for the construction.** In the proof of Lemma 4.1 the only information available about the sections H_u is (9)–(10): λ_*([−h,h] ∖ H_u) = o(h), which via (1) gives *outer* density 1 of H_u at 0 — nothing more, because H_u ∩ Jₙ = φₙ⁻¹[Mₙ ∩ B_x] and B_x = {y : x ∈ A_y} is an arbitrary set; its inner measure in Mₙ can be 0. So even the correct (inner‑density) Theorem 9 does not apply to the H constructed in Section 4.

---

## 3. The strategy cannot be repaired locally: Lemma 4.1's conclusion is refutable in ZFC

The paper's route is: DP ⟹ Selection Lemma ⟹ recursion. Independently of DP, the *conclusion* of the Selection Lemma is false in ZFC, so no true principle can be put in DP's place without changing Sections 4–5.

**Counterexample.** By Lusin–Sierpiński, ℝ = ⨆_{x∈ℝ} P_x can be partitioned into continuum many pairwise disjoint sets, each meeting every uncountable closed set (hence each of full outer measure). For y ∈ ℝ let β(y) be the unique x with y ∈ P_x, and put

    A_y = {β(y)}      (a singleton; λ*(A_y) = 0 ≤ K, bounded).

Then B_x = {y : x ∈ A_y} = P_x. Take C = ℝ, so λ_*(C) = ∞. For every x ∈ C, C ∖ B_x = ℝ ∖ P_x contains no closed set of positive measure, so λ_*(C ∖ B_x) = 0 < ∞. Thus **no** x ∈ C satisfies λ_*(C ∖ B_x) = ∞, contradicting the conclusion of Lemma 4.1 (and the recursion of Section 5 cannot even choose x₀), although this family trivially has infinite independent sets. Plugging this family into the paper's own construction of H (Section 4) produces another explicit ZFC counterexample to DP.

So the greedy invariant "λ_*(Cₙ) = ∞" is too strong to be maintainable in any model of ZFC; a correct argument (if one exists in the random model) must use a different invariant.

---

## 4. Status of the stated theorems

| Statement | Status |
|---|---|
| Lemma 3.1, Lemma 3.2 | correct |
| Proposition 2.1 (LM Lemma 8) | correctly cited |
| Theorem 2.2 (shr(N) < cov(N) ⟹ DP) | **false** (DP refutable in ZFC) |
| Lemma 4.1 | hypothesis false; conclusion refutable in ZFC |
| Theorem 1.2 | vacuous (assumes DP) |
| Theorem 1.1 (P holds in the ω₂‑random extension of a CH model) | **unproved** |
| Proposition 6.1 (CH ⟹ ¬P) | correct |
| Theorem 1.3, Con(ZFC + ¬P) half | correct |
| Theorem 1.3, Con(ZFC + P) half | **unproved** |

---

## 5. Minor remarks (not affecting the verdict)

* Lemma 4.1 needs sₙ > 0 to apply Lemma 3.1 to Mₙ; the choice λ(Kₙ) > n+1 guarantees this. Fine.
* In (9)–(10) the estimate uses h > ℓₙ for h ∈ Jₙ; written "h ≥ ℓₙ", harmless.
* The claim "shr(N) < cov(N) ⟹ no weak Sierpiński set" is used but not proved or precisely cited; it is true (argument in §1 above) and should be stated explicitly, with the exact statement of [5, Thm 9] quoted verbatim.

## 6. What a corrected attempt would need

Any use of a Humke–Laczkovich‑type density theorem requires the "horizontal" sections to contain measurable sets of density 1 (inner density), i.e. control of λ_*(Mₙ ∩ B_x) rather than of λ_*(Mₙ ∖ B_x). The hypotheses of Erdős 501 give outer‑measure control of the A_y and hence only inner‑measure control of the *complements* of the B_x, which is precisely the configuration realized by the ZFC examples above. A positive consistency proof therefore has to exploit more of the specific structure of the random model (or of the family) than the outer/inner data extracted in Section 4.
