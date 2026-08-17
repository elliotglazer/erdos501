#!/usr/bin/env bash
# Install the external tools needed to judge this repository with the Lean
# comparator: landrun (sandbox), lean4export (olean → text), comparator (the
# judge) and, optionally, nanoda (an independent kernel).
#
# Usage:  scripts/install-comparator-tools.sh [install-dir]      (default: ./.tools)
#
# Afterwards:  export PATH="$(pwd)/.tools/bin:$PATH"
#
# Notes
# * lean4export must be built with EXACTLY the toolchain of this repository
#   (`lean-toolchain`); olean headers are version specific.  We check out the
#   lean4export tag with the same name as the toolchain when it exists.
# * comparator is a Lean program built with its own toolchain; it only reads
#   the text export, so its version need not match ours.  Comparator HEAD
#   (2026‑08) requires the challenge environment to contain `eagerReduce`,
#   i.e. Lean ≥ v4.34.0-rc1 — which is why this repository is pinned there.
# * landrun needs Go ≥ 1.22 and a Linux kernel with Landlock (5.13+).
# * nanoda needs a Rust toolchain; it is optional (`enable_nanoda` in config).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS="${1:-$ROOT/.tools}"
mkdir -p "$TOOLS/bin"
TOOLCHAIN="$(tr -d '[:space:]' < "$ROOT/lean-toolchain")"       # leanprover/lean4:v4.34.0-rc1
LEAN_TAG="${TOOLCHAIN##*:}"                                       # v4.34.0-rc1

COMPARATOR_REV="${COMPARATOR_REV:-main}"
LEAN4EXPORT_REV="${LEAN4EXPORT_REV:-$LEAN_TAG}"
LANDRUN_REV="${LANDRUN_REV:-5ed4a3db3a4ad930d577215c6b9abaa19df7f99f}"   # pin used by leanprover/lean-eval
NANODA_REV="${NANODA_REV:-68d5ca9db226849b41a6fff59d796ff19d0a8840}"     # pin used by leanprover/lean-eval

echo "== landrun @ $LANDRUN_REV"
if command -v go >/dev/null; then
  GOBIN="$TOOLS/bin" go install "github.com/zouuup/landrun/cmd/landrun@$LANDRUN_REV"
else
  echo "   go not found — skipping landrun (use scripts/fake-landrun.sh for a non-sandboxed dry run)"
fi

echo "== lean4export @ $LEAN4EXPORT_REV (built with $TOOLCHAIN)"
if [ ! -d "$TOOLS/lean4export" ]; then
  git clone -q https://github.com/leanprover/lean4export.git "$TOOLS/lean4export"
fi
( cd "$TOOLS/lean4export"
  git fetch -q --tags
  git checkout -q "$LEAN4EXPORT_REV"
  echo "$TOOLCHAIN" > lean-toolchain
  lake build lean4export
  ln -sf "$PWD/.lake/build/bin/lean4export" "$TOOLS/bin/lean4export" )

echo "== comparator @ $COMPARATOR_REV"
if [ ! -d "$TOOLS/comparator" ]; then
  git clone -q https://github.com/leanprover/comparator.git "$TOOLS/comparator"
fi
( cd "$TOOLS/comparator"
  git fetch -q
  git checkout -q "$COMPARATOR_REV"
  lake build comparator
  ln -sf "$PWD/.lake/build/bin/comparator" "$TOOLS/bin/comparator"
  cp scripts/fake-landrun.sh "$TOOLS/bin/fake-landrun.sh" 2>/dev/null || true )

if command -v cargo >/dev/null; then
  echo "== nanoda @ $NANODA_REV"
  if [ ! -d "$TOOLS/nanoda_lib" ]; then
    git clone -q https://github.com/robsimmons/nanoda_lib.git "$TOOLS/nanoda_lib"
  fi
  ( cd "$TOOLS/nanoda_lib"
    git checkout -q "$NANODA_REV"
    cargo build --release
    ln -sf "$PWD/target/release/nanoda_bin" "$TOOLS/bin/nanoda_bin" )
else
  echo "== cargo not found — skipping nanoda (optional)"
fi

echo
echo "Done.  Add to PATH:  export PATH=\"$TOOLS/bin:\$PATH\""
