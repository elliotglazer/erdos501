import Flypitch4.SummaryRandom

/-!
This file is intentionally outside the `Flypitch4` library tree. Run it with:

  lake env lean validation/DependencyCheck.lean

It computes the set of constants transitively used by the two proofs of the unprovability of
`CH_f` and reports whether selected constants occur in them.  In particular it shows that the
random-algebra proof `CH_f_unprovable_random` does not depend on the Cohen algebra
(`𝔹_cohen`, `𝔹_CCC`, `bSet.cohen_real.*`, `bSet.neg_CH`), while both proofs share the generic
Boolean-valued-model infrastructure (`bSet_models_ZFC`, `bSet.AE_of_check_larger_than_check`,
`bSet.not_CCC_of_uncountable_fiber`).
-/

open Lean Elab Command

elab "#deps " id:ident : command => do
  let env ← getEnv
  let n ← liftCoreM (realizeGlobalConstNoOverload id)
  let mut visited : NameSet := {}
  let mut stack : List Name := [n]
  while !stack.isEmpty do
    let c := stack.head!
    stack := stack.tail!
    if visited.contains c then continue
    visited := visited.insert c
    if let some ci := env.find? c then
      for d in ci.getUsedConstantsAsSet.toList do
        if !visited.contains d then stack := d :: stack
  let probes : List Name := [`𝔹_cohen, `𝔹_CCC, `bSet.cohen_real.mk, `bSet.cohen_real.inj,
    `bSet.neg_CH, `bSet.neg_CH₂, `collapse_algebra.𝔹_collapse,
    `Flypitch.𝔹_random, `Flypitch.MeasureAlgebra.CCC_measureAlgebra,
    `Flypitch.RandomAlgebra.iInf_biimp_χ_eq_bot, `MeasureTheory.Measure.infinitePi,
    `bSet.neg_CH_of_CCC_of_indep,
    `bSet.AE_of_check_larger_than_check, `bSet.not_CCC_of_uncountable_fiber, `bSet_models_ZFC,
    `sorryAx]
  let mut msg := m!"{id} depends on {visited.size} constants.\n"
  for p in probes do
    msg := msg ++ m!"  {p}: {visited.contains p}\n"
  logInfo msg

#deps CH_f_unprovable
#deps CH_f_unprovable_random
