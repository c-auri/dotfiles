# git-utils

Custom git commands, exposed as `git <alias>` via `.gitconfig`.

## Dependencies

- `fzf` — fuzzy selection

## Design decisions

`git-lib` is a shared library sourced by the scripts. It is not executable and not meant to be invoked directly.

`shorten-status` is an awk script for condensing `git status` output. Not a git command — sourced from `.bashrc`.

Scripts are kept as separate files (rather than one multi-command script) so each alias maps to a plain executable that git can find via PATH.
