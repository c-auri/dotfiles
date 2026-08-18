return {
  {
    'preservim/vim-pencil',
    init = function()
      vim.g['pencil#wrapModeDefault'] = 'soft'
      vim.g['pencil#cursorwrap'] = 0
    end,
    config = function()
      vim.api.nvim_create_augroup('pencil', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = 'pencil',
        pattern = { 'markdown', 'mkd' },
        callback = function()
          vim.fn['pencil#init']()
        end,
      })
    end,
    ft = { 'markdown', 'mkd' },
  },

  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    ft = { 'markdown', 'mkd' },
    opts = {
      window = {
        backdrop = 1,
        width = 100,
      },
      -- Global statusline, so the position boxes stay visible in zen: the float
      -- would otherwise cover the per-window statusline row. zen shrinks its
      -- height by one row when laststatus is 3, and restores the old value on
      -- close.
      plugins = { options = { laststatus = 3 } },
    },
    config = function(_, opts)
      require('zen-mode').setup(opts)

      vim.api.nvim_create_augroup('zen_auto', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = 'zen_auto',
        pattern = { 'markdown', 'mkd' },
        callback = function(args)
          -- Real, editable files only: skip help, quickfix, nofile, diffs.
          if vim.bo[args.buf].buftype ~= '' or vim.wo.diff then
            return
          end
          -- Opening a float during FileType is unreliable, so defer it.
          vim.schedule(function()
            -- With `nvim a.md b.md` this fires per buffer; only zen the visible one.
            if vim.api.nvim_get_current_buf() ~= args.buf then
              return
            end
            if require('zen-mode.view').is_open() then
              return
            end
            require('zen-mode').open()
          end)
        end,
      })

      -- Make one `:wq` close the file for good. ZenMode leaves the original
      -- window open behind its float, so a plain quit only closes the float.
      -- QuitPre fires for :q/:wq but not for zen-mode's own nvim_win_close(),
      -- so toggling off with :ZenMode never reaches this.
      vim.api.nvim_create_autocmd('QuitPre', {
        group = 'zen_auto',
        callback = function()
          local view = require('zen-mode.view')
          if not view.is_open() or vim.api.nvim_get_current_win() ~= view.win then
            return
          end
          local zen_win, parent = view.win, view.parent
          -- Let the in-flight quit (and zen's teardown) finish first.
          vim.schedule(function()
            -- Float still there means the quit was aborted, e.g. unsaved changes.
            if vim.api.nvim_win_is_valid(zen_win) then
              return
            end
            if parent and vim.api.nvim_win_is_valid(parent) then
              vim.api.nvim_set_current_win(parent)
              pcall(vim.cmd, 'quit')
            end
          end)
        end,
      })
    end,
  },
}
