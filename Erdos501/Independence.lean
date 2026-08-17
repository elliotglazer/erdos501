/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Assembly: independence of the first question of Erdős #501 from `ZFC`

Intended structure (mirrors `independence_of_CH` in `Flypitch4/Summary.lean`):

  erdos501_f_unprovable      : ¬ (ZFC ⊢ₛ' Erdos501_f)
      from  ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f          -- CH holds there (Flypitch,
                                                    -- `V_𝔹_collapse_models_CH`);
                                                    -- Hechler internalised.  OPEN
  neg_erdos501_f_unprovable  : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)
      from  ⊤ ⊩[V 𝔹_col_random] Erdos501_f          -- `erdos501_of_col_random`,
                                                    -- units (F3)–(F7).      OPEN
  erdos501_independent       : independent ZFC Erdos501_f :=
      ⟨erdos501_f_unprovable, neg_erdos501_f_unprovable⟩

  erdos501_sentence_faithful : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind
                                                                          OPEN

Both directions of the independence need a *transfer* of a Mathlib-level
theorem (Hechler, resp. Theorem 3.2 of the paper) into the Boolean-valued
universe; see docs/STATUS.md, unit (F7).
-/
import Erdos501.Sentence
import Erdos501.Bridge
import Erdos501.Forcing.ColRandom
import Flypitch4.Summary

open Fol

namespace Erdos501

/-- OPEN.  `¬ (ZFC ⊢ₛ' Erdos501_f)`, to be derived from
`⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f`. -/
theorem erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Flypitch.Erdos501.Erdos501_f) := by
  sorry

/-- OPEN.  `¬ (ZFC ⊢ₛ' ∼Erdos501_f)`, to be derived from
`erdos501_of_col_random : ⊤ ⊩[V 𝔹_col_random] Erdos501_f`. -/
theorem neg_erdos501_f_unprovable :
    ¬ (ZFC ⊢ₛ' (bd_not Flypitch.Erdos501.Erdos501_f : sentence L_ZFC)) := by
  sorry

theorem erdos501_independent : independent ZFC Flypitch.Erdos501.Erdos501_f :=
  ⟨erdos501_f_unprovable, neg_erdos501_f_unprovable⟩

/-- OPEN.  Faithfulness of the first-order rendering. -/
theorem erdos501_sentence_faithful :
    Flypitch.Erdos501.stdStructure ⊨ₘ Flypitch.Erdos501.Erdos501_f ↔
      Flypitch.Erdos501.erdos501_deepmind := by
  sorry

end Erdos501
