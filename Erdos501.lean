/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Root module of the `Erdos501` development.  `Solution.lean` imports this.
See `docs/STATUS.md` for what each module proves and its state.
-/
-- Second question (closed sets of measure < 1): NPS87, infinite free set.
import Erdos501.Closed
-- First question, negative direction: Hechler's counterexample under CH.
import Erdos501.Hechler
-- ZFC core of the random-reals argument (paper §2–3): certificate ⇒ free set.
import Erdos501.ZFCCore.IcoPartition
import Erdos501.ZFCCore.Selection
import Erdos501.ZFCCore.Certificate
-- First-order rendering of the first question and its standard interpretation.
import Erdos501.Sentence
import Erdos501.Bridge
-- Forcing module (paper §4–5) over the Flypitch Boolean-valued universe.
import Erdos501.Forcing.RandomForcing
import Erdos501.Forcing.HomogeneousReading
import Erdos501.Forcing.DeltaSystem
import Erdos501.Forcing.ColRandom
-- Assembly: `independent ZFC Erdos501_f` and the faithfulness bridge.
import Erdos501.Independence
