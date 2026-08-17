# Audit of "Erdős Problem 501 after adding ω₂ random reals" (rev09)

(Session audit, 2026‑08‑16; the paper is `docs/paper/erdos501_random_profiles_rev09.pdf`. Superseded by the rev10 audit for the current argument; kept because the rev10 audit refers to it for Lemmas 4.1–4.3 / Prop. 4.4.)

## Verdict

I could not find an error. Every step is either an elementary measure‑theoretic argument that I checked line by line (Lemmas 2.1, 2.2, 4.1, 5.1 and the recursion of Section 5), a standard random‑forcing fact (Lemmas 3.1, 3.2), or a standard CH combinatorial fact (Lemma 3.3, Proposition 3.4), and the pieces fit together as claimed. In particular the defect that killed the previous draft is repaired: nothing resembling a Fubini/density principle is ever applied to the arbitrary relation x ∈ A_y. Measurability is manufactured by (i) replacing each A_y at ℵ₂ random test points by an *open envelope* of measure < 1, (ii) homogenizing the ℵ₂ envelope names to a single Borel map F of a "profile" (Δ‑system + only ℵ₁ Borel codes under CH), and (iii) running the double counting on the Borel profile graph, where Tonelli is legitimate. The arbitrary family re‑enters only through the containments (4.6), which hold for the actual generic profiles by the forcing theorem.

Subject to the standard facts listed in §3 below, Theorem 1.1 and Corollary 1.2 are established. The proof uses ω₂ (not ω₁) random reals exactly where it must (the pigeonhole over ℵ₁ Borel codes in Prop. 3.4), which is consistent with Hechler's CH counterexample surviving in an ω₁‑random extension.

## 1. What I verified in detail

**Lemma 2.1 (positive‑measure selection).** Correct. With E_t = {s : (t,s) ∈ E}, E^s = {t : (t,s) ∈ E}, μ(E^s) ≤ 1: t ↦ μ(C ∖ E_t) is measurable (Tonelli, σ‑finite). If Q(C) were null, pick D ⊆ C ∖ Q(C) with 1 < μ(D) < ∞, then D_k ↑ D gives d = μ(D_k) > 1, and for t ∈ D_k, μ(E_t ∩ C_n) ≥ M_n − k. Double counting E ∩ (D_k × C_n) gives (M_n − k)d ≤ ∫_{C_n} μ(E^s ∩ D_k) ≤ M_n, contradicting (M_n − k)d > M_n for large n. All quantities finite. ✔

**Lemma 2.2.** Correct: μ(C ∖ E_t) = ∞ by t ∈ Q(C); μ(E^t) ≤ 1; the fiber is null. ✔

**Lemma 3.1 (Borel reading).** Standard. ✔  **Lemma 3.2 (factorization).** Standard product/iteration property of measure algebras (Kunen; Laczkovich–Miller Fact 1). ✔

**Lemma 3.3 (Δ‑system for ω₂ countable sets under CH).** Correct; the elementary‑chain/Fodor proof is right: A_ξ ⊆ M_{ξ+1} ⊆ M_ζ, R_ζ = A_ζ ∩ M_ζ, so A_ξ ∩ A_ζ = A_ξ ∩ R = R since R = R_ξ ⊆ A_ξ; the indices α_ξ are distinct because α_ξ ∈ M_{ξ+1} ∖ M_ξ. Under CH there are ℵ₁ candidate roots inside M_{η*}. ✔ (Equivalently Kunen's Δ‑system lemma with κ = ω₂, θ = ω₁, ℵ₁^{ℵ₀} = ℵ₁.)

**Proposition 3.4 (homogeneous reading).** Correct. Supports S_α ⊇ R₀ ∪ D_α are countable; the Δ‑system root R contains R₀ (hence supports p) and is countable, so it meets only countably many disjoint blocks D_α; after discarding those, D_α ⊆ P_α = S_α ∖ R. Thinning to constant |P_α ∖ D_α| gives bijections π_α : P → P_α with π_α[D] = D_α. Pulling the Borel readings F_α back along id_R ∪ π_α gives ℵ₂ Borel maps 2^R × 2^P → X coded by reals; CH leaves ℵ₁ codes, so a single code F occurs on J of size ℵ₂, and (3.2) holds for α ∈ J. ✔

**Section 4.** The names ċ_{α,m} exist by outer regularity + the maximum principle in the complete Boolean algebra 𝔹(Θ); mixing off p makes ẇ_α a name for an element of the standard Borel space 𝒪^ℤ, as Lemma 3.1 requires. z_α = π_α^{-1}(G↾P_α) recovers r_α via D, so x(m, z_α) = x_{α,m}. Mutual randomness of (z_α)_{α∈J} over N = M[g] is Lemma 3.2 with the disjoint coordinate sets R, P_α. ✔

**Lemma 4.1 (Ω₀ conull).** Correct. For any α ∈ J, (4.2)+(3.2) give p ⊩ (Ġ↾R, π_α^{-1}(Ġ↾P_α)) ∉ B_m; since (Ġ↾R, π_α^{-1}(Ġ↾P_α)) is generic for the product measure algebra on 2^R × 2^P and p ∈ 𝔹(R), this means B_m ∩ ([p] × 2^P) is null. Fubini gives the null Borel set N_m ⊆ 2^R coded in M; g is random over M and lies in [p] (p ∈ G), so ν((B_m)_g) = 0 in N. Countable union over m. ✔

**(4.6).** For actual α ∈ J and every m: p ∈ G, p ⊩ Ȧ_{ẋ_{α,m}} ⊆ U(ċ_{α,m}), and c_{α,m} = F_m(g, z_α), so A_{x_{α,m}} ⊆ U_m(z_α) in M[G]. ✔

**Lemma 5.1.** μ(E^s) = Σ_m ν{z ∈ Ω₀ : m + ρ(z↾D) ∈ U(s)} = Σ_m λ(U(s) ∩ I_m) = λ(U(s)) < 1, using that z↾D is product‑distributed on 2^D ≅ 2^ω (D is a copy of ω), ρ is measure preserving, and ν(Ω₀) = 1. Fibers of x are null since ρ has null fibers. ✔ These identities are Borel/absolute, so they hold for the same codes in every N_j.

**Recursion (Section 5).** At stage j: C_j ∈ N_j Borel with μ(C_j) = ∞ (absolute); Lemma 2.1 in N_j gives Q_j of positive measure, hence some m_j with ν(H_j) > 0; the row ⟨z_{j,k}⟩_k is ν^ω‑random over N_j = M[G↾(R ∪ ⋃_{i<j,k} P_{α_{i,k}})] by Lemma 3.2 (its coordinate set is disjoint), so it avoids the null set "all coordinates miss H_j" and k_j exists; t_j = (m_j, z_{j,k_j}) ∈ Q_j (membership in a Borel set is absolute, and t ↦ μ(C_j ∖ E_t) is an absolute Borel function), so Lemma 2.2 in N_{j+1} gives μ(C_{j+1}) = ∞ with C_{j+1} ∈ N_{j+1}. For i < j, t_j ∈ C_{i+1} gives t_j ∉ E^{t_i} (so y_j ∉ U(t_i)), t_j ∉ E_{t_i} (so y_i ∉ U(t_j)) and y_j ≠ y_i. Since t_i, t_j are actual profiles, (4.6) gives A_{y_i} ⊆ U(t_i), A_{y_j} ⊆ U(t_j); hence y_j ∉ A_{y_i} and y_i ∉ A_{y_j}. The set {y_j : j < ω} is in M[G] (the recursion is definable there from G), infinite and independent, contradicting p ⊩ "no infinite independent set" with p ∈ G. ✔

**Section 6.** Corollary 1.2 is right: L ⊨ CH, force with 𝔹(ω₂ × ω), apply Theorem 1.1; Hechler under CH for ¬P. The displayed CH counterexample is correct.

## 2. Sanity checks run against the argument

* Constant envelopes U(s) = U (λ(U) < 1): Q(C) = {t ∈ C : x(t) ∉ U}, recursion picks points outside U — consistent.
* Envelopes that exclude only an ε‑neighbourhood of the own point inside its unit block: C_{j+1} keeps the ε‑neighbourhood and all other blocks; later points are either in other blocks or within ε and hence outside each other's envelopes — consistent with independence.
* Sets of ℵ₁ mutually random reals are non‑null in M[G] (each M[G]‑null Borel set is coded in a countable coordinate set), so a Hechler‑type family cannot keep λ*(A_y) < 1 in M[G]; the theorem is not contradicted by the obvious adversary.
* With only ω₁ random reals the pigeonhole in Prop. 3.4 fails and CH survives (Hechler applies), so the ω₂ hypothesis is used exactly where it must be.

## 3. Standard inputs the paper relies on (not re‑proved there; all textbook)

1. Elements of the measure algebra 𝔹(Θ) and names for reals have countable supports; Borel reading of names (Lemma 3.1).
2. Product/iteration factorization for measure algebras (Lemma 3.2), including that a coordinate block disjoint from Σ is 𝔹‑generic over M[G↾Σ] and that its generic is a random point of the corresponding product space avoiding all null Borel sets coded in M[G↾Σ].
3. Absoluteness of Borel codes, of Lebesgue/product measure of coded Borel sets, and of Borel functions between transitive models.
4. Maximum principle for complete Boolean algebras; outer regularity of Lebesgue measure.
5. Under CH, ℵ₁^{ℵ₀} = ℵ₁ (Δ‑system) and there are ℵ₁ Borel codes (pigeonhole).

## 4. Comparison with the previous draft

The earlier attempt (see `2026-08-15-audit-random-reals-draft-DP.md`) tried to run a selection lemma directly on the arbitrary sets B_x = {y : x ∈ A_y} via a density principle DP that is refutable in ZFC (Bernstein set), and its selection conclusion was itself refutable in ZFC (singleton family over a Lusin–Sierpiński partition). The present draft avoids both traps: the graph on which double counting is performed is Borel by construction (profiles carry the codes of open envelopes), and the "selection" invariant μ(C_j) = ∞ is maintained on the profile space, not on ℝ.

## 5. Bottom line for the formalization

The mathematical content that is genuinely new and self‑contained is Lemma 2.1 (+2.2) — fully elementary and Lean‑friendly — together with the profile encoding of Section 5. The heavy parts (measure‑algebra forcing, Δ‑system via elementary submodels, Borel absoluteness) are standard but far from Mathlib; a formalization needs a concrete presentation of random forcing (Boolean‑valued models — the choice made in this repository via Flypitch) before the argument can be transcribed.
