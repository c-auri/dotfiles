# Emoji Picker: CLDR Keyword Upgrade

## Problem

Ranking is solved; the corpus is not. Every emoji currently carries one or two names, so `lol`, `cry`, `smile`, `wow`, and `thanks` find nothing at all, no matter how good the ordering is. The picker can only find an emoji by a word someone already typed into `emojis.txt`.

CLDR annotations fix this at the source. See the background section of `DESIGN.md` for what CLDR is; in short, it gives each emoji a curated keyword list, so 😂 is reachable by `lol`, `lmao`, `rofl`, `haha`, `funny`, and `hilarious`.

The complication is that adding keywords makes ranking matter far more than it does today. Keywords are generic and heavily shared: `face` appears in 148 of them. A design that dumps keywords into the existing search corpus without a ranking story will make search worse, not better.

## Data source

`https://raw.githubusercontent.com/unicode-org/cldr/<tag>/common/annotations/en.xml`, published under the Unicode License. Pin a release tag (`release-46` was used for the measurements below) rather than tracking `main`, so a sync is a deliberate, reviewable act. `common/annotationsDerived/en.xml` carries names for sequences and is a second fetch if sequence coverage is ever wanted.

Measured against the current `emojis.txt`:

| Metric | Value |
|---|---|
| Entries in `emojis.txt` | 2075 |
| Covered by CLDR annotations | 1251 |
| Not covered | 824 |
| Distinct keywords over the covered set | 3246 |

Adding the variation selector U+FE0F to unmatched entries recovers nothing, so the gap is real rather than an encoding mismatch. The 824 uncovered entries are overwhelmingly not emoji: chess pieces, dingbats, astrological and technical symbols, ornamental punctuation. Examples: `⛍ disabled car`, `❻ dingbat negative circled digit six`, `♘ white chess knight`, `⏜ top parenthesis`. They keep working exactly as they do today, they simply gain no keywords.

Keyword fan-out for representative queries, counting keyword matches only:

| Query | Emoji matched on keywords |
|---|---|
| `lol` | 6 |
| `cry` | 8 |
| `happy` | 25 |
| `heart` | 33 |
| `face` | 149 |

## What rofi allows

These are verified against the rofi 1.7.1 source, not inferred. They bound the design.

1. In dmenu mode the displayed string, the matched string, and the scored string are one and the same. `dmenu` sets `_get_completion = NULL`, so `mode_get_completion` falls back to the display value.
1. The `meta` row option is matched only when the visible text fails to match (`dmenu_token_match`) and is never scored. This yields exactly two tiers and no more.
1. Script mode adds nothing: it sets `_get_completion = NULL, _preprocess_input = NULL` (`source/dialogs/script.c:448`) and is re-invoked only on selection, never per keystroke.
1. A mode plugin sets `_get_display_value`, `_token_match`, and `_get_completion` independently, which decouples all three concerns.
1. `mode_preprocess_input` receives the live query at the top of every refilter (`source/view.c:1123`), before matching. A plugin can re-rank its own record array there.
1. With `-no-sort`, rofi presents matches in the mode's index order. Each filter thread fills its `line_map` block in ascending order and the blocks are compacted in ascending order; `g_qsort_with_data` runs only when `config.sort` is set.
1. Tied scores preserve insertion order. `g_qsort_with_data` is a stable merge sort as of glib 2.32.

Points 2 and 7 are what make Option A viable without C. Points 4, 5, and 6 together are what make arbitrary ranking possible with it.

## Option A: keywords in the meta field

Keep the current architecture. Widen `meta` from the full Unicode name to the full name plus the CLDR name plus the keywords.

This produces two tiers. Rows whose visible short name matches are scored normally by rofi and ranked well, exactly as measured today. Rows matching only through `meta` score as non-matches, sort below every tier-1 hit, and tie with each other. By point 7 those ties resolve to file order.

That makes file order the tier-2 ranking, which is worth stating explicitly because it is currently accidental. `emojis.txt` is in codepoint order, which puts the original Unicode 6.0 smileys first, so `face` would lead with 😀😃😄 rather than something obscure. That is a serviceable default and no reordering is needed, but the dependency must be documented or a future re-sort will silently degrade search.

Good: no build step, no new language, no ABI to track, and it preserves the measured 0-misrank behaviour for short names. The change is confined to the sync script plus one join in `picker.sh`.

Bad: no quality ranking whatsoever inside tier 2. A query like `face` returns 149 rows in a fixed order that ignores how well each one matches. There is no way to prefer an exact keyword hit over a partial one, and no third tier to separate the CLDR name from the keyword list. The parenthetical also stays hidden.

## Option B: a rofi mode plugin

Replace the dmenu invocation with a custom mode in C, loaded from `~/.config/rofi/emoji/` via `ROFI_PLUGIN_PATH` (honoured in 1.7.1 at `source/rofi.c:580`; the `-plugin-path` flag is deprecated, the environment variable is not).

The plugin owns ranking outright: it re-sorts its records against the query in `_preprocess_input`, runs with `-no-sort`, and rofi renders that order. Tiers become arbitrary, match quality within a tier becomes expressible, and `_get_display_value` is free to render the dimmed parenthetical again since it no longer feeds the scorer.

Good: it is the only design that gets the visible parenthetical back and the only one that can rank keyword matches by quality. The theme, the keybinding, and `shared-style.rasi` are all untouched.

Bad: it is C, which `dedev/scripting-conventions.md` places outside the defaults and requires a reason for. It needs a build step, which the same document advises against. rofi 1.7.1 declares `ABI_VERSION 6u` and refuses to load a plugin built against another version, so a distro upgrade breaks the picker until it is rebuilt. Keep `emojis.txt` and a dmenu code path in `picker.sh` as a fallback for that morning.

## Recommendation: stage it

Do Option A first, then Option B only if measurement says it is needed.

The argument is that the expensive, irreversible work is the data pipeline and the ranking rules, and that work is identical under both options. The C plugin is a delivery mechanism bolted on at the end. Committing to it up front means paying the ABI and build costs before knowing whether two tiers are actually insufficient.

The deciding evidence should be the test harness described below, not intuition. If `face` and `heart` turn out to be rare queries in practice and tier-2 order rarely matters, Option A is the whole project. If they are common, Option B becomes justified and the ranking function is already written and tested by then.

## Data model

Keep `emojis.txt` hand-curated and unchanged in format. Constraint 1 of `DESIGN.md` already says generated tooling must never modify existing lines, and that holds here.

Add a generated sidecar, `keywords.tsv`, one row per covered emoji:

```
😂	crying	face	feels	funny	haha	happy	hehe	hilarious	joy	laugh	lmao	lol	rofl	roflmao	tear
```

`picker.sh` joins the two files at launch and emits the meta rows it already emits. Joining 2075 and 1251 lines with awk is immaterial next to rofi's own startup, so there is no build artifact to track and no staleness to manage. The separation also keeps the hand-edited file small and readable, and keeps generated data out of manual review.

Conceptually each record is: the emoji, a display label, and keywords in three tiers - the curated short name, the Unicode and CLDR names, and the CLDR keyword list. Option A collapses tiers 2 and 3; Option B keeps them distinct.

## Sync script

`cldr-sync.py`, alongside the `update.py` already designed in `DESIGN.md`. They share the fetch-and-cache pattern and could later merge.

1. Fetch `annotations/en.xml` at the pinned tag, cache it in this directory, and use `If-Modified-Since`.
1. Parse it into `cp -> (tts_name, [keywords])`, keyed by the literal emoji character.
1. Read `emojis.txt` for the set of emoji actually in the picker, by first whitespace-delimited field.
1. Emit `keywords.tsv` for the intersection. Drop keywords already present in the entry's short name to keep rows short; they are matched from the visible text anyway.
1. Report coverage and, in particular, list entries in `emojis.txt` with no annotation, so the pruning question below stays visible.
1. Never write to `emojis.txt`.

`--dry-run` prints the diff without writing, matching `update.py`.

## Test harness

This is the part that makes the staging decision honest, and it is worth building before either option.

`rank-model.py` is a faithful port of `rofi_scorer_fuzzy_evaluate` from `source/helper.c`, including the trailing-gap decay and the 256-character cutoff. It is what produced every number in this document and in the ranking design decision in README.md, and it lets the ranking be measured over the whole corpus without launching rofi or needing an X display.

`queries.tsv` holds `query -> expected emoji` assertions. Seed it from three places: the 2049 distinct short names, each of which should return its own emoji first; a hand-written set of the synonym cases that motivate this work (`lol` to 🤣 or 😂, `cry` to 😭, `thanks` to 🙏); and any query that ever surprises you in real use, added at the moment it surprises you.

The harness reports first-place accuracy and how many expectations fall outside the top three. Option A ships when short-name accuracy is unchanged from today and the synonym cases pass. Option B is justified if, and only if, the harness shows tier-2 ordering failing on queries that matter.

## Open questions

**Prune the non-emoji symbols?** The 824 entries without annotations are mostly not emoji, and they actively dilute results: `❉ balloon-spoked asterisk` outranking `🎈 balloon` was one of the 97 original ranking failures. Removing them would improve search independently of everything else here, but it removes characters that are occasionally the point of having a Unicode picker. Decide separately from the CLDR work.

**Pin or track CLDR?** Pinning a tag makes syncs deliberate and reviewable. Tracking `main` keeps keywords current automatically but makes the corpus change under you without review. The recommendation is to pin, and to bump it in the same annual pass as the `update.py` run described in `DESIGN.md`.

**Keep the parenthetical hidden?** Under Option A it must stay hidden, for the reasons in the README ranking decision. Under Option B it can come back. This is the single most visible user-facing difference between the two options and is the strongest non-measurable argument for B.
