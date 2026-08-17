#!/usr/bin/env bash
# Judge this repository with the Lean comparator.
#
#   scripts/run-comparator.sh                 # full challenge (config.json)
#   scripts/run-comparator.sh config-proved.json # only the targets provable today
#
# Requires `landrun`, `lean4export` and `comparator` on PATH (see
# scripts/install-comparator-tools.sh), or the COMPARATOR_LANDRUN /
# COMPARATOR_LEAN4EXPORT / COMPARATOR_NANODA environment variables.
#
# The comparator's own README recommends the systemd-run wrapper below on
# Linux < 7.1 to guard against a landrun vulnerability; set NO_SYSTEMD=1 to
# call comparator directly (e.g. inside a container without systemd).
set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG="${1:-config.json}"
COMPARATOR_BIN="${COMPARATOR_BIN:-comparator}"

# A pre-populated .lake (e.g. from `lake exe cache get` + `lake build`) is
# acceptable per the comparator README; comparator will still (re)build the
# Challenge and Solution modules inside its sandbox.
if [ "${NO_SYSTEMD:-0}" = "1" ] || ! command -v systemd-run >/dev/null; then
  exec lake env "$COMPARATOR_BIN" "$CONFIG"
else
  exec systemd-run --property=RestrictAddressFamilies=~AF_UNIX --user --pty \
    -E PATH="$PATH" -E COMPARATOR_LANDRUN="${COMPARATOR_LANDRUN:-}" \
    -E COMPARATOR_LEAN4EXPORT="${COMPARATOR_LEAN4EXPORT:-}" \
    -E COMPARATOR_NANODA="${COMPARATOR_NANODA:-}" \
    --working-directory "$(pwd)" -- \
    bash -c "lake env $COMPARATOR_BIN $CONFIG"
fi
