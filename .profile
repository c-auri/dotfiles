if [ -d "$HOME/bin" ]
then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]
then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/git-utils" ]
then
    PATH="$HOME/.local/bin/git-utils:$PATH"
fi
