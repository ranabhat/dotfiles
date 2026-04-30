return {
  {
    'onsails/lspkind.nvim',
    lazy = true,
    -- load it when cmp is loaded, or on InsertEnter
    event = 'InsertEnter',
    config = function()
      require('lspkind').init {
        -- You can choose how the icons + text show
        mode = 'symbol_text', -- options: "symbol", "text", "symbol_text", "text_symbol"
        preset = 'default', -- or "codicons"
        symbol_map = {
          Text = '󰉿',
          Method = '󰆧',
          Function = '󰊕',
          Constructor = '',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '',
          Property = '',
          Unit = '',
          Value = '',
          Enum = '',
          Keyword = '',
          Snippet = '﬌',
          Color = '',
          File = '',
          Reference = '',
          Folder = '',
          EnumMember = '',
          Constant = '',
          Struct = '',
          Event = '',
          Operator = 'ﬦ',
          TypeParameter = '',
        },
        -- optionally override formatting, etc.
        -- you can also set `maxwidth`, `ellipsis_char`, etc.
      }
    end,
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    -- event = 'LspAttach',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opts = {} },

      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'onsails/lspkind.nvim',
      'folke/lazydev.nvim',
      'echasnovski/mini.nvim',
      'xzbdmw/colorful-menu.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal',
      },

      completion = {

        trigger = {
          show_on_trigger_character = true,
          show_on_keyword = true,
        },
        menu = {

          border = 'rounded',
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            -- columns = { { 'kind_icon', 'kind' }, { 'label', 'label_description', gap = 1 } },

            columns = {
              { 'kind_icon', gap = 1 },

              { 'label', 'label_description', gap = 1 },
              { 'kind', width = { max = 12 }, align = 'right' },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require('colorful-menu').blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                  end
                  -- Do something else
                  return highlights
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = 'single' },
        },
        -- ghost_text = { enabled = true, hl_group = 'Comment' },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      -- fuzzy = { implementation = 'lua' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          show_documentation = true,
          border = 'single',
        },
      },
    },
  },
}
