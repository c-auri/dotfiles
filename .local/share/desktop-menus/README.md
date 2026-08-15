# Desktop Menus

[Rofi](https://github.com/davatorium/rofi) is a window switcher and application launcher for Linux that doubles as a searchable menu over any list of options. Three menus are built on it here:

- **[App launcher](launcher/)**: starts installed applications
- **[Emoji picker](emoji/)**: searches from a list of emojis and types the selection into the focused window
- **[Power menu](powermenu/)**: offers lockscreen, shut down, reboot, log out, suspend, and hibernate

They are bound to global keyboard shortcuts in [`rc.lua`](../../../.config/awesome/rc.lua), which spawns them by the bare names `rofi-launcher`, `rofi-emoji`, and `rofi-powermenu`.

## Wiring

The three entry points are symlinked into `~/.local/bin`, which `.profile` puts on `PATH`:

```
~/.local/bin/rofi-launcher   -> ../share/desktop-menus/launcher/launcher.sh
~/.local/bin/rofi-emoji      -> ../share/desktop-menus/emoji/picker.sh
~/.local/bin/rofi-powermenu  -> ../share/desktop-menus/powermenu/powermenu.sh
```

The symlinks are tracked and their targets are relative, so a checkout puts them in place with no manual step. Callers invoke the bare names, so nothing outside this directory hardcodes its location.

The power menu reaches outside this directory twice: its locking actions run [`lockscreen`](../lockscreen/README.md), and Log out runs `$LOGOUT_CMD` from [`.profile`](../../../.profile), where the graphical session can see it. Both are covered in [`powermenu/README.md`](powermenu/README.md).

Requires, all covered by the apt list in [`docs/README.md`](../../../docs/README.md):

- `rofi` for all three, developed against 1.7.1
- `xdotool`, `xclip` for the emoji picker, to type the selection and copy it
- `systemctl`, `loginctl` for the power menu, for the system and session actions

## Shared Design

### File Structure

All three tools share a palette file and a base theme:

```
desktop-menus/
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

`shared-style.rasi` is the base theme imported by all three tools. It imports `kanagawa-dragon.rasi` for color variables and defines the font, window, mainbox, inputbar, prompt, entry, listview, element, element-text, and element-selected rules. Each tool has its own `style.rasi` that imports `shared-style.rasi` and overrides only the rules specific to it. Any change to the base visual language propagates to all three tools automatically. The `configuration {}` block for each tool lives in its own `style.rasi` rather than in a global `config.rasi`, keeping each tool's rofi settings co-located with its theme. Nothing here is loaded by rofi implicitly: every invocation passes `-theme` explicitly, which is what lets this tree live under `~/.local/share` rather than in `~/.config/rofi`.

All imports are relative to the importing file, so the tree can be relocated as a unit.

> [!Note] 
> Any edit to `shared-style.rasi` or `kanagawa-dragon.rasi` should be followed by opening all three tools to confirm none regressed visually.

## Attribution

The full emoji names in `emojis.txt` come from Unicode data published under its own license; see [emoji/README.md](emoji/README.md#attribution).
