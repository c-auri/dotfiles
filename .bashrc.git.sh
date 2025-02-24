alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'

gg () {
    num_commits=${1:-10};
    git graph --all -$num_commits
}

alias gga='git graph --all'

alias gsw='git switch'
alias gco='git checkout'

alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gC='git commit -a'

alias gf='git fetch -p'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'

gcm () { git checkout "$(gitDefaultBranch)"; }

glm () {
    defaultBranch=$(gitDefaultBranch)
    if [[ $defaultBranch == $(gitCurrentBranch) ]]
    then
        git pull
    else
        git fetch origin "$defaultBranch:$defaultBranch"
    fi
}


cdr () {
    root=$(git rev-parse --absolute-git-dir 2>/dev/null | grep -oP '.*(?=/.git)')
    if [[ $? ]]
    then
        cd $root
    else
        echo "Not inside a git repository."
        return 1
    fi
}

alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git --work-tree=$HOME'
alias lg='lazygit'

gitCurrentBranch () { echo $(git symbolic-ref --short HEAD); }
gitDefaultBranch () { echo "$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"; }

