alias sb='source ~/.bashrc'
alias vb='v ~/.bashrc'
alias vbc='v ~/.bashrc.commands.sh'
alias vbl='v ~/.bashrc.local.sh'

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

scrn () {
    if [[ $# > 1 ]]
    then
        echo "Too many arguments."
        return 1
    fi

    inbuilt=$(xrandr | grep -oP "(eDP-?.*)(?=\sconnected)" | tail -n 1)
    external=$(xrandr | grep -oP "(.*)(?=\sconnected)" | tail -n 1)

    if [[ -z $external ]]
    then
        xrandr --output ${inbuilt} --primary --mode ${INBUILT_SCREEN_RES:-"1920x1080"} --brightness ${INBUILT_SCREEN_BRIGHTNESS:-1}
        return $?
    fi

    case $1 in
        "" | "left")
            pos="1920x600"
            ;;
        "up")
            pos="240x1080"
            ;;
        "off")
            xrandr --output ${external} --off
            return $?
	    ;;
        *)
            echo "Invalid argument: ${1}"
            return 1
            ;;
    esac

    xrandr --output ${external} --primary --mode 1920x1080 --pos 0x0 --output ${inbuilt} --mode ${INBUILT_SCREEN_RES:-"1920x1080"} --brightness ${INBUILT_SCREEN_BRIGHTNESS:-1} --pos ${pos}
}

wifi () {
    if [ $# -gt 1 ]
    then
        echo "Too many arguments."
        return 1
    fi

    if [[ -n $1 && $1 != "on" && $1 != "off" ]]
    then
        echo "Invalid argument, should either be 'on', 'off' or omitted."
        return 1
    fi

    if [[ -n $1 ]]
    then
        nmcli radio wifi ${1}
        returncode=$?
    fi 

    nmcli radio wifi
    [[ -n $returncode ]] && return $returncode || return $?
}

bt () {
    if [[ $# > 1 ]]
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

gg () {
    num_commits=${1:-10};
    git graph --all -$num_commits
}

