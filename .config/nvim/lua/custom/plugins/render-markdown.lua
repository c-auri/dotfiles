return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig

  config = function()
    require('render-markdown').setup {
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
    }

    vim.api.nvim_set_hl(0, 'Heading1', { bg = '#181616', fg = '#e6c384', bold = true })
    vim.api.nvim_set_hl(0, 'Heading2', { bg = '#181616', fg = '#c9a86a', bold = true })
    vim.api.nvim_set_hl(0, 'Heading3', { bg = '#181616', fg = '#b8985b', bold = true })
    vim.api.nvim_set_hl(0, 'Heading4', { bg = '#181616', fg = '#8b6f34', bold = true })
    vim.api.nvim_set_hl(0, 'Heading5', { bg = '#181616', fg = '#8b6f34', bold = false })
    vim.api.nvim_set_hl(0, 'Heading6', { bg = '#181616', fg = '#765c22', bold = false })

    vim.api.nvim_set_hl(0, 'RenderMarkdownInfo', { fg = '#7E9CD8' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownSuccess', { fg = '#98BB6C' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownHint', { fg = '#957FB8' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownWarn', { fg = '#FFA066' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownError', { fg = '#FF5D62' })
  end,
}
