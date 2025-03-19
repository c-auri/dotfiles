[ -z "$PS1" ] && return     # if not running interactively, don't do anything
shopt -s checkwinsize       # update window size after every command
shopt -s histappend         # append to the history file, don't overwrite it
HISTCONTROL=ignoredups      # don't put duplicates in history

XDG_CONFIG_HOME="$HOME/.config"

[ -f /etc/bash_completion ] && ! shopt -oq posix    && source /etc/bash_completion
[ -f $XDG_CONFIG_HOME/shell/completion/alacritty ]  && source $XDG_CONFIG_HOME/shell/completion/alacritty
[ -f $XDG_CONFIG_HOME/shell/colors ]                && source $XDG_CONFIG_HOME/shell/colors
[ -f $XDG_CONFIG_HOME/shell/fs ]                    && source $XDG_CONFIG_HOME/shell/fs
[ -f $XDG_CONFIG_HOME/shell/prompt ]                && source $XDG_CONFIG_HOME/shell/prompt
[ -f $XDG_CONFIG_HOME/shell/local ]                 && source $XDG_CONFIG_HOME/shell/local
[ -f $XDG_CONFIG_HOME/shell/peripherals ]           && source $XDG_CONFIG_HOME/shell/peripherals
[ -f $XDG_CONFIG_HOME/shell/git ]                   && source $XDG_CONFIG_HOME/shell/git
[ -f $XDG_CONFIG_HOME/shell/notes ]                 && source $XDG_CONFIG_HOME/shell/notes
[ -f $XDG_CONFIG_HOME/shell/dev ]                   && source $XDG_CONFIG_HOME/shell/dev
[ -f ~/.fzf.bash ]                                  && source ~/.fzf.bash

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

alias sb='source ~/.bashrc'
alias con='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.git --work-tree=$HOME'
