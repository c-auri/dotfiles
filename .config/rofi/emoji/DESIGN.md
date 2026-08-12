# Emoji Picker: Open Design Questions

## 1. Unicode character names vs CLDR names

### Background

The parenthetical name in each entry - searchable but no longer displayed, see the ranking design decision in README.md - comes from the official Unicode character name, lowercased (e.g. via Python's `unicodedata.name()`). These names are frozen at the Unicode version when the character was standardized and use a verbose, mechanical naming convention from the early emoji era.

The Unicode Consortium also maintains CLDR, the Common Locale Data Repository. CLDR is the standard database of locale-specific data - date and number formats, translations, collation and pluralization rules - that most operating systems, browsers, and programming language standard libraries draw on. Unlike the Unicode character names, which are frozen forever once assigned, CLDR is revised with every release.

The emoji portion of CLDR is its *annotations*: for each emoji, a short name plus a set of search keywords, in each supported language. This is the data behind the emoji pickers in iOS and Android and behind Emojipedia, which is why the names those show differ from the ones in this file.

Two annotation fields matter here, both keyed by the emoji character itself. The one with `type="tts"` is the CLDR name, kept as short as natural language allows and rewritten when the Unicode name ages poorly. The untyped one is the keyword list:

```xml
<annotation cp="😂">crying | face | feels | funny | haha | happy | hehe | hilarious | joy | laugh | lmao | lol | rofl | roflmao | tear</annotation>
<annotation cp="😂" type="tts">face with tears of joy</annotation>
```

The question below concerns only the name. The keywords are a larger change and are taken up separately in `cldr-upgrade.md`.

Divergence is concentrated in the original Unicode 6.0 face block (U+1F600-U+1F64F). Examples:

| Emoji | Unicode char name | CLDR name |
|---|---|---|
| 😁 | grinning face with smiling eyes | beaming face with smiling eyes |
| 😃 | smiling face with open mouth | grinning face with big eyes |
| 😅 | smiling face with open mouth and cold sweat | grinning face with sweat |
| 😆 | smiling face with open mouth and tightly-closed eyes | grinning squinting face |
| 😤 | face with look of triumph | face with steam from nose |
| 😋 | face savouring delicious food | face savoring food |

For emoji added after ~Unicode 10 the names are usually identical or close. Animals, food, objects, and symbols are largely unaffected.

One source for CLDR names is `emoji-test.txt`, published by Unicode alongside each release. The name appears in the comment field:

```
1F605  ; fully-qualified  # 😅 E0.6 grinning face with sweat
1FAE0  ; fully-qualified  # 🫠 E14.0 melting face
```

The CLDR annotations file (`common/annotations/en.xml`) is the richer source: it carries the same names in its `tts` field plus the keywords. If `cldr-upgrade.md` is implemented, that file is already being fetched and this question can be answered from it rather than from `emoji-test.txt`.

### Options

**Option A - replace parenthetical with CLDR name**

Swap the Unicode char name in the parenthetical for the CLDR name. Short aliases (manually curated) are untouched. Entries that currently have no parenthetical and use the Unicode name directly would be updated in place.

Pros: parentheticals match Emojipedia; searching "steam", "melt", "sweat" starts working.
Cons: a handful of Unicode names contain keywords the CLDR name dropped (e.g. "triumph" in 😤, "tightly-closed" in 😆). These search terms would be silently lost unless the short alias is updated to compensate.

**Option B - show both names**

Keep the Unicode name and add the CLDR name, separated by a middot: `(cldr name · unicode name)`.

Pros: no search coverage lost.
Cons: visually noisy; many entries would show nearly identical duplicated text.

**Option C - replace short alias with CLDR name, leave parenthetical alone**

Set the short alias to the CLDR name for all entries that currently have no separate alias (i.e. those without a parenthetical). Leave manually curated aliases and existing parentheticals untouched.

Pros: purely additive; touches only entries without a custom alias.
Cons: for the face block, the CLDR names are not shorter than the Unicode names, so the "alias" provides no real shortening. Also doesn't fix the entries that already have a parenthetical.

### Recommendation

Option A, with a preparatory diff step:

1. Write a script that reads `emojis.txt`, strips the current parenthetical, fetches the CLDR name from `emoji-test.txt` by codepoint, and prints a side-by-side list of the ~30-40 entries where the names differ meaningfully.
1. Review that list: for each entry where the Unicode name contained a keyword worth keeping (e.g. "triumph", "tightly-closed"), update the short alias to cover it before applying the bulk replacement.
1. Apply the replacement.

This keeps the change mechanical and reviewable rather than doing it blind.

---

## 2. Keeping the emoji list up to date

### Problem

`emojis.txt` was built once and covers emoji up to Unicode 13.0 (March 2020). Unicode 14.0 (September 2021) added ~37 new emoji including 🫠 melting face; 15.0 and 15.1 added more. The list will continue to grow with each annual Unicode release.

A full regeneration from source data would overwrite manually curated short aliases, which is unacceptable. The update mechanism must add new entries without touching existing ones.

### Constraints

1. Existing lines in `emojis.txt` are never modified by the update mechanism.
1. New entries are added with a sensible default; the user may later edit the alias.
1. No runtime dependency is added to the picker itself.
1. The update can be run manually; it does not need to be fully automated.

### Data source

`https://unicode.org/Public/emoji/latest/emoji-test.txt`

This file is published with each Unicode release. It contains all emoji sequences, their status, the CLDR name, and the Unicode Emoji version they were introduced in (e.g. `E14.0`). It is the authoritative source for both "what emoji exist" and "what the CLDR name is."

Format:
```
# group: Smileys & Emotion
# subgroup: face-smiling
1F600                                  ; fully-qualified  # 😀 E1.0 grinning face
1FAE0                                  ; fully-qualified  # 🫠 E14.0 melting face
```

The file can be cached locally (fetch with `If-Modified-Since` and store in this directory as `emoji-test.txt`).

### Scope: which sequences to include

The file contains thousands of entries across four status levels. The picker should only include:

- **Include:** `fully-qualified`, single-codepoint entries (simple emoji)
- **Include:** `fully-qualified`, multi-codepoint sequences that are in `emojis.txt` today (e.g. keycap sequences, some flag entries) - match by what is already present, do not auto-include new sequence types
- **Exclude:** skin-tone variants (sequences containing U+1F3FB-1F3FF)
- **Exclude:** ZWJ sequences (sequences containing U+200D) - gender/profession variants are too numerous and niche for a general picker
- **Exclude:** regional indicator flag sequences (U+1F1E0-U+1F1FF pairs) - 258 national flags add noise; if wanted, add as a separate opt-in

This gives a manageable list of base emoji that grows predictably with each Unicode release.

### Update script design

An `update.py` script alongside the picker:

```
update.py [--fetch] [--dry-run]
```

Steps:

1. **Fetch** (if `--fetch` or no local `emoji-test.txt`): download from unicode.org to `emoji-test.txt` in this directory, using `If-Modified-Since` to avoid redundant downloads.
1. **Parse** `emoji-test.txt`: collect all fully-qualified entries matching the inclusion scope. Build a dict of `codepoint_sequence → (emoji_char, cldr_name, version, group, subgroup)`.
1. **Read** `emojis.txt`: extract the emoji character from the first field of every line. Build a set of codepoint sequences already present.
1. **Diff**: for each entry in the parsed source not present in `emojis.txt`, it is "new."
1. **Generate** default entries for new emoji. Format:
   ```
   🫠  melting face
   ```
   No parenthetical, no separate short alias - the CLDR name is used directly as the only label. The user can later promote an entry to the alias form if desired:
   ```
   🫠  melt (melting face)
   ```
1. **Insert** into `emojis.txt`: new entries go at the end of the block that corresponds to their `subgroup` from `emoji-test.txt`. The script matches subgroups to existing runs of emoji in `emojis.txt` by scanning for nearby codepoints in the same Unicode range. If no match is found, the entry is appended at the end of the file.
1. **Report** what was added: print a list of new entries so the user can review them and decide whether any short aliases are worth setting.

If `--dry-run` is passed, print what would change without writing anything.

### Key design choice: identity by codepoint, not name

The presence check in step 3 must use codepoint sequences, not names or characters, to be robust against:
- Emoji whose CLDR name changes between Unicode versions
- Rendering differences (some codepoints render differently in different fonts)
- Possible future changes to how emojis.txt is formatted

Extract codepoints from `emojis.txt` by taking the first whitespace-delimited field of each line and converting via `ord()` (or `unicodedata` for sequences).

### Suggested trigger

Run `./update.py --fetch` manually once per year after the Unicode release (typically September). Consider adding a comment line at the top of `emojis.txt` recording the last update:

```
# last updated: Unicode Emoji 15.1 (2023-09-12)
```
