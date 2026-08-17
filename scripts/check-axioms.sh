#!/usr/bin/env bash
# Print the axioms used by every comparator target (via Solution) and by the
# main intermediate theorems.  Anything other than
#   [propext, Classical.choice, Quot.sound]
# (in particular `sorryAx`) means the corresponding target is not closed.
set -euo pipefail
cd "$(dirname "$0")/.."
lake build Solution
lake env lean validation/AxiomAudit.lean
