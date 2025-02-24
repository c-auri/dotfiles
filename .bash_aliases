alias sbrc='source ~/.bashrc'

alias mv='mv -i'

alias cdr='cd $(git rev-parse --show-toplevel)'

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
alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

alias v='nvim'

alias t='tmux'
alias tat='tmux attach -t'

alias dnr='dotnet run'

alias url='/usr/local/bin/gurl/gurl.sh'
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time|percentage"'

