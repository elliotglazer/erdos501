# Porting notes: Lean v4.30.0-rc2 / Mathlib 83a5988 → Lean v4.34.0-rc1 / Mathlib 355bc1e

Recorded while forward-porting the Flypitch4 library, the random-algebra
additions and the forcing development `Flypitch4/Erdos501/*` (2026‑08‑17).
Every issue is listed with the fix that worked; the axiom audits before and
after the port are identical (`docs/STATUS.md`).

## Lean 4.34 tightened transparency in `simp` / `dsimp` / `rw`

The recurring theme: `simp` and `rw` now unify the binders of a lemma with the
goal at **reducible** transparency and check the resulting application at that
transparency.  Terms that are only well-typed up to unfolding a plain `def`
("`x : (V β).carrier` where `bSet β` is expected", "`n : ULift ℕ` where
`(mk ν).type` is expected") make the tactic fail with

* `simp made no progress` (sometimes with a hidden `Full error: Application type
  mismatch …`), or
* `Tactic rewrite failed: Did not find an occurrence of the pattern …`
  (again with `Full error: Application type mismatch`).

Remedies used, in order of preference:

1. Make type-level aliases `@[reducible]` when they are meant to be transparent:
   `bounded_term`, `closed_preterm`, `closed_term` (Fol.lean); `bSet.type`
   (Bvm.lean); `cohen_real.mk` (Forcing.lean, written out as an explicit
   `⟨ULift ℕ, …, …⟩`, definitionally the old `set_of_indicator … omega …`).
   Do **not** make a def reducible if it hides an implicit argument that simp
   lemmas must recover by first-order unification (making `set_of_indicator`
   reducible broke every `set_of_indicator_*` rewrite whose `u` was itself
   reducible, e.g. `prod x y`).
2. Restate `rfl` simp lemmas so the binder has the *syntactic* type occurring in
   goals: `{i : (set_of_indicator f).type}` instead of `{i : u.type}`,
   `{k : (omega : bSet 𝔹).type}` instead of `{k : ULift ℕ}`.
3. Where the goal mixes types, `show`/`change` to a well-typed statement (defeq is
   checked at default transparency), or finish with `exact term` / `erw`.
4. `simp only [foo] at *` that no longer does anything → `try simp only …`.
5. Definitional facts previously closed by `simp [universal_map_property, …]`
   → `rfl` / `exact congrArg₂ … h₁ h₂` (Henkin.lean surjectivity cases).

### The same theme in the forcing files (`Flypitch4/Erdos501/*`)

6. **Proof terms inside statements must be syntactically well-typed.**  When
   `simp`/`rw` instantiate a lemma whose statement contains a proof term
   (`MeasureAlgebra.mk μ s hs`, `mkReal F hF`, `realName f hf`), the
   instantiated application is now checked at reducible transparency; a proof
   whose *inferred* type only matches the expected one after unfolding a `def`
   makes the tactic fail with `simp made no progress` / `Did not find an
   occurrence` and a hidden `Full error: Application type mismatch` or
   `function expected`.  Fixes used:
   * `(hf.prodMk hg) hB` (applying a `Measurable` proof as a function, needs
     unfolding `Measurable`) → `hB.preimage (hf.prodMk hg)` (BorelNames);
   * `hop.comp (hf.prodMk hg) : Measurable (uncurry op ∘ …)` where
     `Measurable fun x => op (f x) (g x)` is expected → a helper lemma stated
     with the expected type, `measurable_op2 hop hf hg` (InternalReals), and
     likewise `measurable_uncurry_add/mul : Measurable (Function.uncurry (·+·))`
     instead of `measurable_add : Measurable fun p => p.1 + p.2` as the `hop`
     of `plusDot`/`timesDot`;
   * `hs.inter ht : MeasurableSet (s ∩ t)` where `MeasurableSet {x | p x ∧ q x}`
     is expected → `measurableSet_setOf_and hp hq` (RealReading, `hbdd`);
   * a `_` for a proof argument that unification no longer fills (because the
     reducible `mkReal` unfolds and proof irrelevance hides the metavariable):
     give it explicitly (`mkReal_definite (measurable_code.comp hf)`).
7. Binder restatement (item 2) for every name `⟨T, func, bval⟩`:
   `borelName_func/bval`, `profilesName_*`, `Rdot_*`, `ltDot_*`, `opDot_*`,
   `openName_*`, `valSet_*`, `Xname_*`, `fname_*`, `imgSet_*` now take
   `(i : (name …).type)`; a coercion `π a` for `a : J` then has to be written
   `π a.1`.  Where a `simp only [name_bval, …]` still cannot fire because the
   *goal's* index has the "wrong" type (`a : J` introduced before
   `le_iSup_of_le`), replace the `simp` by `change`/`exact` with the explicit
   term (`exact le_inf le_rfl (le_of_eq (bv_eq_refl _).symm)`, RealReading
   `of_nat_mem_set_of_indicator_omega`, BorelNames `iSup_mem_profilesName`).
8. `rw [← sdiff_eq]` picked the `Set` lemma; write
   `← @sdiff_eq (randomAlgebra ι) _ _ _`.
9. Big `simp only [...]` unfoldings of `⟦Erdos501_f⟧` no longer close the goal
   by themselves: finish with `rfl` / `exact Iff.rfl` (Semantics, StdSemantics).
10. `rw [inv', dif_neg h]` on a projection of a `dite`: `have e := dif_neg h`
    with the explicit statement, then `show (inv' x).1 = _; rw [e]` (ZFSetCOF).
11. `set_of_indicator … omega …` definitions (`cohen_real.mk`, `random_real.mk`,
    `mkReal`) rewritten as explicit `@[reducible]` structure literals
    `⟨ULift ℕ, fun n => of_nat n.down, …⟩` with an `example … := rfl` recording
    the definitional equality.

## Other API changes hit

| old | new |
|---|---|
| `Ordinal.limitRecOn` alternative `succ` (motive `succ o`) | alternative `add_one` (motive `o + 1`); use `Ordinal.add_one_eq_succ` |
| `Finset.toSet` | gone; shim `abbrev Finset.toSet s := (s : Set α)` in `Flypitch4/ToMathlib.lean` |
| `@[reducible, instance] def b_setoid (Γ : 𝔹) : Setoid (bSet 𝔹)` | instances with un-inferable arguments are now errors; dropped `instance` (it was never usable by TC) |
| `let r := WellOrderingRel …; haveI : IsWellOrder _ r := …` inside a proof | TC got "stuck"; use `obtain ⟨r, hr⟩ : ∃ r, IsWellOrder _ r := ⟨WellOrderingRel, WellOrderingRel.isWellOrder⟩` |
| `simpa [Lhom.comp] using this` for `(g.comp f).on_term t = g.on_term (f.on_term t)` | `exact this.trans (congrFun (Lhom.comp_on_term _ _) _)` |
| `Mathlib.SetTheory.Cardinal.Cofinality` import | deprecated import name (warning only) |
| `if_true/if_false`, `dif_pos/dif_neg`, `push_neg`, `Set.mem_setOf_eq` | deprecated (warnings): `ite_true/ite_false`, `dite_eq_left/right`, `push Not`, `Set.mem_ofPred_eq` |
| `Set.restrict` (`T.restrict x`, `T : Set ι`) | `Set.domRestrict` (92 occurrences in `Flypitch4/Erdos501/*`; `Measure.restrict` unchanged) |
| `le_bihimp_iff : a ≤ b ⇔ c ↔ a ⊓ b ≤ c ∧ a ⊓ c ≤ b`, `le_bihimp` | now `to_dual`-generated with the other orientation; old shape re-stated as private lemmas in `Transfer.lean` |
| `mul_le_mul_right'` | `mul_le_mul_left` (ZFC core) |
| `Cardinal.countable_iff_lt_aleph_one` | deprecated; `le_aleph0_iff_set_countable` + `lt_aleph_one_iff` |
| `Set.Infinite.diff` | `Set.Infinite.sdiff` |

Mathlib names known from the sessions that built the other components at both
pins are in `docs/PROVENANCE.md` (`prodMk`, `notMem`, module moves).
