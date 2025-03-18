[ -z "$PS1" ] && return     # if not running interactively, don't do anything
shopt -s checkwinsize       # update window size after every command
shopt -s histappend         # append to the history file, don't overwrite it
HISTCONTROL=ignoredups      # don't put duplicates in history

XDG_CONFIG_HOME="$HOME/.config"

[ -f /etc/bash_completion ] && ! shopt -oq posix    && . /etc/bash_completion
[ -f $XDG_CONFIG_HOME/shell/completion/alacritty ]  && . $XDG_CONFIG_HOME/shell/completion/alacritty
[ -f $XDG_CONFIG_HOME/shell/colors ]                && . $XDG_CONFIG_HOME/shell/colors
[ -f $XDG_CONFIG_HOME/shell/fs ]                    && . $XDG_CONFIG_HOME/shell/fs
[ -f $XDG_CONFIG_HOME/shell/prompt ]                && . $XDG_CONFIG_HOME/shell/prompt
[ -f $XDG_CONFIG_HOME/shell/local ]                 && . $XDG_CONFIG_HOME/shell/local
[ -f $XDG_CONFIG_HOME/shell/peripherals ]           && . $XDG_CONFIG_HOME/shell/peripherals
[ -f $XDG_CONFIG_HOME/shell/git ]                   && . $XDG_CONFIG_HOME/shell/git
[ -f $XDG_CONFIG_HOME/shell/notes ]                 && . $XDG_CONFIG_HOME/shell/notes
[ -f $XDG_CONFIG_HOME/shell/dev ]                   && . $XDG_CONFIG_HOME/shell/dev
[ -f ~/.fzf.bash ]                                  && . ~/.fzf.bash

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

alias sb='source ~/.bashrc'
alias cfg='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.git --work-tree=$HOME'
