-- ════════════════════════════════════════════════════════════════════════════
-- Go Tools - Custom commands for Go development
-- ════════════════════════════════════════════════════════════════════════════

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function run_cmd(cmd, opts)
  opts = opts or {}
  local on_exit = opts.on_exit or function() end
  local cwd = opts.cwd or vim.fn.getcwd()

  vim.system(cmd, { text = true, cwd = cwd }, function(result)
    vim.schedule(function()
      on_exit(result)
    end)
  end)
end

local function get_package_path()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == '' then
    return '.'
  end
  return vim.fn.fnamemodify(filepath, ':h')
end

local function get_module_root()
  local filepath = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(filepath, ':h')
  while dir ~= '/' do
    if vim.fn.filereadable(dir .. '/go.mod') == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return vim.fn.getcwd()
end

-- ════════════════════════════════════════════════════════════════════════════
-- Build & Run
-- ════════════════════════════════════════════════════════════════════════════

-- GoBuild: go build
vim.api.nvim_buf_create_user_command(0, 'GoBuild', function(opts)
  local args = opts.args ~= '' and opts.args or './...'
  notify('Building: go build ' .. args)
  run_cmd({ 'go', 'build', args }, {
    cwd = get_module_root(),
    on_exit = function(result)
      if result.code == 0 then
        notify 'Build successful'
      else
        notify('Build failed:\n' .. (result.stderr or result.stdout), vim.log.levels.ERROR)
      end
    end,
  })
end, { nargs = '?', desc = 'go build' })

-- GoRun: go run
vim.api.nvim_buf_create_user_command(0, 'GoRun', function(opts)
  local args = opts.args ~= '' and opts.args or '.'
  local cmd_str = 'go run ' .. args
  -- Use terminal for interactive output
  vim.cmd('split | terminal ' .. cmd_str)
end, { nargs = '?', desc = 'go run' })

-- ════════════════════════════════════════════════════════════════════════════
-- Module Management
-- ════════════════════════════════════════════════════════════════════════════

-- GoModTidy: go mod tidy
vim.api.nvim_buf_create_user_command(0, 'GoModTidy', function()
  notify 'Running: go mod tidy'
  run_cmd({ 'go', 'mod', 'tidy' }, {
    cwd = get_module_root(),
    on_exit = function(result)
      if result.code == 0 then
        notify 'go mod tidy completed'
        vim.cmd 'checktime'
      else
        notify('go mod tidy failed:\n' .. (result.stderr or result.stdout), vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = 'go mod tidy' })
