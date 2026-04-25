# Rofi Configuration

[Rofi](https://github.com/davatorium/rofi) is a window switcher and application launcher for Linux that can also act as a generic fuzzy-search menu. This repo configures two rofi-powered tools for use in my desktop environment: an app launcher and an emoji picker. Both are triggered via keyboard shortcuts defined in `~/.config/awesome/rc.lua`.

## Shared Design

### File Structure

Both tools share a palette file and a base theme:

```
~/.config/rofi/
├── colors/
│   └── kanagawa-dragon.rasi   # shared palette (6 variables)
├── shared-style.rasi          # base theme; imported by launcher and emoji picker
├── launcher/
│   ├── launcher.sh
│   └── style.rasi
└── emoji/
    ├── picker.sh
    ├── emojis.txt
    ├── recent.txt
    └── style.rasi
```

### Theme Architecture

`shared-style.rasi` is the base theme imported by both tools. It imports `kanagawa-dragon.rasi` for color variables and defines the font, window, mainbox, inputbar, prompt, entry, listview, element, element-text, and element-selected rules. Each tool has its own `style.rasi` that imports `shared-style.rasi` and overrides only the rules specific to it. Any change to the base visual language propagates to both tools automatically. The `configuration {}` block for each tool lives in its own `style.rasi` rather than in a global `~/.config/rofi/config.rasi`, keeping each tool's rofi settings co-located with its theme.

> [!Note] 
> Any edit to `shared-style.rasi` or `kanagawa-dragon.rasi` should be followed by opening both the launcher and the emoji picker to confirm neither regressed visually.
