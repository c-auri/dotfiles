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

alias f='fzf'
alias t='tmux'
alias v='nvim'

mcd () {
    mkdir -p $1
    cd $1
}

alias ..='cd ..'
alias mv='mv -i'

alias ls='eza'
alias la='eza -a'
alias ll='eza -l --git --no-user'
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

alias dnr='dotnet run'

alias url='/usr/local/bin/gurl/gurl.sh'
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time|percentage"'

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

eval "$(zoxide init --cmd cd bash)"
eval "$(starship init bash)"
