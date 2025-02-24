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

if [ -f ~/.bash_aliases ]
then
    . ~/.bash_aliases
fi

wifi () {
    if [ $# -gt 1 ]
    then
        echo "Too many arguments."
        return 1
    fi

    if [ ! -z "$1" ] && [ $1 != "on" -a $1 != "off" ]
    then
        echo "Invalid argument, should either be omitted or be 'on' or 'off'."
        return 1
    fi

    nmcli radio wifi ${1}
    return $?
}

bt () {
    if [ $# -gt 1 ]
    then
        echo "Too many arguments."
        return 1
    fi

    case $1 in

        "")
            cmd="paired-devices"
            ;;

        "sw")
            cmd="connect 6C:47:60:DD:F1:63"
            ;;

        "wh")
            cmd="connect 14:3F:A6:F0:69:D7"
            ;;

        "or")
            cmd="connect 20:74:CF:95:54:D2"
            ;;

        "dc")
            cmd="disconnect"
            ;;

        *)
            echo "Invalid argument. Options are: sw, wh, or or dc."
            return 1
            ;;

    esac

    bluetoothctl ${cmd}
    return $?
}

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

alias vbrc='v ~/.bashrc'
alias sbrc='source ~/.bashrc'

alias ls='eza --group-directories-first'
alias la='ls -a'
alias ll='ls -l --git --no-user'
alias lls='ll --total-size'
alias lla='ll -a'
alias lt='ls --tree --git-ignore'

alias cdf='cd $(fd -H -t d | fzf)'
alias cdr='cd $(git rev-parse --show-toplevel)'

alias mv='mv -i'
alias cp='cp -i'
alias fd='fdfind'

alias lg='lazygit'

alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'

alias gga='git graph --all'

gg () { 
    num_commits=${1:-10};
    git graph --all -$num_commits
}

alias gsw='git switch'
alias gco='git checkout'

alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gC='git commit -a'

alias gf='git fetch -p'
alias gfm='git fetch origin main:main'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'

alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

alias v='nvim'
alias bat='batcat'

alias t='tmux'
alias tat='tmux attach -t'

alias url='/usr/local/bin/gurl/gurl.sh'
alias pow='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time|percentage"'
alias btc='bluetoothctl'
alias convertwebp='for i in *.webp; do name=`echo "$i" | cut -d'.' -f1`; echo "$name"; convert "$i" "${name}.jpg"; done'

alias dn='dotnet'
alias dnr='dotnet run'

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
