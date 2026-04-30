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
  -- ════════════════════════════════════════════════════════════════════════════
  --    Completion (blink.cmp) Adibhanna
  -- ════════════════════════════════════════════════════════════════════════════
  {
    'saghen/blink.cmp',
    dependencies = {
      'folke/lazydev.nvim',
      'saghen/blink.lib',
      'onsails/lspkind.nvim',

      { 'nvim-tree/nvim-web-devicons', opts = {} },
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
      'echasnovski/mini.nvim',
      'xzbdmw/colorful-menu.nvim',
    },
    version = '*',
    config = function()
      require('blink.cmp').setup {
        -- snippets = { preset = 'default' },
        snippets = { preset = 'luasnip' },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
            border = 'single',
          },
        },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = 'normal',
        },
        sources = {
          default = { 'lazydev', 'lsp', 'path', 'buffer', 'snippets' },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              score_offset = 100,
            },
            cmdline = {
              min_keyword_length = 2,
            },
          },
        },
        keymap = {
          ['<C-f>'] = {},
        },
        cmdline = {
          enabled = false,
          completion = { menu = { auto_show = true } },
          keymap = {
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
          },
        },
        completion = {
          trigger = {
            show_on_accept_on_trigger_character = true,
            show_on_keyword = true,
          },

          menu = {

            border = 'rounded',
            draw = {
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
                    return require('lspkind').symbol_map[ctx.kind] or ''
                    -- local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                    -- return kind_icon
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
          -- menu = {
          --   border = 'rounded',
          --   scrolloff = 1,
          --   scrollbar = false,
          --   draw = {
          --     padding = 1,
          --     gap = 1,
          --     columns = {
          --       { 'kind_icon' },
          --       { 'label', 'label_description', gap = 1 },
          --       { 'kind' },
          --       { 'source_name' },
          --     },
          --   },
          -- },
          documentation = {
            window = {
              border = 'rounded',
              scrollbar = false,
              winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
            },
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
      }
    end,
  },
}
