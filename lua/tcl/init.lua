local M = {}

M.nagelfar = function(target)
  local old_makeprg = vim.bo.makeprg
  local old_pattern = vim.bo.errorformat

  vim.bo.makeprg = 'nagelfar -H'

  -- Parses `$ nagelfar -H $target` output
  local pattern = table.concat({
    '%E%f: %l: %t %m',
    '%Z%f%.%#',
    '%C %.%m',
    '%-GChecking file %f',
    '%C%.%#'
  }, ',')

  vim.bo.errorformat = pattern

  vim.cmd.make(target)

  vim.bo.makeprg     = old_makeprg
  vim.bo.errorformat = old_pattern

  return true
end

vim.api.nvim_create_user_command(
  'Nagelfar',
  function(args) M.nagelfar(args.args) end,
  {nargs = 1}
)
