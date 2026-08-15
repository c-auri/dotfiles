# Shell Startup

The shell config is split across three files in the home directory, plus a directory of drop-ins:
```
~
├── .bash_profile           # Glue: sources .profile, then .bashrc.
├── .bashrc                 # Custom and third-party shell configs.
├── .profile                # PATH, env vars. Set once, inherited, sh-compatible.
│                           # Also sources every drop-in below:
└── .profiles/
    ├── local.sh            # Machine-specific env vars, aliases, functions (not committed).
    ├── secrets.sh          # Exported secrets (not committed).
    └── .templates/         # Expected shape of the uncommitted files. Copy out and fill in.
        ├── local.sh
        └── secrets.sh
```
Bash picks which of these it reads based on how the shell was started:

| | Login (SSH, TTY, `bash --login`) | Non-login (new terminal tab) |
|---|---|---|
| **Interactive** | profile chain | `.bashrc` |
| **Non-interactive** | profile chain | `$BASH_ENV` (almost never set) |

**Profile chain** means `.bash_profile`, `.bash_login`, `.profile`, in that order. Bash reads only the **first** of these that exists and ignores the rest.

This means bash never reads `.bashrc` directly for a login shell, interactive or not. Logging in over SSH would therefore give you the environment from the profile chain but none of the interactive shell config: no aliases, no prompt, no completions.

`.bash_profile` is the glue that fixes exactly that. It sits first in the chain, so it is the file a login shell picks, and it then sources `.profile` and `.bashrc` explicitly:
```bash
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
[[ -n "$PS1" && -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
```
The `$PS1` guard keeps the non-interactive login case free of interactive config, but loads it for interactive login shells.

Nothing in bash does any of this. Sourcing one startup file from another is a convention every setup implements by hand, and it could be done in `.profile` instead. The reason for keeping a separate `.bash_profile` is that its slot is contested. Installers (rustup, nvm, conda) routinely append their `export PATH=...` to `~/.bash_profile` and create it if absent, and that new file would then win the chain and silently shadow `.profile` and every drop-in with it. Owning the slot means those installers only ever append to a file that already sources everything else.

## Drop-ins

`.profile` sources every `*.sh` in `.profiles/` instead of naming the files individually, so a drop-in is added by creating a file and removed by deleting it. The glob expands in alphabetical order, and it is not recursive, so the contents of `.templates/` are never sourced.

`local.sh` and `secrets.sh` are never committed, but the repository tracks templates that are meant to be copied over and filled out on a fresh machine. This means the list of variables that are expected to be defined stays under version control even though the values never are.

