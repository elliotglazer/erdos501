#!/usr/bin/env python3
"""Regenerate Erdos501/FOL/Statement.lean from Part A of Challenge.lean, or check that it is in sync.

The comparator requires every constant occurring in the statements of Challenge.lean to be
*identical* in the Solution environment; the Solution must not import Challenge, so the
definitions of Part A of Challenge.lean are repeated verbatim in Erdos501/FOL/Statement.lean.

Usage:  scripts/sync-statement.py          # rewrite Erdos501/FOL/Statement.lean
        scripts/sync-statement.py --check  # exit 1 if it differs from Challenge.lean's Part A
"""
import re, sys, pathlib

root = pathlib.Path(__file__).resolve().parent.parent
challenge = (root / "Challenge.lean").read_text(encoding="utf-8")
target = root / "Erdos501" / "FOL" / "Statement.lean"

imports = "\n".join(l for l in challenge.splitlines() if l.startswith("import ")) + "\n"
opens = "\n".join(l for l in challenge.splitlines() if l.startswith("open ") and "Erdos501.FOL" not in l) + "\n"
m = re.search(r"^namespace Erdos501\.FOL\n.*?^end Erdos501\.FOL\n", challenge, re.S | re.M)
if not m:
    sys.exit("Part A (namespace Erdos501.FOL … end Erdos501.FOL) not found in Challenge.lean")
part_a = m.group(0)

header = '''/-
Copyright (c) 2026 Elliot Glazer. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# The statement definitions of `Challenge.lean` (verbatim copy)

GENERATED FILE — do not edit.  This is Part A of `Challenge.lean` (the language `L`, the theory
`ZFC`, the sentence `Erdos501` and the `L`-structure on `ZFSet`), reproduced verbatim by
`scripts/sync-statement.py` so that the Solution — which must not import the Challenge — can
prove statements about *literally* the same constants.  The comparator checks that the two copies
define identical declarations; `scripts/sync-statement.py --check` (run in CI) checks the text.
-/
'''
content = header + imports + "\n" + opens + "\n" + part_a
if "--check" in sys.argv:
    if not target.exists() or target.read_text(encoding="utf-8") != content:
        print("Erdos501/FOL/Statement.lean is out of sync with Challenge.lean Part A; run scripts/sync-statement.py")
        sys.exit(1)
    print("Erdos501/FOL/Statement.lean is in sync with Challenge.lean")
else:
    target.write_text(content, encoding="utf-8")
    print(f"wrote {target}")
