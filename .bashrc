[[ -z "$PS1" ]] && return

export XDG_CONFIG_HOME="$HOME/.config"
[[ -f $XDG_CONFIG_HOME/shell/work ]] && source $XDG_CONFIG_HOME/shell/work

################################################################################
################################### CORE #######################################
################################################################################

shopt -s checkwinsize
shopt -s histappend
HISTCONTROL=ignoredups

[[ -f /etc/bash_completion ]] && ! shopt -oq posix && source /etc/bash_completion
[[ -f $XDG_CONFIG_HOME/alacritty/completion ]] && source $XDG_CONFIG_HOME/alacritty/completion

LESS="-R -i"

eval "$(dircolors $XDG_CONFIG_HOME/.dircolors)"
export EZA_COLORS="ur=37:uw=37:ue=37:ux=37:gr=37:gw=37:gx=37:tr=37:tw=37:tx=37:sn=2;32:da=2;36:di=1;97"
export BAT_THEME="base16-256"

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--layout reverse --style minimal'

alias con='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.git --work-tree=$HOME'
alias sb='source ~/.bashrc'

################################################################################
################################### PROMPT #####################################
################################################################################

PROMPT_COMMAND=__prepare_prompt

function __prepare_prompt
{
    prev_cmd_exit_code=$?

    if [[ $PWD == $HOME ]]
    then
        dir="~"
    else
        dir=$(basename $PWD)
    fi

    user="${PROMPT_USERNAME:-$(chfont bright-cyan)$(whoami)}$(chfont bright-black):"
    set_win_title="\[\e]2;$dir\a\]"
    dir="$(chfont bright-white)$dir"

    git=$(git status 2>/dev/null | $HOME/.local/lib/shorten-git-status)
    if [[ -n $git ]]
    then
        git="$(chfont yellow)[$git]"
    fi

    if [[ $prev_cmd_exit_code == 0 ]]
    then
        sym_clr="$(chfont bright-white)"
    else
        sym_clr="$(chfont bright-red)"
    fi

    PS1="$set_win_title\n$(chfont bold)$user $dir $git\n$sym_clr❯ $(chfont reset)"
}

################################################################################
################################# FILE SYSTEM ##################################
################################################################################

alias ls='eza --group-directories-first'
alias la='ls -a'
alias ll='ls -l --git --no-user'
alias lla='ll -a'
alias lt='ls --tree --git-ignore'

alias mv='mv -i'
alias cp='cp -i'

function mcd
{
    mkdir -p $1
    cd $1
}

alias df='cd $(fd -H -t d | fzf --preview "tree -C {} | head -200")'

alias notes='cd ~/notes'

################################################################################
##################################### GIT ######################################
################################################################################

alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gC='git commit -a'
alias gf='git fetch -p'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gsw='git switch'

# these are custom git aliases, see .gitconfig and .local/bin/git-utils
alias gg='git graph'
alias gaf='git add-fuzzy'
alias gsf='git switch-fuzzy'
alias gsm='git switch-to-main'
alias gum='git update-main'
alias cdr='cd $(git root)'

################################################################################
################################# DEVELOPMENT ##################################
################################################################################

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_HTTPREPL_TELEMETRY_OPTOUT=1

alias dn='dotnet'
alias dnr='dotnet run'

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

source "$HOME/.cargo/env"
