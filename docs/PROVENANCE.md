# Provenance of the components

Every Lean component in this repository was produced in a Claude session of the
"Formalizing Erdős 501" project (Elliot Glazer, Principia Labs, August 2026) or
vendored from a public repository.  This file records where each piece came
from, the pin it was originally verified at, and what happened to it on the way
into this repository.  Nothing here should be taken on faith: the axiom audit
(`scripts/check-axioms.sh`) and the comparator (`scripts/run-comparator.sh`) are
the ground truth.

## Unified pin

* Lean `leanprover/lean4:v4.34.0-rc1`
* Mathlib `355bc1e0ed1d36e49525121e1a280ca13a058a92` (master, 2026‑08‑16)

Reason for this choice: comparator HEAD (2026‑08‑11, `777e7f5`) walks the
kernel's built-in constants, which since Lean v4.34.0-rc1 include `eagerReduce`;
a challenge built with an older toolchain is rejected with
"Const not found in challenge: 'eagerReduce'".  Two of the components (NPS87,
Hechler) were already verified at exactly this Mathlib commit.

## Components

| component | files here | origin | original pin | verification at origin | port status |
|---|---|---|---|---|---|
| Flypitch Lean 4 port (FOL, ZFC, Boolean-valued models, Cohen/collapse forcing, `independence_of_CH`) | `Flypitch4/`, `Flypitch4.lean`, `third_party/flypitch4/` | https://github.com/ianklatzco/flypitch commit `ad649f8`, dir `flypitch4/` (Lean 4 port of Han–van Doorn's Flypitch; Apache 2.0) | Lean v4.30.0-rc2 / Mathlib `83a5988a25fdd78621774a57af7e1f5c55f24289` | audited 2026‑08‑16: full `lake build`; `#print axioms independence_of_CH` = standard; statement-level L3→L4 comparison faithful (`third_party/flypitch4/VALIDATION*.md`, `validation/`) | to 355bc1e: **done 2026‑08‑17** (proof/reducibility-level edits only, listed in `docs/PORTING-NOTES.md`; axiom audit re-run: standard axioms) |
| Measure algebra + random algebra + ¬CH via random reals (`MeasureAlgebra.lean`, `RandomAlgebra.lean`, `ForcingRandom.lean`, `SummaryRandom.lean`, `validation/DependencyCheck.lean`, `AUDIT.md`) | → `Flypitch4/` (planned) | session 2026‑08‑16, delivered as `flypitch4-random-algebra-and-erdos501.patch` against `ad649f8` | v4.30.0-rc2 / 83a5988 | 1053 lines, all compile, standard axioms only | **awaiting the patch file** |
| First-order sentence `Erdos501_f`, `𝔹_col_random`, bridge spec, forcing units F3–F5 (`Sentence.lean`, `ColRandom.lean`, `Bridge.lean`, `RandomForcing.lean`, `HomogeneousReading.lean`, `DeltaSystem.lean`, `validation/Erdos501Audit.lean`, `validation/Erdos501Print.lean`) | → `Erdos501/Sentence.lean`, `Erdos501/Bridge.lean`, `Erdos501/Forcing/*.lean` (planned) | same patch (dir `flypitch4/Flypitch4/Erdos501/`) | v4.30.0-rc2 / 83a5988 | builds; sorries exactly: `erdos501_of_col_random`, `neg_Erdos501_f_unprovable`, `stdStructure_realize_Erdos501_f_iff`, `delta_system_countable`, and `homogeneous_reading` through F3 | **awaiting the patch file** |
| ZFC core (Lemma 2.1/2.2, Def 3.1, Thm 3.2) | → `Erdos501/ZFCCore/*.lean` (planned) | session 2026‑08‑16, delivered as `erdos501-zfc-core.zip` | v4.30.0-rc2 / 83a5988 | sorry-free; axioms standard | **awaiting the zip** |
| NPS87 closed case (`IsFreeSet`, `exists_infinite_isFreeSet`, `erdos501`, `erdos501_three`) | → `Erdos501/Closed.lean` | session 2026‑08‑16, delivered as `Erdos501.lean` + Lake scaffold | v4.34.0-rc1 / 355bc1e | sorry-free; axioms standard | **awaiting the file** (no port needed) |
| Hechler CH counterexample (`hechler_of_CH`, `erdos_501.variants.hechler_CH`) | → `Erdos501/Hechler.lean` | session 2026‑08‑16/17, delivered as `Hechler501FC_master.lean` (+ `Hechler501FC_a3a10db.lean` at the formal-conjectures pin, + `formal-conjectures-501-hechler-patch.md`) | v4.34.0-rc1 / 355bc1e (and v4.27.0 / a3a10db) | sorry-free; axioms standard | **awaiting the file** (no port needed) |
| Statement shapes | `Challenge.lean` | `google-deepmind/formal-conjectures` `FormalConjectures/ErdosProblems/501.lean` at `e7f4b0e` (Apache 2.0); audited 2026‑08‑16 (`docs/audits/…formal-conjectures…`) | v4.27.0 / a3a10db | statements re-typed here, no code copied | n/a |
| Papers | `docs/paper/erdos501_random_profiles_rev09.pdf`, `…_rev10.pdf` | E. Glazer, "Erdős Problem 501 after adding ω₂ random reals", drafts rev09/rev10 (2026‑08‑16) | — | audited (`docs/audits/`) | — |

## Renames known to be needed when porting 83a5988 → 355bc1e

Collected from the sessions that built at both ends (non-exhaustive; the build
is the arbiter):

* `Prod.mk` → `prodMk` in measure-theory names (`measurable_prodMk_left/right`,
  `measurable_measure_prodMk_left`, `Measurable.prodMk`);
* `not_mem` → `notMem` (`indicator_of_notMem`, `Set.eq_empty_iff_forall_notMem`);
* `Mathlib.MeasureTheory.Constructions.Prod.Basic` → `Mathlib.MeasureTheory.Measure.Prod`;
  `lintegral_count` lives in `Integral.Lebesgue.Countable`;
  `Integral.Lebesgue` → `Integral.Lebesgue.Basic`;
* `push_neg` deprecated in favour of `push Not`; `Set.mem_setOf_eq` → `Set.mem_ofPred_eq`
  in some contexts;
* `Cardinal.exists_ord_eq`, `le_aleph0_iff_set_countable` + `lt_aleph_one_iff`,
  implicit `r` in `card_typein_lt`, `WellFounded.not_lt_min` without the
  `Nonempty` argument (a3a10db → 355bc1e; the intermediate 83a5988 state is
  unknown).
