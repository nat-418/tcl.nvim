local M = {}
M.nagelfar = {}
M.nagelfar.makeprg = 'nagelfar -H'

M.nagelfar.errorformat_short = table.concat({
  '%f: %l: %t %m',
  '%-GChecking file %f',
  '%C%.%#'
}, ',')

M.nagelfar.errorformat_long = table.concat({
  '%E%f: %l: %t %m',
  '%Z%f%.%#',
  '%C %.%m',
  '%-GChecking file %f',
  '%C%.%#'
}, ',')

M.nagelfar.setup_lint = function()
  local lint        = require('lint')
  local lint_parser = require('lint.parser')

  lint.linters.nagelfar = {
    cmd            = 'nagelfar',
    args           = {'-H'},
    append_fname   = true,
    stdin          = false,
    stream         = 'both',
    ignore_exitcod = true,
    env            = nil,
    parser         = lint_parser.from_errorformat(M.nagelfar.errorformat_short)
  }

  lint.linters_by_ft = {
    tcl = {'nagelfar',}
  }

  vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
    pattern = {'*.tcl'},
    callback = function() lint.try_lint() end
  })
end

M.nagelfar.make = function(target)
  -- Save pre-existing settings to restore at the end.
  local old_makeprg = vim.bo.makeprg     or vim.o.makeprg
  local old_pattern = vim.bo.errorformat or vim.o.errorformat

  vim.bo.makeprg     = M.nagelfar.makeprg
  vim.bo.errorformat = M.nagelfar.errorformat_long

  -- Populate the quickfix list with results.
  vim.cmd.make(target)

  -- Restore pre-existing settings saved at the beginning.
  vim.bo.makeprg     = old_makeprg
  vim.bo.errorformat = old_pattern

  return true
end

M.setup = function()
  M.nagelfar.setup_lint()

  vim.api.nvim_create_user_command(
    'Nagelfar',
    function(args) M.nagelfar.make(args.args) end,
    {nargs = 1}
  )

  return true
end

return M
