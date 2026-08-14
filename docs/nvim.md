# Neovim

The config is a [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) fork. Upstream files (`lua/kickstart/**`, `doc/kickstart.txt`, its own `README.md` and `LICENSE.md`, `.github/`) are kept as they came so they can still be diffed against upstream; everything of my own lives in [`lua/custom/plugins/`](../.config/nvim/lua/custom/plugins) and [`ftplugin/`](../.config/nvim/ftplugin). Keeping my own prose out of `.config/nvim/` is also why this document sits in `docs/` rather than next to the config.

Plugins are managed by lazy.nvim. Versions are pinned in `lazy-lock.json`, which is gitignored by kickstart's own `.gitignore`, so each machine resolves its own versions rather than sharing a lockfile.

## Prose

### Goal

Markdown should read like a document rather than like code: a comfortable measure of text, centered, with paragraphs wrapping on their own so a paragraph stays a single line in the file. Moving the cursor down inside a wrapped paragraph should land on the line below it visually, not skip to the next paragraph.

### Division of labor

No single plugin provides that; four pieces each contribute one part, which is easy to misattribute later.

- **[zen-mode.nvim](../.config/nvim/lua/custom/plugins/prose.lua)** in `prose.lua` gives the measure and the centering, and nothing else. It opens the buffer in a centered floating window of `width = 100`, and touches neither `wrap`, `textwidth`, `linebreak`, nor any mapping.
- **[vim-pencil](../.config/nvim/lua/custom/plugins/prose.lua)** in `prose.lua` gives soft wrap (`wrap` + `linebreak`, `textwidth = 0`) and the display-line cursor movement, remapping `j`→`gj` and `k`→`gk` gated on `b:pencil_wrap_mode` (`pencil.vim:414-424`). A `FileType` autocmd enables it for markdown.
- **`breakindent`** in [`init.lua:21`](../.config/nvim/init.lua) keeps the indentation of wrapped lines, which is what keeps wrapped list items and block quotes readable.
- **[render-markdown.nvim](../.config/nvim/lua/custom/plugins/markdown.lua)** in `markdown.lua` does in-buffer prettifying only: heading icons and per-level backgrounds, `•` bullets, `□`/`✔` checkboxes, thin code-block borders, GitHub callouts.

The practical consequence: **the cursor behaviour is pencil's, not zen-mode's**, so it is already active in a plain markdown buffer and does not change when toggling zen mode off. Only the width and the centering come and go.

[vivify.vim](../.config/nvim/lua/custom/plugins/markdown.lua) handles browser preview, and replaced markdown-preview.nvim. Its config lives in [`.config/vivify/`](../.config/vivify).

Effective state measured in a markdown buffer: `wrap=true linebreak=true textwidth=0 breakindent=true conceallevel=3 pencil_wrap_mode=2`.

### Deliberate decisions

**Soft wrap, never hard breaks.** Pencil runs in soft mode (`pencil#wrapModeDefault = 'soft'`), so nothing is ever written into the file to achieve wrapping and `textwidth` stays `0`. A paragraph remains one long line on disk. This is the same reason prose in this repository is not hand-wrapped: wrapping is a property of how text is displayed, not of the text.

**The measure comes from the window, not the file.** 100 columns is a zen-mode window width, so the file is untouched and reads identically in any other tool. Setting `textwidth` instead would bake one editor's preference into the content.

**Link syntax stays visible.** `link.enabled = false` in `markdown.lua`, because concealed links hide the URL exactly when it needs editing.

**`pencil#cursorwrap = 0`.** This only disables pencil's `whichwrap` / `virtualedit=onemore` tweak, which lets `h` and `l` cross line boundaries. It has nothing to do with `j`/`k`, despite the name.

### Non-obvious mechanisms

**Zen mode opens itself for markdown.** A `FileType` autocmd in `prose.lua` calls `require('zen-mode').open()`. Three guards matter: it skips buffers with a non-empty `buftype` and diff windows; it defers through `vim.schedule` because opening a float during `FileType` is unreliable; and inside the deferred callback it re-checks that the buffer is still the current one, because `nvim a.md b.md` fires `FileType` for both and only one ends up displayed.

**One `:wq` closes the file for good.** Zen mode leaves the original window open behind its float, so a plain quit would only close the float and leave a second window on the same buffer. A `QuitPre` autocmd handles this, and the reason `QuitPre` is the right hook is subtle: zen-mode tears its float down with `nvim_win_close` (`view.lua:54`), an API call that does *not* fire `QuitPre`. Only a real `:q`/`:wq` does, so toggling off with `:ZenMode` never reaches the handler and does not quit. The handler then schedules a second quit, guarded on the float having actually closed — `QuitPre` fires *before* Vim decides whether the quit is allowed, so without that guard a refused quit would still close the window. It quits the parent window rather than running `:qall`, so unrelated splits survive.

`:ZenMode` remains a plain toggle back to the normal window at any time.

### Rough edges

**`:q!` on an unsaved buffer needs two presses.** The abort-guard above cannot distinguish "quit refused" from "quit forced", and the safe direction is to not chain the second quit. `:wq` and `:q` on a saved buffer are one keystroke.

**`ftplugin/markdown.lua` does not get its way on concealment.** It sets `conceallevel = 0`, but render-markdown.nvim sets `conceallevel = 3` on any buffer it renders (`win_options.lua:15-20`), and it wins — the measured value in a markdown buffer is `3`. The `concealcursor = ''` half of the ftplugin happens to agree with render-markdown's `rendered` value, so only the level is actually overridden. To genuinely disable concealment, set `win_options.conceallevel.rendered = 0` in the render-markdown config instead.

**Heading colours are hardcoded to kanagawa dragon.** The eleven `nvim_set_hl` calls at the end of `markdown.lua` use literal hex values, and the `#181616` backgrounds are dragon's background colour. Changing the colorscheme in `colorscheme.lua` silently leaves these wrong.

**mason-lspconfig currently errors on startup.** `Failed to run config for nvim-lspconfig`: `attempt to call field 'enable' (a nil value)`. `vim.lsp.enable` arrived in Neovim 0.11 and this machine runs 0.10.0, so the plugin has moved past the editor. Unrelated to prose, but it is the error scrolling past on every launch.
