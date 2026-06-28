# Model regression check

A guard that every class in the `ModelicaByExample` library still passes
`checkModel` under a modern OpenModelica. It exists so that future OpenModelica
or Modelica Standard Library upgrades can't silently break book examples.

## Usage

```sh
tools/check-models/run.sh
```

It runs `omc` in Docker (Docker Desktop or colima), installs the target MSL into
a host cache on first run, checks every class, and prints a verdict:

```
Checked 518 classes: 516 passed, 2 failed (2 known, 0 unexpected).

OK — no regressions.
```

Exit status is `0` when the only failures are ones listed in
`known_failures.txt`, and `1` when something new breaks (a regression) — so it
can gate CI.

## Configuration (environment variables)

| Variable      | Default                                          | Purpose                          |
|---------------|--------------------------------------------------|----------------------------------|
| `OMC_IMAGE`   | `openmodelica/openmodelica:v1.24.0-minimal`      | Docker image providing `omc`     |
| `MSL_VERSION` | `3.2.3`                                           | Modelica Standard Library to load |
| `OMC_LIBS`    | `~/.cache/mbe-omc-libs`                           | Host cache for the installed MSL |

To test the book against a newer compiler, bump `OMC_IMAGE` (and, if the book
migrates, `MSL_VERSION`) and re-run.

## Known failures

`known_failures.txt` lists classes that are expected to fail, each with the
reason and the tracking issue. The runner tolerates these and reports any that
start passing again (so the list can be pruned). Update it deliberately — adding
a class here silences it.

## Files

- `run.sh` — the runner (host: docker + python3).
- `check_all.mos.in` — OMC script template; `@MSL_VERSION@` is substituted in.
- `parse.py` — turns the raw sweep output into a pass/fail verdict.
- `known_failures.txt` — the allowlist of expected failures.
