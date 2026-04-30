return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    config = function()
      require('fzf-lua').setup {
        winopts = { border = 'rounded' },
        lsp = {
          code_actions = {
            winopts = {
              width = 70,
              height = 20,
              relative = 'cursor',
              preview = {
                hidden = true,
                vertical = 'down:50%',
              },
            },
          },
        },
      }
      require('fzf-lua').register_ui_select()
    end,
  },
}
