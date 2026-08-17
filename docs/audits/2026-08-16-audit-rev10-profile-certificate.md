# Audit of rev10 — "profile certificate" refactor of the ω₂‑random‑reals proof

(Session audit, 2026‑08‑16; the paper is `docs/paper/erdos501_random_profiles_rev10.pdf`.)

## Verdict

Correct. The refactor preserves the rev09 argument and improves it in two places, both of which I checked in detail:

1. **The recursion is now a pure ZFC theorem** (Theorem 3.2: Prof(𝒜) → Free_ω(𝒜)). All forcing has been pushed into a single hypothesis, ν*(Z) = 1, and Lemma 4.5 shows the actual profiles satisfy it in the extension. This replaces the fresh‑row / intermediate‑model bookkeeping of rev09, and it is a genuine simplification, not just a repackaging.
2. **The conull set Ω₀ has been eliminated** by Borel truncation (5.8): the envelope code is replaced by a code for ∅ wherever the raw code has measure ≥ 1, so (P3) holds for *every* z, and for the actual profiles the truncation is inert because p already forces the bound.

The logical decomposition (1.1) is valid: the first line is a theorem of ZFC, so it holds in the extension, and composing with the second line gives 𝔹_{ω₂} ⊩ (∀y λ*(A_y) < 1 → Free_ω(𝒜)). One caveat about what "compose only at the end" costs in a Boolean‑valued (Flypitch‑style) formalization is in §4.

---

## 1. The ZFC core (Sections 2–3) — verified line by line

**Lemma 2.1 (with general K).** Correct. If Q(C) were null, take D ⊆ C ∖ Q(C) with K < μ(D) < ∞, D_k ↑ D gives d = μ(D_k) > K, and for large n, (M_n − k)d > K·M_n. Double counting E ∩ (D_k × C_n) gives (M_n − k)d ≤ ∫_{C_n} μ(E^s ∩ D_k) ≤ K·M_n. Contradiction. (K = 0 and K < 1 are also fine.) ✔

**Lemma 2.2.** ✔ (μ(C∖E_t) = ∞, μ(E^t) ≤ K, fiber null.)

**Definition 3.1.** Coherent. (3.1) ⇔ Z meets every positive‑measure Borel subset of Ω, which is the only use. (P2) gives both the section computation and null fibers of x. (P3) is required for all z ∈ Ω (this is what the truncation buys). (P4) is the only place the arbitrary family enters.

**Theorem 3.2.** Correct.
* S = ℤ × Ω with μ = counting × ν is σ‑finite with μ(S) = ∞; E = {(t,s) : x(t) ∈ V(s)} is Borel because x, c_m are Borel and the coding makes "a ∈ U(c)" Borel.
* (3.8): μ(E^s) = Σ_m ν{z : x_m(z) ∈ V(s)} = Σ_m λ(V(s) ∩ I_m) = λ(V(s)) < 1 by (P2), (P3). Fibers of x are null by (P2) with B = {a}. So Lemmas 2.1/2.2 apply with K = 1.
* Recursion: Q(C_j) has positive μ‑measure ⇒ some m_j with ν(H_j) > 0 ⇒ Z ∩ H_j ≠ ∅ by (3.1); t_j ∈ Q(C_j); C_{j+1} infinite by Lemma 2.2, Borel.
* Independence: t_j ∈ C_{i+1} gives (t_j,t_i) ∉ E, (t_i,t_j) ∉ E and x(t_j) ≠ x(t_i); with (P4) for z_i, z_j ∈ Z this yields y_j ∉ A_{y_i}, y_i ∉ A_{y_j}. ✔

Note that it no longer matters whether a profile z ∈ Z is reused at a later stage with a different m, or how H_j depends on earlier choices: (3.1) is a property of Z against *all* positive Borel sets of the ambient universe.

Sanity check that the ZFC core is not too strong: under CH, Hechler's family has no certificate (else Theorem 3.2 would contradict Hechler); the obstruction is exactly that a Borel choice z ↦ c(z) of envelopes valid on a full‑outer‑measure set of test points does not exist for that family. Nothing in the paper claims otherwise.

---

## 2. The forcing module (Sections 4–5)

**Lemmas 4.1–4.3, Prop. 4.4.** Unchanged from rev09 (Borel reading, factorization, Δ‑system under CH via elementary chains + Fodor, homogeneous reading with pigeonhole over ℵ₁ Borel maps). All fine; see the rev09 audit for the details.

**Lemma 4.5 (fresh‑profile fullness).** Correct, and it is the right lemma. Proof check: if q ⊩ "Ḃ is Borel, ν(Ḃ) > ε, Ḃ ∩ {ż_β : β ∈ J} = ∅", let T be a countable support of q and of the code of Ḃ; pick α ∈ J with P_α ∩ T = ∅ (T meets only countably many disjoint petals). In 𝔹(T ⊔ P_α) = 𝔹(T) ⊗ 𝔹(P_α), the Boolean value q ∧ ‖ż_α ∈ Ḃ‖ is the class of {(t,z) : t ∈ [q], z ∈ B_t}, of measure ∫_{[q]} ν(B_t) dμ_T ≥ ε μ_T([q]) > 0 (q ⊩ ν(Ḃ) > ε means ν(B_t) > ε for a.e. t ∈ [q]). So some r ≤ q forces ż_α ∈ Ḃ, contradicting q ⊩ ż_α ∉ Ḃ. By the maximum principle this shows ⊩ ν*(Z) = 1. The extra coordinates Γ play no role beyond being allowed inside T. ✔ (Intuition: countably many of the α's disjoint from T form a ν^ω‑random sequence over M[G↾T], which cannot avoid a positive‑measure set coded there.)

**Theorem 5.1.** Correct.
* (5.4) by outer regularity + maximum principle, using p ⊩ ∀y λ*(A_y) < 1; mixing makes ẇ_α a name for an element of 𝒪^ℤ.
* Prop. 4.4 gives F; (5.6) defines the profiles; Lemma 4.5 (with Γ = Θ ∖ ⋃P_α) gives (5.7).
* Truncation (5.8): c_m is Borel (λ∘U is Borel) and (5.9) holds for all z. For z = z_α: c⁰_m(z_α) = F_m(g,z_α) = c_{α,m} by (4.2) evaluated at G, and p ∈ G gives λ(U(c_{α,m})) < 1 and A_{x_{α,m}} ⊆ U(c_{α,m}), with x_{α,m} = m + ρ(z_α↾D) = x_m(z_α) because π_α carries the enumeration of D to that of D_α. So (5.11) holds and the truncation is inert on Z.
* (P2) for x_m(z) = m + ρ(z↾D): the D‑marginal of ν is the fair‑coin measure on 2^D ≅ 2^ω and ρ is measure preserving, so ν(x_m^{-1}(B)) = λ((B − m) ∩ [0,1)) = λ(B ∩ I_m). ✔
* Hence (2^P, ν), Z, ⟨x_m, c_m⟩ is a certificate in M[G]; since p and G ∋ p are arbitrary, (5.1) follows. ✔

**Theorem 1.1 / Corollary 1.2.** Follow as stated. ✔

---

## 3. What the refactor changed, and why each change is sound

| rev09 | rev10 | Status |
|---|---|---|
| Ω₀ conull via Fubini + genericity of g (Lemma 4.1) | Borel truncation of the code (5.8) | ✔ simpler; (P3) now holds for all z, and Lemma 5.1's "ν(Ω₀)=1" is no longer needed |
| Fresh rows z⃗_j random over N_j; absoluteness of codes across N_j | ν*(Z) = 1 in M[G] (Lemma 4.5); recursion runs in one universe | ✔ Lemma 4.5 is strictly stronger than what the row argument used, and its proof is a one‑paragraph Boolean‑value computation |
| Recursion inside the forcing proof | Recursion is Theorem 3.2, a ZFC theorem about certificates | ✔ the forcing proof only has to exhibit the certificate |
| Lemma 2.1 with bound 1 | Lemma 2.1 with bound K | ✔ harmless generalization; would let (P3) be weakened to λ(U(c_m(z))) < K, giving the uniformly‑bounded‑outer‑measure variant for free |

---

## 4. Formalization boundary — one caveat and some suggestions

**The caveat: composing "at the end" is a transfer step, not a free step.** Line 1 of (1.1) is a ZFC theorem, and line 2 is a Boolean‑valued statement about 𝔹_{ω₂}. Mathematically, ZFC ⊢ φ implies 𝔹 ⊩ φ, so the composition is immediate. Formally, in a Flypitch‑style development (which is what the project's `flypitch4/` port with `𝔹_random` suggests), that implication is *soundness for first‑order derivations*: it applies to a `prf`‑term, not to a Lean/Mathlib proof of Theorem 3.2. So "formalize the two lines independently and compose at the end" is only literally true if either (a) Theorem 3.2 is re‑derived inside the Boolean‑valued universe (Boolean‑valued measure theory on names — heavy), or (b) one works with a set model M[G] and shows the recursion of Theorem 3.2 can be run *inside* M[G] with the resulting X ∈ M[G] (needs canonical choices, e.g. W‑least witnesses for a well‑order W ∈ M[G], plus absoluteness of the Borel steps), or (c) a first‑order proof term for Theorem 3.2 is produced (impractical). None of this is a flaw in the paper — the mathematics is right — but the parallelization claim in §1 and §6 should be read as "the two halves can be developed independently; the glue is a nontrivial third unit". Concretely I would add a unit (F7): "transfer of Theorem 3.2 into the forcing model", and decide early which of (a)/(b) the Lean development will use, since it dictates how Prof(𝒜) has to be stated (as a bSet formula vs. as a Lean predicate on objects of a transitive model).

**Suggestions that keep the mathematics identical but ease formalization.**
* Fix Ω := Cantor space with the fair‑coin measure in Definition 3.1 (the interface produces 2^P with P countably infinite, Borel‑isomorphic to it), and state (3.1) as "Z meets every Borel set of positive measure" to avoid outer measure entirely.
* Replace the coding space 𝒪 by c_m : Ω → (ℚ × ℚ)^ℕ with U(c) = ⋃_n (q_n, q'_n); then "a ∈ U(c)" and c ↦ λ(U(c)) are visibly Borel (Mathlib‑friendly), and the truncation (5.8) is a Borel case split on a Borel function.
* In Section 5, the "Let G ∋ p be generic … in M[G]" phrasing will have to become Boolean‑value computations if the target is bSet; Lemma 4.5 and Prop. 4.4 are already written that way in substance, and Theorem 5.1's content is: p ≤ ‖Prof(𝒜̇)‖ witnessed by the names Ω̌, ν̌, Ż = {ż_α}, ẋ_m, ċ_m. Worth stating the theorem in that form.
* Lemma 4.3 could cite the classical Δ‑system lemma (κ = ω₂, sets of size < ω₁, CH ⇒ ℵ₁^{ℵ₀} = ℵ₁) rather than elementary submodels + Fodor; the classical proof is far easier to formalize.
* Since Lemma 2.1 already carries K, consider stating Definition 3.1 with a parameter K in (P3); Theorem 3.2 then covers families with sup_y λ*(A_y) < K at no cost, matching the abstract's remark that boundedness is unnecessary.

**Presentation nits.** Autoref prints "theorem" for lemmas/propositions throughout; (1.1) second line should show the ∀𝒜 that Theorem 5.1 has; in Lemma 2.1 the proof's "K < μ(D) < ∞" and "(M_n − k)d > K M_n" are exactly right but a one‑line reason for the latter (d > K) would help.

---

## 5. Bottom line

rev10 is a correct and cleaner presentation of the rev09 argument. The ZFC core (F1)–(F2) is fully elementary and I would expect it to be the easiest part to formalize; (F3) is standard combinatorics; (F4)–(F6) are standard random‑forcing facts stated in a form that matches a measure‑algebra Boolean‑valued model. The only thing I would change in the *plan* is to budget explicitly for transferring the ZFC core into the forcing model.
