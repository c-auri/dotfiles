# Dotfiles Overview
Reference for the configuration files in this repository.

## Shell Startup Files

What bash sources on startup:

| | Login (SSH, TTY, `bash --login`) | Non-login (new terminal tab) |
|---|---|---|
| **Interactive** | `.bash_profile` | `.bashrc` |
| **Non-interactive** | `.bash_profile` | nothing |

Bash only reads the first file it finds from `.bash_profile` / `.bash_login` / `.profile`. Without `.bash_profile`, bash would read `.profile` directly and skip `.bashrc` for login shells.

```
~
├── .bash_profile           # Glue: sources .profile  then .bashrc.
├── .bashrc                 # Custom and third-party shell configs.
├── .profile                # PATH, env vars. Set once, inherited, sh-compatible. 
│                           # Also sources the partial profiles below:
└── .profiles/
    ├── secrets.sh          # Exported secrets (not committed).
    └── local.sh            # Machine-specific env vars, aliases, functions (not committed).
```
