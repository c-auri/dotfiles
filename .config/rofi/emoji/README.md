# Emoji Picker

**Trigger:** `Meta + .` — opens a searchable emoji list; selected emoji is typed into the previously focused window and copied to the clipboard.

## Files

```
~/.config/rofi/emoji/
├── picker.sh      # entry point
├── emojis.txt     # static hand-curated emoji list; edit directly to add or remove entries
├── recent.txt     # auto-managed; up to 10 most recently used entries
└── style.rasi     # emoji-specific overrides atop shared-style.rasi
```

## Behavior

- Opens rofi in `-dmenu` mode — searchable list, not an app launcher
- Case-insensitive fuzzy search across both the short name and the full Unicode name
- Only listed entries can be selected (`-no-custom`); freeform text is not accepted
- Selected emoji is copied to the X clipboard (`xclip -selection clipboard`)
- Selected emoji is auto-typed into the window focused before the picker opened (`xdotool type --clearmodifiers`)
- Recently used entries (up to 10) appear at the top of the list on subsequent opens
- Picking an already-recent emoji moves it to position 1; no duplicates accumulate
- `recent.txt` is updated atomically (write to `.tmp`, then `mv`)
- Escape or selecting nothing exits cleanly with no clipboard or focus side-effects

## Visual

- Single column, 20 visible rows, continuous scroll (`-scroll-method 1`)
- Mainbox padding `35% 35% 16px 35%` — less bottom space than the default to allow for a longer content list
- Rows use Pango markup (`-markup-rows`): short name in foreground color, full Unicode name dimmed in `#727169`

## Emoji List Format

Each line in `emojis.txt` and `recent.txt` follows this pattern:

```
<emoji>  <short-name> <span foreground="#727169">(<full unicode name>)</span>
```

Example:
```
😀  grinning <span foreground="#727169">(grinning face)</span>
😂  joy <span foreground="#727169">(face with tears of joy)</span>
```

Two spaces separate the emoji character from the name fields. The short name is a concise, searchable keyword (e.g. `joy`, `cool`, `winking`). The full Unicode name is parenthesized and rendered in muted gray (`#727169`, kanagawa `fujiGray`). Both names are searched by rofi's fuzzy filter. `emojis.txt` is static — edit it manually to add or remove entries; do not regenerate it from `unicodedata`, which would overwrite the hand-chosen short names.

The `awk '{print $1}'` extraction in `picker.sh` isolates the emoji character by taking the first whitespace-delimited field; the markup in the remaining fields is ignored.

## picker.sh Logic

1. Capture the currently focused window ID via xdotool (before rofi steals focus)
2. Feed `recent.txt` then `emojis.txt` into rofi -dmenu
3. If nothing selected → exit 0
4. Extract emoji character (first whitespace-delimited field of the selected line)
5. Prepend selected line to `recent.txt`; deduplicate; keep top 10; write atomically
6. Copy emoji to clipboard via xclip
7. Refocus the previously focused window and type the emoji via xdotool

## Theme Overrides

`emoji/style.rasi` overrides three rules from `shared-style.rasi`:

- `mainbox.padding`: `35% 35% 16px 35%` (launcher uses `35%` uniform)
- `prompt.padding`: `0px 23px 5px 3px` (launcher uses `0px 16px 5px 3px` — wider right gap for the emoji prompt)
- `listview.lines`: `20` (launcher uses `12`)

## Key Design Decisions

**`-markup-rows` + Pango `<span>` in `emojis.txt`.** Allows the full Unicode name to be rendered in a dimmed color without a second UI column. Both names remain in the same string rofi searches, so fuzzy matching covers both. The emoji extraction still works because `awk '{print $1}'` only cares about the first whitespace field.

**`-scroll-method 1` (continuous scroll).** Replaces the default page-jump scroll. With 20 lines visible and a potentially long list, this gives smoother navigation.

**Static `emojis.txt`, no generator script.** The file is hand-curated with short names chosen for searchability (e.g. `joy` instead of `face with tears of joy`). Regenerating from `unicodedata` would overwrite those short names.

**Focused window captured before rofi opens.** At the moment `awful.spawn.with_shell` fires, the previous window is still active. By the time `picker.sh` reaches `xdotool getactivewindow`, that window is still focused. This is reliable because AwesomeWM's keybinding handler hasn't transferred focus yet.

**`-no-custom` prevents freeform input.** Only an entry from the list can be submitted. This avoids accidental garbage being typed or copied if the user misses a selection.

**Clipboard copy as fallback.** `xclip -selection clipboard` runs before `xdotool type`, so even if `xdotool` fails (e.g. the target window closed), the emoji is still in the clipboard for a manual paste.

**Atomic `recent.txt` update.** Writing to `recent.tmp` then `mv`-ing prevents a partial write from corrupting the recent list.

## Testing

- Press `Meta + .`: rofi opens fullscreen showing the emoji list
- Type `joy`: list filters to entries containing "joy"
- Type `JOY`: same results (case-insensitive)
- Type part of a full Unicode name (e.g. `tears`): entries whose full name contains "tears" appear
- Select an emoji with Enter: rofi closes; emoji appears in the previously focused window
- Check clipboard after selection: emoji is present (`xclip -o -selection clipboard`)
- Press `Escape`: rofi closes; nothing is typed; clipboard unchanged
- Type a string that matches nothing, press Enter: not possible — Enter on an empty list does nothing
- Pick any emoji, reopen picker: that emoji appears at the top of the list
- Pick the same emoji again: it stays at position 1; `recent.txt` has no duplicates
- Pick 11 distinct emojis: `wc -l ~/.config/rofi/emoji/recent.txt` outputs `10`
- Inspect `recent.txt`: lines follow the full `emoji  short-name <span...>` format
- Window fills entire screen
- 20 rows visible
- Each row shows emoji glyph + short name in light text + full name in muted gray
- Scrolling is continuous, not page-jumping
- Colors match the launcher exactly
