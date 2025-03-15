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

RESET="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"

BLACK="\[$(tput setaf 0)\]"
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
PURPLE="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"

BRIGHT_BLACK="\[$(tput setaf 8)\]"
BRIGHT_RED="\[$(tput setaf 9)\]"
BRIGHT_GREEN="\[$(tput setaf 10)\]"
BRIGHT_YELLOW="\[$(tput setaf 11)\]"
BRIGHT_BLUE="\[$(tput setaf 12)\]"
BRIGHT_PURPLE="\[$(tput setaf 13)\]"
BRIGHT_CYAN="\[$(tput setaf 14)\]"
BRIGHT_WHITE="\[$(tput setaf 15)\]"

[ -f /etc/bash_completion ] && ! shopt -oq posix    && . /etc/bash_completion
[ -f ~/.bash/completion/alacritty ]          && . ~/.bash/completion/alacritty
[ -f ~/.bash/prompt ]                        && . ~/.bash/prompt
[ -f ~/.bash/local ]                         && . ~/.bash/local
[ -f ~/.bash/os ]                            && . ~/.bash/os
[ -f ~/.bash/notes ]                         && . ~/.bash/notes
[ -f ~/.bash/git ]                           && . ~/.bash/git
[ -f ~/.bash/dev ]                           && . ~/.bash/dev
[ -f ~/.fzf.bash ]                                  && source ~/.fzf.bash

alias sb='source ~/.bashrc'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

