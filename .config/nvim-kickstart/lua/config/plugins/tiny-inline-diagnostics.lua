return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    enabled = true,
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config { virtual_text = true } -- Disable default virtual text
    end,
  },
}
