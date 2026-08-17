/-
Axiom audit for the NPS87 formalization (`Erdos501/Closed.lean`).

Run from the project root (after `lake build`):
  lake env lean validation/Erdos501Axioms.lean
Every `#print axioms` line must report exactly `[propext, Classical.choice, Quot.sound]`
(in particular no `sorryAx`).
-/
import Erdos501

#check @Erdos501.exists_infinite_isFreeSet
#check @Erdos501.erdos501
#check @Erdos501.erdos501_three
#check @Erdos501.erdos501_pairwise
#check @Erdos501.erdos501_ncard_three

#print axioms Erdos501.exists_infinite_isFreeSet
#print axioms Erdos501.erdos501
#print axioms Erdos501.erdos501_three
#print axioms Erdos501.erdos501_pairwise
#print axioms Erdos501.erdos501_ncard_three
