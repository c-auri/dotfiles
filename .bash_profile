if [[ -n "$BASH_VERSION" && -n "$PS1" && -f "$HOME/.bashrc" ]]
then
    . "$HOME/.bashrc"
fi

if [[ -d "$HOME/bin" ]]
then
    PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
