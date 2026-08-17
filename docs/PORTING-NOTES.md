# Porting notes: Lean v4.30.0-rc2 / Mathlib 83a5988 → Lean v4.34.0-rc1 / Mathlib 355bc1e

Recorded while forward-porting the Flypitch4 library (2026‑08‑17).  The same
issues will show up when the ZFC core and the flypitch patch files (random
algebra, `Erdos501/*`) are ported, so they are listed with the fix that worked.

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

Mathlib names known from the sessions that built the other components at both
pins are in `docs/PROVENANCE.md` (`prodMk`, `notMem`, module moves).
