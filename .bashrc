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

source ~/.bash_completion/alacritty

mcd () {
    mkdir -p $1
    cd $1
}

swp () {
    if [ $# != 2 ]
    then
        echo "Wrong number of arguments."
        return 1
    fi

    if [ -f temp ]
    then
        echo "Can not swap because temp file already exists."
        return 1
    fi

    mv $1 temp
    mv $2 $1
    mv temp $2
}

alias mv='mv -i'

alias ls='eza'
alias la='eza -a'
alias ll='eza -l --git --no-user'
alias lls='ll --total-size'
alias lla='ll -a'
alias lt='eza --tree'

alias bat='batcat'

alias gs='git status'
alias gb='git branch'
alias gg='git graph'
alias gf='git fetch'
alias gd='git diff'
alias ga='git add -A'
alias gc='git commit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

alias v='nvim'

alias t='tmux'
alias tat='tmux attach -t'

alias dnr='dotnet run'

alias url='/usr/local/bin/gurl/gurl.sh'
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time|percentage"'

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
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_HTTPREPL_TELEMETRY_OPTOUT=1

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source ~/.bash_completion/alacritty

function set_win_title(){
    echo -ne "\033]0; $(basename "$PWD") \007"
}

starship_precmd_user_func="set_win_title"

eval "$(zoxide init --cmd cd bash)"
eval "$(starship init bash)"
