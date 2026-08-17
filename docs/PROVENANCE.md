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
| Measure algebra + random algebra + ¬CH via random reals (`MeasureAlgebra.lean`, `RandomAlgebra.lean`, `ForcingRandom.lean`, `SummaryRandom.lean`, `validation/DependencyCheck.lean`, `AUDIT.md`) | `Flypitch4/{MeasureAlgebra,RandomAlgebra,ForcingRandom,SummaryRandom}.lean`, `validation/DependencyCheck.lean`, `third_party/flypitch4/AUDIT.md` | forcing session 2026‑08‑16/17, delivered in `erdos501leansources.zip` (tree `flypitch4/` on top of `ad649f8`) | v4.30.0-rc2 / 83a5988 | all compile, standard axioms only | **integrated and ported 2026‑08‑17** (`cohen_real.mk`/`random_real.mk` written as explicit reducible constructors; see `docs/PORTING-NOTES.md`) |
| Forcing development for #501: sentence `Erdos501_f`, semantics, random forcing units F3–F8, main theorems `erdos501_of_random`, `neg_Erdos501_f_unprovable`, bridge `stdStructure_realize_Erdos501_f_iff`, and the collapse direction `OmegaClosed.lean`, `CheckReals.lean`, `Hechler.lean` (`neg_erdos501_forced_collapse`, `Erdos501_f_unprovable`, `independence_of_Erdos501`) (`Flypitch4/Erdos501/*.lean`, 27 modules, `validation/Erdos501Audit.lean`, `validation/Erdos501Print.lean`, `PLAN.md`, `README.md`) | `Flypitch4/Erdos501/`, `validation/Erdos501Audit.lean`, `validation/Erdos501Print.lean`, `third_party/flypitch4/{AUDIT.md,erdos501-patch-MANIFEST.md,erdos501-audit-output-83a5988.txt}` | forcing session, delivered as `erdos501leansources.zip` (24 modules, 2026‑08‑17 morning) and `erdos501leansources_1.zip` (+3 modules of the collapse direction, 2026‑08‑17) — the cumulative patch `flypitch4-random-algebra-and-erdos501.patch` against `ad649f8` (41 files, 16205 insertions) | v4.30.0-rc2 / 83a5988 | builds; `#print axioms` of 197 declarations recorded in `third_party/flypitch4/erdos501-audit-output-83a5988.txt`; the only `sorryAx` dependents are `erdos501_of_col_random` and `neg_Erdos501_f_unprovable_of_col_random` (off-route) | **integrated and ported 2026‑08‑17**; proof-level edits only (`docs/PORTING-NOTES.md`, "forcing files"); the `sorry`-stated `erdos501_of_col_random`, its corollary and `V_col_random_models_ZFC` removed (unused; `𝔹_col_random` kept as a definition); the audit at 355bc1e (`docs/audits/2026-08-17-erdos501-forcing-audit-355bc1e.txt`, 194 declarations) is otherwise identical, declaration by declaration, to the 83a5988 one |
| ZFC core (Lemma 2.1/2.2, Def 3.1, Thm 3.2) | `Erdos501/ZFCCore.lean`, `Erdos501/ZFCCore/{Selection,IcoPartition,Certificate}.lean`, `validation/ZFCCoreAudit.lean` | session 2026‑08‑16, `erdos501-zfc-core.zip`; transferred via project docs `claude/src/zfc-core/*` (2026‑08‑17) | v4.30.0-rc2 / 83a5988 | sorry-free; axioms standard | **integrated 2026‑08‑17**; one rename (`mul_le_mul_right'` → `mul_le_mul_left`); module paths `Erdos501.ZFCCore.*`; axiom audit standard |
| NPS87 closed case (`IsFreeSet`, `exists_infinite_isFreeSet`, `erdos501`, `erdos501_three`, `erdos501_pairwise`, `erdos501_ncard_three`) | `Erdos501/Closed.lean`, `validation/Erdos501Axioms.lean` | session 2026‑08‑16, `Erdos501.lean` + Lake scaffold; transferred via project docs `claude/src/Erdos501.lean` etc. (2026‑08‑17) | v4.34.0-rc1 / 355bc1e | sorry-free; axioms standard | **integrated verbatim 2026‑08‑17** (module `Erdos501.Closed`); axiom audit standard |
| Hechler CH counterexample (`hechler_of_CH`, `erdos_501.variants.hechler_CH`) | → `Erdos501/Hechler.lean` | session 2026‑08‑16/17, delivered as `Hechler501FC_master.lean` (+ `Hechler501FC_a3a10db.lean` at the formal-conjectures pin, + `formal-conjectures-501-hechler-patch.md`) | v4.34.0-rc1 / 355bc1e (and v4.27.0 / a3a10db) | sorry-free; axioms standard | re-derived independently in `Erdos501/Hechler.lean` (2026‑08‑17, same construction; standard axioms); the delivered file may replace it |
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
  unknown);
* `Set.restrict` → `Set.domRestrict` (`T.restrict x` for `T : Set ι` is now
  `T.domRestrict x`; `Measure.restrict` is unchanged);
* `le_bihimp_iff` / `le_bihimp` are now generated by `to_dual` and read
  `c ≤ a ⇔ b ↔ b ⊓ c ≤ a ∧ a ⊓ c ≤ b` (the old orientation is re-stated locally
  in `Flypitch4/Erdos501/Transfer.lean`);
* `Set.diff_subset` → `sdiff_subset`, `Set.diff_empty` → `sdiff_empty`,
  `Set.setOf_true` → `ofPred_true` (deprecations, warnings only).
