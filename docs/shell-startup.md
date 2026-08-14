# Shell Startup

Which files bash reads when a shell starts, and what belongs in each.

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
│                           # Also sources every drop-in below:
└── .profiles/
    ├── local.sh            # Machine-specific env vars, aliases, functions (not committed).
    ├── secrets.sh          # Exported secrets (not committed).
    ├── wm.sh               # Commands the window manager and the rofi menus delegate to.
    └── .templates/
        └── local.sh        # Expected shape of local.sh. Copy it out and fill in.
```

## Drop-ins

`.profile` sources every `*.sh` in `.profiles/` instead of naming the files individually, so a drop-in is added by creating a file and removed by deleting it. The glob expands in alphabetical order, and it is not recursive, so the contents of `.templates/` are never sourced.

What the repository ships instead is the shape. Copy `.templates/local.sh` to `.profiles/local.sh` and fill in the values, and create `secrets.sh` empty and add exports as they are needed. Keeping the template tracked means the list of variables a machine is expected to define stays under version control even though the values never are, so a fresh clone can be brought up without guessing what the shell expects to find.
