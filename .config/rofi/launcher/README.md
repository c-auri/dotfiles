# App Launcher

**Trigger:** `Meta + Return` — opens a searchable list of installed desktop apps.

## Files

```
~/.config/rofi/launcher/
├── launcher.sh    # entry point: rofi -show drun -theme launcher/style.rasi
└── style.rasi     # launcher-specific overrides atop shared-style.rasi
```

## Behavior

- Opens `rofi -show drun` — `.desktop` apps only, no run/filebrowser/window modes
- Case-insensitive fuzzy search
- Display format: app name + generic category in small italic, e.g. `Firefox [Web Browser]`
- App icons shown at 20 px using the Papirus icon theme
- Arrow keys and mouse for selection; Enter to launch; Escape closes without launching
- Rofi's built-in launch history is enabled (`disable-history: false`)

## Visual

- Content column centered via uniform `padding: 35%` on mainbox — visible column is ~30% of screen width
- Single vertical column, 12 visible rows, no scrollbar
- Inputbar: `@background-alt` background, 8 px top/bottom, 12 px left/right padding
- Entry placeholder: empty string
- Icon-to-text spacing within a row: 12 px

## Theme Overrides

`launcher/style.rasi` adds on top of `shared-style.rasi`:

- `configuration {}` block: `modi: "drun"`, show-icons, `icon-theme: "Papirus"`, `drun-display-format`, `disable-history: false`, `display-drun: "❯"`
- `entry { placeholder-color: @selected; }` — dims placeholder text to match prompt color
- `element { spacing: 12px; }` — gap between icon and text
- `element-icon { size: 20px; background-color: transparent; }`

## Key Design Decisions

**`drun-display-format` uses Pango markup.** The format string `{name} [<span style='italic' size='small'>{generic}</span>]` renders the generic category in small italic inline without any post-processing.

**No `element-icon` hover/active states.** A plain `drun` launcher never triggers `urgent` or `active` element states, so those variants are omitted.

## Testing

- Press `Meta + Return`: rofi opens fullscreen
- Type a partial app name (e.g. `fire`): list filters to matching apps case-insensitively
- Navigate with `↑`/`↓`: selection highlight moves
- Press `Enter` on an app: app launches; rofi closes
- Click an app with the mouse: app launches; rofi closes
- Press `Escape`: rofi closes; nothing launches
- Open a rarely-used app, close, reopen: that app appears near the top (history enabled)
- Window fills entire screen with no gap or border
- Column occupies ~30% of screen width, centered
- 12 rows visible before scrolling
- Prompt shows `❯` glyph in muted teal (`#717C7C`)
- Each row shows an app icon (20 px, Papirus) + name + `[Category]` in small italic
- Selected row background changes to `#393836`; text stays light
- Background `#181616`, text `#C5C9C5` matches kanagawa-dragon
