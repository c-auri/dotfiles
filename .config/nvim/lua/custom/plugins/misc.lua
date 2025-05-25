return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    '0xAdk/full_visual_line.nvim',
    keys = 'V',
    opts = {},
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        css = {
          rgb_fn = true,
          names = true,
        },
      }, { names = false })
    end,
  },
}
