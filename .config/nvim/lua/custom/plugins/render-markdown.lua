return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig

  opts = {
    render_modes = true,

    heading = {
      icons = { '', '', '', '', '', '' },
      position = 'inline',
      border = true,
      border_virtual = true,
      sign = false,
      backgrounds = {
        'Heading1',
        'Heading2',
        'Heading3',
        'Heading4',
        'Heading5',
        'Heading6',
      },
    },

    link = {
      enabled = false,
      image = '',
      hyperlink = '',
    },

    bullet = {
      icons = { '•' },
    },

    code = {
      style = 'normal',
      border = 'thin',
      left_pad = 1,
      right_pad = 1,
    },

    callout = {
      note = {
        raw = '[!NOTE]',
        rendered = 'Note   ',
        highlight = 'RenderMarkdownInfo',
        category = 'github',
      },
      tip = {
        raw = '[!TIP]',
        rendered = 'Tip  ',
        highlight = 'RenderMarkdownSuccess',
        category = 'github',
      },
      important = {
        raw = '[!IMPORTANT]',
        rendered = 'Important  ',
        highlight = 'RenderMarkdownHint',
        category = 'github',
      },
      warning = {
        raw = '[!WARNING]',
        rendered = 'Warning  ',
        highlight = 'RenderMarkdownWarn',
        category = 'github',
      },
      caution = {
        raw = '[!CAUTION]',
        rendered = 'Caution  ',
        highlight = 'RenderMarkdownError',
        category = 'github',
      },
    },
  },
}
