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

function set_win_title {
    if [ $PWD = $HOME ]
    then
        title="~"
    else
        title=$PWD
    fi

    echo -ne "\033]0; $(basename "$title") \007"
}

starship_precmd_user_func="set_win_title"
eval "$(starship init bash)"

if [ -f /etc/bash_completion ] && ! shopt -oq posix;    then . /etc/bash_completion; fi
if [ -f ~/.config/bash/completion/alacritty ];          then . ~/.config/bash/completion/alacritty; fi
if [ -f ~/.config/bash/local ];                         then . ~/.config/bash/local; fi
if [ -f ~/.config/bash/os ];                            then . ~/.config/bash/os; fi
if [ -f ~/.config/bash/dev ];                           then . ~/.config/bash/dev; fi

alias sb='source ~/.bashrc'
alias vb='v ~/.bashrc'
alias vbl='v ~/.config/bash/local'
alias vbos='v ~/.config/bash/os'
alias vbdev='v ~/.config/bash/dev'

alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin
PATH=$PATH:$HOME/.local/bin

