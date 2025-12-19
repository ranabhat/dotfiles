return {
  {
    -- amongst your other plugins
    -- {'akinsho/toggleterm.nvim', version = "*", config = true}
    -- or
    {
      'akinsho/toggleterm.nvim',
      enabled = true,
      version = '*',
      opts = {--[[ things you want to change go here]]
        -- direction = 'float',
        shade_terminals = false,
        vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' }),
      },
    },
  },
}
