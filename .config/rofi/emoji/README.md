# Emoji Picker

**Trigger:** `Meta + .` — opens a searchable emoji list; selected emoji is typed into the previously focused window and copied to the clipboard.

## Files

```
~/.config/rofi/emoji/
├── picker.sh      # entry point
├── emojis.txt     # static hand-curated emoji list; edit directly to add or remove entries
└── style.rasi     # emoji-specific overrides atop shared-style.rasi
```

## Behavior

- Opens rofi in `-dmenu` mode — searchable list, not an app launcher
- Case-insensitive fuzzy search across both the short name and the full Unicode name
- Short-name matches always rank above full-name matches; see the ranking design decision below
- Only listed entries can be selected (`-no-custom`); freeform text is not accepted
- Selected emoji is copied to the X clipboard (`xclip -selection clipboard`)
- Selected emoji is auto-typed into the window focused before the picker opened (`xdotool type --clearmodifiers`)
- Escape or selecting nothing exits cleanly with no clipboard or focus side-effects

## Visual

- Single column, 20 visible rows, continuous scroll (`-scroll-method 1`)
- Mainbox padding `35% 35% 16px 35%` — less bottom space than the default to allow for a longer content list
- Each row shows the emoji glyph and one name; the full Unicode name is searchable but not displayed

## Emoji List Format

Each line in `emojis.txt` follows this pattern:

```
<emoji>  <short-name> (<full unicode name>)
```

Example:
```
😀  grinning (grinning face)
😂  joy (face with tears of joy)
```

Two spaces separate the emoji character from the name fields. The short name is a concise, searchable keyword (e.g. `joy`, `cool`, `winking`). The parenthesized full Unicode name is optional and only present where a curated short name replaces it: 437 of 2075 entries have one, the rest display their Unicode name directly. Both names are searched. `emojis.txt` is static — edit it manually to add or remove entries; do not regenerate it from `unicodedata`, which would overwrite the hand-chosen short names.

`picker.sh` rewrites the trailing `(full unicode name)` into rofi's dmenu meta field before piping the list in, so the parenthetical is never displayed. Write it plainly in `emojis.txt`; the encoding is the script's job.

The `awk '{print $1}'` extraction in `picker.sh` isolates the emoji character by taking the first whitespace-delimited field. rofi echoes back the displayed text, not the meta field, so the extraction is unaffected.

## picker.sh Logic

1. Capture the currently focused window ID via xdotool (before rofi steals focus)
2. Rewrite each trailing `(full unicode name)` into a dmenu meta field, then feed the result into rofi -dmenu
3. If nothing selected → exit 0
4. Extract emoji character (first whitespace-delimited field of the selected line)
5. Copy emoji to clipboard via xclip
6. Refocus the previously focused window and type the emoji via xdotool

## Theme Overrides

`emoji/style.rasi` overrides three rules from `shared-style.rasi`:

- `mainbox.padding`: `35% 35% 16px 35%` (launcher uses `35%` uniform)
- `prompt.padding`: `0px 23px 5px 3px` (launcher uses `0px 16px 5px 3px` — wider right gap for the emoji prompt)
- `listview.lines`: `20` (launcher uses `12`)

## Key Design Decisions

**Full Unicode name lives in rofi's meta field, not in the row text.** This is what makes short-name matches win, and it is why the parenthetical is no longer displayed.

rofi's fzf scorer (`rofi_scorer_fuzzy_evaluate` in `source/helper.c`) charges `GAP_SCORE` (5 points) for every character *after* the match but only `LEADING_GAP_SCORE` (4 points) for every character before it. A match late in a row therefore scores better than a match early in it, and a shorter row beats a longer one. Because rofi scores the exact string it renders, a visible full Unicode name dragged its own short name down: searching `happy` returned 🙋 raising hand before 😊 happy, and `bat` returned 🛀 bath before 🦇 bat.

Measured over all 2049 distinct short names, the row whose short name equals the query failed to rank first in 97 cases. Only 5 were a parenthetical outranking a short name; the other 92 were one short name outranking another, both driven by the same trailing penalty.

Every layout that keeps the parenthetical visible was measured and rejected: `-no-sort` (166 failures), no-op Pango tags woven through the parenthetical to inflate its gap cost (98-101, backfires because the tags lengthen the row and the trailing penalty outweighs the gap penalty), parenthetical first with the short name last (96), and a hypothetical rofi patched to drop the trailing penalty (79). Moving the full name to meta gives 0.

Meta works because rofi consults it only when the visible row text fails to match (`dmenu_token_match`) and never scores it (scoring goes through `mode_get_completion`). Full-name-only matches are therefore scored as non-matches and sort below every short-name match. Upstream rofi does not help: it adds a per-row `display` field, but `dmenu_get_completion_data` prefers that field for scoring too, and the scorer constants are unchanged.

**No `-markup-rows`.** With the full name out of the row text there is nothing left to dim, so rows are plain text. This also removes a `pango_parse_markup` call per row per keystroke, and makes `&` and `<` in a name safe rather than a parse error that would silently drop the row.

**`-scroll-method 1` (continuous scroll).** Replaces the default page-jump scroll. With 20 lines visible and a potentially long list, this gives smoother navigation.

**Static `emojis.txt`, no generator script.** The file is hand-curated with short names chosen for searchability (e.g. `joy` instead of `face with tears of joy`). Regenerating from `unicodedata` would overwrite those short names.

**Focused window captured before rofi opens.** At the moment `awful.spawn.with_shell` fires, the previous window is still active. By the time `picker.sh` reaches `xdotool getactivewindow`, that window is still focused. This is reliable because AwesomeWM's keybinding handler hasn't transferred focus yet.

**`-no-custom` prevents freeform input.** Only an entry from the list can be submitted. This avoids accidental garbage being typed or copied if the user misses a selection.

**Clipboard copy as fallback.** `xclip -selection clipboard` runs before `xdotool type`, so even if `xdotool` fails (e.g. the target window closed), the emoji is still in the clipboard for a manual paste.

## Testing

- Press `Meta + .`: rofi opens fullscreen showing the emoji list
- Type `joy`: list filters to entries containing "joy"
- Type `JOY`: same results (case-insensitive)
- Type part of a full Unicode name (e.g. `tears`): entries whose full name contains "tears" appear
- Type `happy`: 😊 happy ranks first, 🙋 raising hand second
- Type `bat`: 🦇 bat ranks first, 🛀 bath second
- Select an emoji with Enter: rofi closes; emoji appears in the previously focused window
- Check clipboard after selection: emoji is present (`xclip -o -selection clipboard`)
- Press `Escape`: rofi closes; nothing is typed; clipboard unchanged
- Type a string that matches nothing, press Enter: not possible — Enter on an empty list does nothing
- Window fills entire screen
- 20 rows visible
- Each row shows emoji glyph + one name, with no parenthetical and no dimmed text
- Scrolling is continuous, not page-jumping
- Colors match the launcher exactly
