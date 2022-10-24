local M = {}

-- Check Tcl syntax and populate the quickfix list with errors.
M.nagelfar = function(target)
  -- Save pre-existing settings to restore at the end.
  local old_makeprg = vim.bo.makeprg
  local old_pattern = vim.bo.errorformat

  -- This `-H` flag is necessary to prepend errors with line numbers.
  vim.bo.makeprg = 'nagelfar -H'

  -- Parses `$ nagelfar -H $target` output for `:make`.
  vim.bo.errorformat = table.concat({
    '%E%f: %l: %t %m',
    '%Z%f%.%#',
    '%C %.%m',
    '%-GChecking file %f',
    '%C%.%#'
  }, ',')

  vim.cmd.make(target) -- Populate the quickfix list with results.

  -- Restore pre-existing settings saved at the beginning.
  vim.bo.makeprg     = old_makeprg
  vim.bo.errorformat = old_pattern

  return true
end

M.setup = function()
  vim.api.nvim_create_user_command(
    'Nagelfar',
    function(args) M.nagelfar(args.args) end,
    {nargs = 1}
  )
end
