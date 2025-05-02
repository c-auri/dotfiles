return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    theme = 'wave',
    background = {
      dark = 'dragon',
      light = 'lotus',
    },
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = 'none',
          },
        },
      },
    },
  },
  init = function()
    vim.cmd.colorscheme 'kanagawa'
    vim.cmd.hi 'Comment gui=none'
  end,
}
