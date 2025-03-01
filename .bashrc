# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bash/local ]; then . ~/.bash/local; fi
if [ -f ~/.bash/git ]; then . ~/.bash/git; fi
if [ -f ~/.bash/commands ]; then . ~/.bash/commands; fi
if [ -f ~/.bash/dotnet ]; then . ~/.bash/dotnet; fi
if [ -f ~/.bash/completion/alacritty ]; then . ~/.bash/completion/alacritty; fi

eval "$(dircolors $HOME/.dircolors)"
export EZA_COLORS="ur=37:uw=37:ue=37:ux=37:gr=37:gw=37:gx=37:tr=37:tw=37:tx=37:sn=2;32:da=2;36:di=1;37"

# Default parameter to send to the "less" command
# -R: show ANSI colors correctly; -i: case insensitive search
LESS="-R -i"

# Add sbin directories to PATH.  This is useful on systems that have sudo
echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin

PATH=$PATH:$HOME/.local/bin

# programming tools 
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

eval "$(zoxide init --cmd cd bash)"
eval "$(starship init bash)"

alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'
