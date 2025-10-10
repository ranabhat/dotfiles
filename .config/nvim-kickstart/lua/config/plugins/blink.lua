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
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        -- menu = {
        --   draw = {
        --     columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
        --     components = {
        --       kind_icon = {
        --         text = function(ctx)
        --           local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
        --           return kind_icon
        --         end,
        --         -- (optional) use highlights from mini.icons
        --         highlight = function(ctx)
        --           local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
        --           return hl
        --         end,
        --       },
        --       kind = {
        --         -- (optional) use highlights from mini.icons
        --         highlight = function(ctx)
        --           local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
        --           return hl
        --         end,
        --       },
        --     },
        --   },
        -- },
        -- menu = {
        --   border = 'rounded',
        --   trigger = {
        --     preselect = true,
        --     show_on_trigger_character = true,
        --   },
        --   draw = {
        --     components = {
        --       kind_icon = {
        --         text = function(ctx)
        --           if ctx.source_name ~= 'Path' then
        --             return require('lspkind').symbolic(ctx.kind, { mode = 'symbol' }) .. ctx.icon_gap
        --           end
        --
        --           local is_unknown_type = vim.tbl_contains({ 'link', 'socket', 'fifo', 'char', 'block', 'unknown' }, ctx.item.data.type)
        --           local mini_icon, _ = require('mini.icons').get(is_unknown_type and 'os' or ctx.item.data.type, is_unknown_type and '' or ctx.label)
        --
        --           return (mini_icon or ctx.kind_icon) .. ctx.icon_gap
        --         end,
        --
        --         highlight = function(ctx)
        --           if ctx.source_name ~= 'Path' then
        --             return ctx.kind_hl
        --           end
        --
        --           local is_unknown_type = vim.tbl_contains({ 'link', 'socket', 'fifo', 'char', 'block', 'unknown' }, ctx.item.data.type)
        --           local mini_icon, mini_hl = require('mini.icons').get(is_unknown_type and 'os' or ctx.item.data.type, is_unknown_type and '' or ctx.label)
        --           return mini_icon ~= nil and mini_hl or ctx.kind_hl
        --         end,
        --       },
        --     },
        --   },
        -- },
        -- draw = {
        --   components = {
        --     kind_icon = {
        --       text = function(ctx)
        --         local icon = ctx.kind_icon
        --         if vim.tbl_contains({ 'Path' }, ctx.source_name) then
        --           local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
        --           if dev_icon then
        --             icon = dev_icon
        --           end
        --         else
        --           icon = require('lspkind').symbolic(ctx.kind, {
        --             mode = 'symbol',
        --           })
        --         end
        --
        --         return icon .. ctx.icon_gap
        --       end,
        --
        --       -- Optionally, use the highlight groups from nvim-web-devicons
        --       -- You can also add the same function for `kind.highlight` if you want to
        --       -- keep the highlight groups in sync with the icons.
        --       highlight = function(ctx)
        --         local hl = ctx.kind_hl
        --         if vim.tbl_contains({ 'Path' }, ctx.source_name) then
        --           local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
        --           if dev_icon then
        --             hl = dev_hl
        --           end
        --         end
        --         return hl
        --       end,
        --     },
        --   },
        -- },
        -- },
        menu = {

          border = 'rounded',
          trigger = {
            preselect = true,
            show_on_trigger_character = true,
          },
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
