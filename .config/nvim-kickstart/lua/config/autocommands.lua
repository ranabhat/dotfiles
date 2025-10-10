-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt_local.foldlevel = 99
  end,
})
-- jump to last edit position on opening file
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
      -- except for in git commit messages
      -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      if not vim.fn.expand('%:p'):find('.git', 1, true) then
        vim.cmd 'exe "normal! g\'\\""'
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'ColorScheme', 'UIEnter' }, {
  desc = 'Corrects terminal background color according to colorscheme',
  callback = function()
    if vim.api.nvim_get_hl(0, { name = 'Normal' }).bg then
      io.write(string.format('\027]11;#%06x\027\\', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg))
    end
  end,
})
