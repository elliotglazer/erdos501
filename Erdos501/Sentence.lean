/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# The first question of Erdős #501 as an `L_ZFC`-sentence

THIS FILE IS PART OF THE TRUSTED BASE OF THE COMPARATOR CHALLENGE and must be
audited by a human (see docs/COMPARATOR.md).

PENDING INTEGRATION of `Flypitch4/Erdos501/Sentence.lean` from the flypitch
patch (session 2026-08-16; builds, no sorry).  It provides
`Flypitch.Erdos501.Erdos501_f : sentence L_ZFC` — quantifying over all complete
ordered fields `(R,+,·,<,0,1)` given as sets; Bounded = ∃ m₁ m₂ ∈ R ∀ y ∈ S,
m₁<y<m₂; outer measure < 1 = ∃ a,b,s : ω → R with aₙ<bₙ, intervals cover S,
s 0 = 0, s(n+1)+aₙ = s n + bₙ, all s n ≤ r < 1; Infinite = ω injects into X;
Independent = ∀ x y ∈ X, x≠y → x ∉ A(y).  Built with a de-Bruijn-level
combinator layer (`Fm := ∀ n, bounded_formula L_ZFC n`).

Until then the declaration below is a `sorry` PLACEHOLDER so that the tree
builds.  Any comparator target whose statement mentions it therefore depends on
`sorryAx` and is rejected by the comparator (which walks the constants of the
statement) — the placeholder cannot be mistaken for the real sentence.
-/
import Flypitch4.Zfc

open Fol

namespace Flypitch.Erdos501

/-- PLACEHOLDER (see the file header): the `L_ZFC`-sentence expressing "every
family `(A_y)_{y ∈ ℝ}` of bounded sets of outer measure `< 1` has an infinite
independent set". -/
def Erdos501_f : sentence L_ZFC := sorry

end Flypitch.Erdos501
