return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        json = { 'prettier' },
        python = {
          -- To fix auto-fixable lint errors.
          'ruff_fix',
          -- To run the Ruff formatter.
          'ruff_format',
          -- To organize the imports.
          'ruff_organize_imports',
        },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
    -- config = function(_, opts)
    --   local conform = require 'conform'
    --   conform.setup(opts)
    --   conform.formatters.shfmt = {
    --     prepend_args = { '-i', '2' }, -- 2 spaces instead of tab
    --   }
    --   conform.formatters.stylua = {
    --     prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' }, -- 2 spaces instead of tab
    --   }
    --   vim.g.autoformat = vim.g.autoformat
    --   vim.api.nvim_create_user_command('ToggleAutoformat', function()
    --     vim.api.nvim_notify('Toggling autoformat', vim.log.levels.INFO, { title = 'conform.nvim', timeout = 2000 })
    --     vim.g.autoformat = vim.g.autoformat == false and true or false
    --   end, { desc = 'Toggling autoformat' })
    --   vim.keymap.set('n', '<leader>tF', '<cmd>ToggleAutoformat<cr>', { desc = 'Toggle format on save' })
    -- end,
  },
}
