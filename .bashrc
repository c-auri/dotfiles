# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and update LINES and COLUMNS accordingly
shopt -s checkwinsize

[ -f /etc/bash_completion ] && ! shopt -oq posix    && . /etc/bash_completion
[ -f ~/.config/bash/completion/alacritty ]          && . ~/.config/bash/completion/alacritty
[ -f ~/.config/bash/prompt ]                         && . ~/.config/bash/prompt
[ -f ~/.config/bash/local ]                         && . ~/.config/bash/local
[ -f ~/.config/bash/os ]                            && . ~/.config/bash/os
[ -f ~/.config/bash/notes ]                         && . ~/.config/bash/notes
[ -f ~/.config/bash/git ]                           && . ~/.config/bash/git
[ -f ~/.config/bash/dev ]                           && . ~/.config/bash/dev
[ -f ~/.fzf.bash ]                                  && source ~/.fzf.bash

alias sb='source ~/.bashrc'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

