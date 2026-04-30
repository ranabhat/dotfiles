--- Set up LSP keymaps and autocommands for the given buffer
--- @param client vim.lsp.Client
--- @param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|vim.keymap.set.Opts
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    mode = mode or 'n'
    ---@cast opts vim.keymap.set.Opts
    opts = type(opts) == 'string' and { desc = opts } or opts
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- if client:supports_method 'textDocument/codeAction' then
  --   keymap('gra', function()
  --     vim.lsp.buf.code_action()
  --   end, { noremap = true, silent = true }, { 'n', 'x' })
  -- end
  -- if client:supports_method 'textDocument/codeAction' then
  --   keymap('gra', function()
  --     require('tiny-code-action').code_action()
  --   end, { noremap = true, silent = true }, { 'n', 'x' })
  -- end

  if client:supports_method 'textDocument/references' then
    keymap('gra', '<cmd>FzfLua lsp_code_actions<cr>', 'vim.lsp.buf.code_action()')
  end
  if client:supports_method 'textDocument/references' then
    keymap('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')
  end
  if client:supports_method 'textDocument/documentSymbol' then
    keymap('gO', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
  end
  if client:supports_method 'textDocument/documentSymbol' then
    keymap('grt', '<cmd>FzfLua lsp_typedefs<cr>', 'Type Definitions')
  end
  -- if client:supports_method 'textDocument/documentSymbol' then
  --   keymap('gW', '<cmd>FzfLua lsp_workspace_symbols<cr>', 'Workspace symbols')
  -- end
  if client:supports_method 'textDocument/definition' then
    keymap('grd', function()
      require('fzf-lua').lsp_definitions { jump1 = true }
    end, 'Go to definition')
    keymap('grD', function()
      require('fzf-lua').lsp_definitions { jump1 = false }
    end, 'Peek definition')
  end
  if client:supports_method 'textDocument/signatureHelp' then
    keymap('<C-k>', function()
      -- Close the completion menu first (if open).
      if require('blink.cmp.completion.windows.menu').win:is_open() then
        require('blink.cmp').hide()
      end

      vim.lsp.buf.signature_help()
    end, 'Signature help', 'i')
  end
  if client:supports_method 'textDocument/documentHighlight' then
    local under_cursor_highlights_group = vim.api.nvim_create_augroup('ranabhat/cursor_highlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
  if client:supports_method 'textDocument/inlayHint' then
    keymap('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, '[T]oggle Inlay [H]ints')
  end
end

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  } or {},
}
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover {
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  }
end
-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers['client/registerCapability']
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    -- Extend neovim's client capabilities with the completion ones.
    vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

    local servers = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ':t:r')
      end)
      :totable()
    vim.lsp.enable(servers)
  end,
})

-- HACK: Override buf_request to ignore notifications from LSP servers that don't implement a method.
local buf_request = vim.lsp.buf_request
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_request = function(bufnr, method, params, handler)
  return buf_request(bufnr, method, params, handler, function() end)
end

-- vim.keymap.set({ 'n', 'x' }, 'gra', function()
--   require('tiny-code-action').code_action()
-- end, { noremap = true, silent = true })

-- vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
--   once = true,
--   callback = function()
--     -- Extend neovim's client capabilities with the completion ones.
--     vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
--
--     local servers = vim
--       .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
--       :map(function(file)
--         return vim.fn.fnamemodify(file, ':t:r')
--       end)
--       :totable()
--     vim.lsp.enable(servers)
--   end,
-- })
