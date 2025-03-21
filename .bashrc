[[ -z "$PS1" ]] && return   # if not running interactively, don't do anything
shopt -s checkwinsize       # update window size after every command
shopt -s histappend         # append to the history file, don't overwrite it
HISTCONTROL=ignoredups      # don't put duplicates in history

export XDG_CONFIG_HOME="$HOME/.config"

[[ -f /etc/bash_completion ]] && ! shopt -oq posix    && source /etc/bash_completion
[[ -f $XDG_CONFIG_HOME/shell/completion/alacritty ]]  && source $XDG_CONFIG_HOME/shell/completion/alacritty

[[ -f $XDG_CONFIG_HOME/shell/prompt ]]  && source $XDG_CONFIG_HOME/shell/prompt
[[ -f $XDG_CONFIG_HOME/shell/aliases ]] && source $XDG_CONFIG_HOME/shell/aliases
[[ -f $XDG_CONFIG_HOME/shell/env ]]     && source $XDG_CONFIG_HOME/shell/env
[[ -f $XDG_CONFIG_HOME/shell/work ]]    && source $XDG_CONFIG_HOME/shell/work

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

alias con='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.git --work-tree=$HOME'
alias sb='source ~/.bashrc'
