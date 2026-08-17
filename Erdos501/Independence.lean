/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Assembly: independence of the first question of Erdős #501 from `ZFC`

Structure (mirrors `independence_of_CH` in `Flypitch4/Summary.lean`):

  neg_erdos501_f_unprovable  : ¬ (ZFC ⊢ₛ' ∼Erdos501_f)
      from  ⊤ ⊩[V 𝔹_random_succ_continuum] Erdos501_f   -- `𝔠⁺` random reals
                                                        -- (`Flypitch4/Erdos501/Main.lean`,
                                                        -- `neg_Erdos501_f_unprovable`)  DONE
  erdos501_f_unprovable      : ¬ (ZFC ⊢ₛ' Erdos501_f)
      from  ⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f              -- CH holds there (Flypitch,
                                                        -- `V_𝔹_collapse_models_CH`);
                                                        -- Hechler internalised.  OPEN (unit H3)
  erdos501_independent       : independent ZFC Erdos501_f :=
      ⟨erdos501_f_unprovable, neg_erdos501_f_unprovable⟩

  erdos501_sentence_faithful : stdStructure ⊨ₘ Erdos501_f ↔ erdos501_deepmind
      `Flypitch4/Erdos501/Bridge.lean`, `stdStructure_realize_Erdos501_f_iff`  DONE

See `docs/STATUS.md`.
-/
import Flypitch4.Erdos501.Main
import Flypitch4.Erdos501.Bridge
import Flypitch4.Summary

open Fol

namespace Erdos501

/-- `¬ (ZFC ⊢ₛ' ∼Erdos501_f)`: adding `𝔠⁺` random reals forces `Erdos501_f`
(`Flypitch.Erdos501.erdos501_of_random`), so by Boolean-valued soundness `ZFC`
does not derive its negation. -/
theorem neg_erdos501_f_unprovable :
    ¬ (ZFC ⊢ₛ' (bd_not Flypitch.Erdos501.Erdos501_f : sentence L_ZFC)) :=
  Flypitch.Erdos501.neg_Erdos501_f_unprovable

/-- OPEN (unit H3).  `¬ (ZFC ⊢ₛ' Erdos501_f)`, to be derived from
`⊤ ⊩[V 𝔹_collapse] ∼Erdos501_f` (Hechler's construction internalised in the
collapse extension, where `CH` holds by `V_𝔹_collapse_models_CH`). -/
theorem erdos501_f_unprovable : ¬ (ZFC ⊢ₛ' Flypitch.Erdos501.Erdos501_f) := by
  sorry

/-- Independence of the first question of Erdős #501 from `ZFC` (Flypitch's
`independent`): open exactly in its first component (`erdos501_f_unprovable`). -/
theorem erdos501_independent : independent ZFC Flypitch.Erdos501.Erdos501_f :=
  ⟨erdos501_f_unprovable, neg_erdos501_f_unprovable⟩

/-- Faithfulness of the first-order rendering (`Flypitch4/Erdos501/Bridge.lean`). -/
theorem erdos501_sentence_faithful :
    Flypitch.Erdos501.stdStructure ⊨ₘ Flypitch.Erdos501.Erdos501_f ↔
      Flypitch.Erdos501.erdos501_deepmind :=
  Flypitch.Erdos501.stdStructure_realize_Erdos501_f_iff

end Erdos501
