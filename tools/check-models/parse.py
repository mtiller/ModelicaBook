#!/usr/bin/env python3
"""Parse the output of check_all.mos and verdict it against known_failures.txt.

Reads the raw OMC sweep output on stdin (or a file argument), splits it into
per-class blocks, and classifies each class as pass/fail. A class fails if its
checkModel result does not say "completed successfully" or if its error string
contains an "Error:" line.

Exit status:
  0  no unexpected failures (clean, or only known failures)
  1  at least one unexpected failure (a regression)
"""
import re
import sys

KNOWN_PATH = __file__.rsplit("/", 1)[0] + "/known_failures.txt"


def load_known(path):
    known = set()
    try:
        with open(path, encoding="utf-8") as fh:
            for line in fh:
                line = line.split("#", 1)[0].strip()
                if line:
                    known.add(line)
    except FileNotFoundError:
        pass
    return known


def parse(text):
    blocks = text.split("@@@MODEL ")[1:]
    results = {}  # name -> (ok, [error lines])
    for b in blocks:
        name = b.split("\n", 1)[0].strip()
        ok = "completed successfully" in b
        errs = [e.strip() for e in re.findall(r"Error:.*", b)]
        results[name] = (ok and not errs, errs)
    return results


def main():
    text = open(sys.argv[1], encoding="utf-8", errors="replace").read() \
        if len(sys.argv) > 1 else sys.stdin.read()
    known = load_known(KNOWN_PATH)
    results = parse(text)

    total = len(results)
    failures = {n: errs for n, (ok, errs) in results.items() if not ok}
    unexpected = {n: e for n, e in failures.items() if n not in known}
    expected = {n: e for n, e in failures.items() if n in known}
    fixed = sorted(known - set(failures))

    print(f"Checked {total} classes: "
          f"{total - len(failures)} passed, {len(failures)} failed "
          f"({len(expected)} known, {len(unexpected)} unexpected).")

    if fixed:
        print("\nKnown failures that now PASS "
              "(remove from known_failures.txt):")
        for n in fixed:
            print(f"  + {n}")

    if unexpected:
        print("\nUNEXPECTED failures (regressions):")
        for n in sorted(unexpected):
            print(f"  - {n}")
            for e in dict.fromkeys(unexpected[n]):  # de-dup, keep order
                print(f"      {e[:200]}")
        return 1

    print("\nOK — no regressions.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
