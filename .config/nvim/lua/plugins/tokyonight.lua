return {

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    enabled = true,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
        on_highlights = function(hl, c)
          -- Blink.cmp completion menu
          hl.BlinkCmpMenu = { bg = c.bg_dark, fg = c.fg }
          hl.BlinkCmpMenuBorder = { fg = c.blue, bg = c.bg_dark }
          hl.BlinkCmpMenuSelection = { bg = c.bg_highlight }
          hl.BlinkCmpLabelMatch = { fg = c.blue, bold = true }
          hl.BlinkCmpLabelDescription = { fg = c.comment, italic = true }

          -- Shared doc/hover/signature-help window
          hl.BlinkCmpDoc = { bg = c.bg_dark, fg = c.fg }
          hl.BlinkCmpDocBorder = { fg = c.blue, bg = c.bg_dark }

          -- Fix odd inline-code highlight blocks in markdown hover popups
          hl['@markup.raw.markdown_inline'] = { bg = 'NONE', fg = c.green }
        end,
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
