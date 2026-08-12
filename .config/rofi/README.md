# Rofi Configuration

[Rofi](https://github.com/davatorium/rofi) is a window switcher and application launcher for Linux that can also act as a generic fuzzy-search menu. This repo builds three rofi-powered tools for use in my desktop environment: an app launcher, an emoji picker, and a power menu. All three are triggered via keyboard shortcuts defined in `~/.config/awesome/rc.lua`.

## Installation

The tools are location-independent: each script resolves its own directory via `readlink -f "$0"`, and the `.rasi` files import each other by relative path. Clone or place this directory anywhere, then symlink the three entry points onto `PATH`:

```bash
ln -sf <dir>/launcher/launcher.sh   ~/.local/bin/rofi-launcher
ln -sf <dir>/emoji/picker.sh        ~/.local/bin/rofi-emoji
ln -sf <dir>/powermenu/powermenu.sh ~/.local/bin/rofi-powermenu
```

Callers invoke the bare names, so nothing outside this repo hardcodes its location.

Requires `rofi` (developed against 1.7.1). The emoji picker additionally needs `xdotool` and `xclip`. The power menu needs `systemctl`, `awesome-client`, and a lock script named by the `LOCKSCREEN_CMD` environment variable; see `powermenu/README.md` for how to set it.

## Shared Design

### File Structure

All three tools share a palette file and a base theme:

```
rofi/
├── colors/
│   └── kanagawa-dragon.rasi   # shared palette (6 variables)
├── shared-style.rasi          # base theme; imported by all three tools
├── launcher/
│   ├── launcher.sh
│   └── style.rasi
├── emoji/
│   ├── picker.sh
│   ├── emojis.txt
│   └── style.rasi
└── powermenu/
    ├── powermenu.sh
    └── style.rasi
```

### Theme Architecture

`shared-style.rasi` is the base theme imported by all three tools. It imports `kanagawa-dragon.rasi` for color variables and defines the font, window, mainbox, inputbar, prompt, entry, listview, element, element-text, and element-selected rules. Each tool has its own `style.rasi` that imports `shared-style.rasi` and overrides only the rules specific to it. Any change to the base visual language propagates to all three tools automatically. The `configuration {}` block for each tool lives in its own `style.rasi` rather than in a global `config.rasi`, keeping each tool's rofi settings co-located with its theme. Nothing here is loaded by rofi implicitly: every invocation passes `-theme` explicitly, which is what lets the repo live outside `~/.config/rofi`.

All imports are relative to the importing file, so the tree can be relocated as a unit.

> [!Note] 
> Any edit to `shared-style.rasi` or `kanagawa-dragon.rasi` should be followed by opening all three tools to confirm none regressed visually.
