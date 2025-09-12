-- Configuring noice.nvim with provided settings
return {
  'folke/noice.nvim',
  event = 'VeryLazy', -- Lazy-load for performance
  dependencies = {
    'MunifTanjim/nui.nvim', -- Required for UI components
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- Requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      bottom_search = true, -- Classic bottom cmdline for search
      command_palette = true, -- Cmdline and popupmenu together
      long_message_to_split = true, -- Long messages to split
      inc_rename = false, -- Disable inc-rename input dialog
      lsp_doc_border = false, -- No border on hover docs/signature help
    },
  },
}
