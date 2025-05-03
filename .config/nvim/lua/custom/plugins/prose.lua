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
    opts = {
      window = {
        backdrop = 1,
        width = 100,
      },
    },
  },
}
