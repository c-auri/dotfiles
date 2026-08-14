# Glue to make sure login shells get both environment and shell config.
# See ~/docs/shell-startup.md for context.

[ -f "$HOME/.profile" ] && . "$HOME/.profile"

# Guard .bashrc behind PS1 check, so it's skipped for non-interactive shells
[[ -n "$PS1" && -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
