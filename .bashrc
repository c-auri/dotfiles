[ -z "$PS1" ] && return   # if not running interactively, don't do anything
shopt -s checkwinsize     # update window size after every command
shopt -s histappend       # append to the history file, don't overwrite it
HISTCONTROL=ignoredups    # don't put duplicates in history

[ -f /etc/bash_completion ] && ! shopt -oq posix    && . /etc/bash_completion
[ -f ~/.config/shell/completion/alacritty ]                 && . ~/.config/shell/completion/alacritty
[ -f ~/.config/shell/colors ]                               && . ~/.config/shell/colors
[ -f ~/.config/shell/fs ]                                   && . ~/.config/shell/fs
[ -f ~/.config/shell/prompt ]                               && . ~/.config/shell/prompt
[ -f ~/.config/shell/local ]                                && . ~/.config/shell/local
[ -f ~/.config/shell/peripherals ]                          && . ~/.config/shell/peripherals
[ -f ~/.config/shell/git ]                                  && . ~/.config/shell/git
[ -f ~/.config/shell/notes ]                                && . ~/.config/shell/notes
[ -f ~/.config/shell/dev ]                                  && . ~/.config/shell/dev
[ -f ~/.fzf.bash ]                                  && . ~/.fzf.bash

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

alias sb='source ~/.bashrc'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'
