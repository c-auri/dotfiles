# git-utils

Custom git commands, exposed as `git <alias>` via `.gitconfig`. Scripts are kept as separate files (rather than one multi-command script) so each alias maps to a plain executable that git can find via PATH.

## Dependencies

- `fzf` — fuzzy selection

## Quality Requirements

When writing a new util, check whether it can run into any of the scenarios below and handle it the same way the rest of this codebase does. Each entry describes the scenario, the wrong behavior it tends to cause, and how to get the correct behavior instead.

### Not inside a git repository.

Naively, each git call in the script fails separately with its own copy of the same error. Instead, call `require_git_repo` (`git-lib`) right after sourcing the library — it fails once, with git's own error, before any further git calls run.

### Requested history is longer than the branch actually has

(e.g. asking for the last 20 commits on a 5-commit branch). Naively, a `base..HEAD` range built from a fixed offset either errors out or silently drops the initial commit, since a range excludes its base. Instead, build the range with `get_branch_range` (`git-lib`), which returns a bare `HEAD` once the requested depth reaches or passes the root commit, keeping the initial commit reachable.

### A selected branch only exists on the remote, not locally.

Naively, passing the bare name straight to `git log`/`git show`/etc. fails to resolve. Instead, fall back to `<remote>/<name>` when the bare name doesn't resolve as a ref, as `git-switch-fuzzy`'s preview does.

### A command needs to show a ref's position relative to another ref

(e.g. how a branch compares to the default branch). Naively, each command reimplements its own ahead/behind decision tree and windowing/truncation logic, as `git-switch-fuzzy`'s preview originally did — drifting out of sync as one copy gets tuned and the other doesn't. Instead, use `print_graph_window` (`git-lib`), which centers a fixed-size window on a primary ref and reports an `↑`/`↓` indicator when a secondary ref falls outside it, as `git-graph` and `git-switch-fuzzy`'s preview both do.

### fzf is cancelled (empty selection).

Naively, an empty selection is passed straight to the next command as an empty argument, which for most git subcommands does something unintended rather than nothing. Instead, pipe through `xargs -r`, which skips the command entirely on empty input.

### A numeric argument is built directly into a flag

(e.g. `-${1:-10}`). Naively, a non-numeric or negative input produces a nonsensical flag (`-abc`, `--5`) that fails with a confusing error from the downstream command instead of the script itself, and may coincidentally collide with a real flag the input wasn't meant to trigger. Instead, validate the argument against a pattern like `^[1-9][0-9]*$` before using it, and fail with a clear message naming the argument if it doesn't match, as `git-graph` does.

### A script needs the list of changed files.

Naively, parsing plain `git status` output with `grep`/`sed`/`awk` breaks on filenames containing spaces or quotes, since git quotes those in its plain output. Instead, use `get_changed_files` (`git-lib`), which lists changed files safely regardless of what characters their names contain. Pipe it into `fzf --read0 --print0` and `xargs -0`, as `git-add-fuzzy` does, so the paths stay NUL-delimited all the way through instead of being re-joined with spaces.

### The list fed to fzf can be empty

Happens when nothing changed, no other branches exist, no commits yet, etc. Naively, fzf opens on an empty list, leaving the user looking at a picker with nothing to pick and no explanation. Instead, check the list before invoking fzf and, if it's empty, print a message to stderr and exit without opening fzf at all.

### A command needs to know the default branch.

Naively, `get_default_branch`'s result is passed straight into a git command, so when there's no remote (or no `<remote>/HEAD` symref) the empty result produces a second, confusing error from that command instead of a clear one from the script — and in a pipeline it can even exit 0 while failing. Instead, pick the handling that matches what the command actually needs: call `require_remote` (`git-lib`) if it talks to the remote (`git-update-main`, `git-rebase-origin-main`); rely on `get_default_branch`'s local fallback plus an emptiness check if it only needs the *name* (`git-switch-to-main`); or let the empty result flow through and simply omit the comparison if the command can do without it (`git-graph`, `git-switch-fuzzy`'s preview). Note the two modes differ: no-arg returns a short *local* branch name and falls back to `main`/`master`, while `upstream` returns a remote-tracking ref and reports nothing without a remote, since none exists.

### Naming a library function (`git-lib`).

Naively, a noun-phrase name like `changed_paths` reads like a variable or a fixed list, not something that goes and computes a result — unclear whether it fetches, filters, or just holds data. Instead, name it after the verb it performs, e.g. `get_changed_files`, `require_git_repo`.

## Known issues

### More than one remote configured

`get_remote` (`git-lib`) always picks the first one alphabetically/by insertion order, which may not be the intended remote. Already flagged in its own comment as a known simplification, not yet fixed.

### Local default branch discovery is a guess, but only in a repo with no remote at all

When a remote exists, `<remote>/HEAD` is authoritative and names whatever the default actually is (`deploy`, `develop`, `master`, …), so nothing is guessed and no branch names are hardcoded. Only a remote-less repo falls through to probing `main`, then `master`, and giving up if neither exists. Two alternatives are deliberately not used: `init.defaultBranch`, because it's the default for *newly created* repos and can disagree with what an existing repo uses; and `git ls-remote --symref <remote> HEAD`, which does answer the question authoritatively even when the local symref is missing, but is a network round-trip in a path `git-graph` hits on every invocation — slow at best, hanging or failing when the remote is unreachable — and can't help the remote-less case anyway. For the one shape it would help (remote configured, `<remote>/HEAD` absent), `require_remote` instead points at `git remote set-head <remote> -a`, which writes the symref once so every later call stays local.

### `print_graph_window` can exit 0 on a failed `git log`

Its `git log | awk` pipeline reports `awk`'s status, and `awk` succeeds on empty input, so a malformed *primary* ref yields exit 0 with no output. The no-remote cases that used to trigger this are fixed, but the underlying pipeline masking remains. Fixing it needs `set -o pipefail` scoped with `local -`, which is more exotic than anything else here, so it's left as-is.

