[ -z "$PS1" ] && return   # if not running interactively, don't do anything
shopt -s checkwinsize     # update window size after every command
shopt -s histappend       # append to the history file, don't overwrite it
HISTCONTROL=ignoredups    # don't put duplicates in history

[ -f /etc/bash_completion ] && ! shopt -oq posix    && . /etc/bash_completion
[ -f ~/.bash/completion/alacritty ]                 && . ~/.bash/completion/alacritty
[ -f ~/.bash/fs ]                                   && . ~/.bash/fs
[ -f ~/.bash/prompt ]                               && . ~/.bash/prompt
[ -f ~/.bash/local ]                                && . ~/.bash/local
[ -f ~/.bash/peripherals ]                          && . ~/.bash/peripherals
[ -f ~/.bash/git ]                                  && . ~/.bash/git
[ -f ~/.bash/notes ]                                && . ~/.bash/notes
[ -f ~/.bash/dev ]                                  && . ~/.bash/dev
[ -f ~/.fzf.bash ]                                  && . ~/.fzf.bash

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

alias sb='source ~/.bashrc'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'
