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

alias g='git'
alias gs='git status'
alias gb='git branch'
alias gg='git graph'
alias gf='git fetch'
alias gd='git diff'
alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'

alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'

alias v='nvim'
alias bat='batcat'

alias t='tmux'
alias tat='tmux attach -t'

alias url='/usr/local/bin/gurl/gurl.sh'
alias pow='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time|percentage"'
alias btc='bluetoothctl'

alias dn='dotnet'
alias dnr='dotnet run'
