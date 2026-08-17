# The comparator challenge

This repository is laid out as a challenge for the Lean FRO's
[comparator](https://github.com/leanprover/comparator), the judge used by the
AIMO competitions and by [leanprover/lean-eval](https://github.com/leanprover/lean-eval).
Comparator guarantees, for every name in `theorem_names`, that the declaration
in `Solution` (i) has *exactly* the statement of the one in `Challenge`,
including every constant the statement mentions, (ii) uses no axioms beyond
`permitted_axioms`, and (iii) is accepted by the Lean kernel (and optionally by
the independent kernel `nanoda`).  It never trusts `Solution` — it rebuilds it
in a `landrun` sandbox and replays the exported environment through the kernel
in its own process.

## Files

| file | role |
|---|---|
| `Challenge.lean` | trusted statements (`sorry`) — five targets |
| `Solution.lean` | the same statements proved by delegation to `Erdos501` |
| `config.json` | full challenge (all five targets) |
| `config-zfc.json` | the targets provable today (closed case ×2, Hechler) |
| `lakefile.toml`, `lean-toolchain`, `lake-manifest.json` | the trusted build description (Mathlib pin) |
| `scripts/install-comparator-tools.sh` | installs `landrun`, `lean4export` (at our toolchain tag), `comparator`, optionally `nanoda` |
| `scripts/run-comparator.sh [config]` | `lake env comparator <config>` behind the recommended `systemd-run` wrapper |

## Trusted base

Per the comparator's assumptions, "the transitive closure of imports of
`Challenge.lean` as well as `lakefile.toml` are controlled by you or
trustworthy".  Here that closure is:

1. **Mathlib** at the pinned commit — for `volume` (Lebesgue measure on `ℝ`;
   on arbitrary sets it is Lebesgue outer measure), `IsClosed`,
   `Bornology.IsBounded`, `Set.Pairwise`, `Set.Infinite`, `Set.ncard`,
   `Cardinal.aleph`, `Cardinal.continuum`.
2. **`Flypitch4`** — the vendored Lean 4 port of Flypitch: `Fol` (terms,
   formulas, the derivation system `prf`, `⊢ₛ'`), `L_ZFC`, the theory `ZFC`
   (`Flypitch4/Zfc.lean`), `Structure`/`⊨ₘ` (realization of a sentence in a
   structure), and `independent` (`Flypitch4/Summary.lean`).  The port's
   own validation is under `third_party/flypitch4/`.  Only what
   `Flypitch4.Summary` transitively imports is in the closure — but that is
   most of the port.
3. **`Erdos501.Sentence`** — the sentence `Erdos501_f`.  This is the single
   most important thing to audit by hand: it must say "every family of bounded
   sets of outer measure < 1 has an infinite independent set" and nothing
   weaker.  `validation/Erdos501Print.lean` (from the flypitch patch) prints
   it in readable form; the faithfulness target `erdos501_sentence_faithful`
   ties it to the Mathlib statement `erdos501_deepmind` in the standard
   `ZFSet` interpretation, which reduces the audit of the sentence to the audit
   of `stdStructure` and `erdos501_deepmind`.
4. **`Erdos501.Bridge`** — `stdStructure` and `erdos501_deepmind` (definitions
   only).

Everything else (`Erdos501/*` proofs, the random-algebra additions to
`Flypitch4`, `Solution.lean`) is untrusted from the comparator's point of view.

## Running

```sh
# once: toolchain + Mathlib cache
lake exe cache get          # requires network access to the Mathlib cache
lake build                  # everything, including Challenge and Solution

# once: tools
scripts/install-comparator-tools.sh   # needs go, and cargo for nanoda (optional)
export PATH="$PWD/.tools/bin:$PATH"

# judge
scripts/run-comparator.sh config-zfc.json   # should print "Your solution is okay!"
scripts/run-comparator.sh config.json       # fails until targets 4–5 are closed
```

Without `landrun` (e.g. macOS) a *non-sandboxed* dry run is possible with
`COMPARATOR_LANDRUN=.tools/bin/fake-landrun.sh`; that checks statements,
axioms and kernel acceptance but does not protect against a malicious
`Solution`.

## Toolchain constraints

* `lean4export` must be built with exactly `lean-toolchain` (olean headers are
  version-specific); the install script checks out the lean4export tag named
  after our toolchain.
* Comparator HEAD requires the challenge environment to define `eagerReduce`
  (Lean ≥ v4.34.0-rc1).  Bumping Lean/Mathlib later is fine; going back before
  v4.34.0-rc1 requires an older comparator (e.g. `71b52ec`, the lean-eval pin).

## Statement conventions

The five statements are written so that a reader who trusts Mathlib and
Flypitch can check them against erdosproblems.com/501 by eye:

* hypotheses exactly as in `formal-conjectures`' `501.lean` (per-set
  `Bornology.IsBounded`, `volume.toOuterMeasure (A x) < 1`, closedness,
  `volume (A x) < 1`), conclusion `X.Pairwise (fun x y => x ∉ A y)`;
* `erdos501_hechler_of_CH` takes `CH` as `(ℵ₁ : Cardinal.{u}) = 𝔠` (a universe
  parameter `u`; all universes are equivalent through `Cardinal.lift`);
* `erdos501_independent` is `independent ZFC Erdos501_f`, the exact shape of
  Flypitch's `independence_of_CH`.
