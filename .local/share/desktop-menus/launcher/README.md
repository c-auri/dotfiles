# App Launcher

Opens a searchable list of installed desktop apps.

## Behavior

- Opens `rofi -show drun`: `.desktop` apps only, no run/filebrowser/window modes
- Case-insensitive substring search, tokenized: each whitespace-separated term must appear somewhere in the row (rofi's default `matching: normal`)
- Display format: app name + generic category in small italic, e.g. `Firefox [Web Browser]`
- App icons shown at 20 px using the Papirus icon theme
- Arrow keys and mouse for selection; Enter to launch; Escape closes without launching
- Rofi's built-in launch history is enabled (`disable-history: false`)

## Key Design Decisions

**`drun-display-format` uses Pango markup.** The format string `{name} [<span style='italic' size='small'>{generic}</span>]` renders the generic category in small italic inline without any post-processing.

**No `element-icon` hover/active states.** A plain `drun` launcher never triggers `urgent` or `active` element states, so those variants are omitted.

## Testing

- Run `launcher.sh`: rofi opens fullscreen
- Type a partial app name (e.g. `fire`): list filters to matching apps case-insensitively
- Navigate with `↑`/`↓`: selection highlight moves
- Press `Enter` on an app: app launches; rofi closes
- Click an app with the mouse: app launches; rofi closes
- Press `Escape`: rofi closes; nothing launches
- Open a rarely-used app, close, reopen: that app appears near the top (history enabled)
- Each row shows an app icon, the app name, and the category in small italic
