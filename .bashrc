[[ -z "$PS1" ]] && return   # if not running interactively, don't do anything
shopt -s checkwinsize       # update window size after every command
shopt -s histappend         # append to the history file, don't overwrite it
HISTCONTROL=ignoredups      # don't put duplicates in history

XDG_CONFIG_HOME="$HOME/.config"

[[ -f $XDG_CONFIG_HOME/shell/prompt ]]  && source $XDG_CONFIG_HOME/shell/prompt
[[ -f $XDG_CONFIG_HOME/shell/core ]]    && source $XDG_CONFIG_HOME/shell/core
[[ -f $XDG_CONFIG_HOME/shell/git ]]     && source $XDG_CONFIG_HOME/shell/git
[[ -f $XDG_CONFIG_HOME/shell/dev ]]     && source $XDG_CONFIG_HOME/shell/dev
[[ -f $XDG_CONFIG_HOME/shell/work ]]    && source $XDG_CONFIG_HOME/shell/work

alias con='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.git --work-tree=$HOME'
alias sb='source ~/.bashrc'
