-- Root module. Import ported files here as they land.
import Flypitch4.ToMathlib
import Flypitch4.SetTheoryExt
import Flypitch4.BvTauto
import Flypitch4.Colimit
import Flypitch4.Fol
import Flypitch4.PSetOrdinal
import Flypitch4.Bfol
import Flypitch4.Compactness
import Flypitch4.RegularOpenAlgebra
import Flypitch4.Bvm
import Flypitch4.BvmExtras
import Flypitch4.BvmExtras2
import Flypitch4.Completion
import Flypitch4.CantorSpace
import Flypitch4.LanguageExtension
import Flypitch4.Forcing
import Flypitch4.Collapse
import Flypitch4.Henkin
import Flypitch4.AlephOne
import Flypitch4.ForcingCH
import Flypitch4.Completeness
import Flypitch4.Zfc
import Flypitch4.PrintFormula
import Flypitch4.Summary
-- Alternative consistency proof of ¬CH via the ℵ₂-random algebra
import Flypitch4.MeasureAlgebra
import Flypitch4.RandomAlgebra
import Flypitch4.ForcingRandom
import Flypitch4.SummaryRandom
-- Erdős problem #501 (first question): first-order sentence and the assertion that
-- `Col(ω₁, ℝ) ∗ (ω₂ random reals)` forces a positive answer (statement only, proof `sorry`)
import Flypitch4.Erdos501.Sentence
import Flypitch4.Erdos501.ColRandom
import Flypitch4.Erdos501.Bridge
-- Erdős #501: the proof plan's units (F4) Theorems 4.1, 4.2 (`RandomForcing`, proved), (F3)
-- Theorem 4.3 (`DeltaSystem`, proved), (F4) Prop. 4.4 (`HomogeneousReading`, proved),
-- (F5) Theorem 4.5 (`RandomForcing`, `BorelNames`, proved)
import Flypitch4.Erdos501.RandomForcing
import Flypitch4.Erdos501.DeltaSystem
import Flypitch4.Erdos501.HomogeneousReading
-- names for Borel sets of reals/profiles in `V (randomAlgebra ι)`, and Theorem 4.5 with names
import Flypitch4.Erdos501.BorelNames
-- the ZFC core: (F1) Lemmas 2.1, 2.2 and (F2) Definition 3.1 + Theorem 3.2 (proved)
import Flypitch4.Erdos501.ZFCCore
-- binary expansion is measure preserving: (P2) for the profile test points (step S1 of PLAN.md)
import Flypitch4.Erdos501.BinaryExpansion
-- the Boolean value of `Erdos501_f` in `V 𝔹`, unfolded into predicates on names (`Sem.*`)
import Flypitch4.Erdos501.Semantics
-- the internal reals `Rdot` of `V (randomAlgebra ι)` form a complete ordered field (step S2)
import Flypitch4.Erdos501.InternalReals
-- reading internal reals, sequences and the internal outer-measure hypothesis as Borel data (S3)
import Flypitch4.Erdos501.RealReading
-- the homogeneous envelopes of the values `A(x_{m,α})` at the profile test points (S4)
import Flypitch4.Erdos501.Envelopes
-- measurable selection of profiles from fullness (infrastructure for the recursion, S6)
import Flypitch4.Erdos501.Selection
-- the recursion of Theorem 3.2 in the ground model, pointwise in the generic point (S6, part 1)
import Flypitch4.Erdos501.Recursion
-- the name of the infinite independent set and `erdosProperty_Rdot` (S6, part 2)
import Flypitch4.Erdos501.Assembly
-- the main theorems: `erdos501_ex_forced`, `neg_Erdos501_ex_f_unprovable` (proved), (F8), `erdos501_of_random`
import Flypitch4.Erdos501.Main
-- (F8), part 1: internal complete ordered fields — dyadics, Archimedean property, density
import Flypitch4.Erdos501.InternalField
-- (F8), part 2: the internal isomorphism `F ≅ Rdot` (readings of dyadic cuts, `psi`, its properties)
import Flypitch4.Erdos501.InternalIso
-- (F8), part 3: transport of the Erdős property along `psi`; `erdos501_forced : ⊤ ⊩ Erdos501_f`
import Flypitch4.Erdos501.Transfer
-- the bridge, part 1: the standard structure on `ZFSet` and the two-valued unfolding of `Erdos501_f`
import Flypitch4.Erdos501.StdSemantics
-- the bridge, part 2: `ℝ` as a complete ordered field in `ZFSet`; standard model ⇒ DeepMind
import Flypitch4.Erdos501.RealsInZFSet
-- the bridge, part 3: internal complete ordered fields ≅ `ℝ`; DeepMind ⇒ standard model
import Flypitch4.Erdos501.ZFSetCOF
