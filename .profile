#!/bin/sh

# PATH and env variables belong here, keep sh-compatible.
# See ~/docs/shell-startup.md for context.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export LOGOUT_CMD="awesome-client 'awesome.quit()'"

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/bin/git-utils" ] && PATH="$HOME/.local/bin/git-utils:$PATH"

# Drop-ins for machine-specific, secret, and context-specific config.
# Each context manages its own file, see .templates for the expected shape.
for profile in "$HOME"/.profiles/*.sh
do
    [ -f "$profile" ] && . "$profile"
done
unset profile

