local M = {}

M.man = function(word)
  local ui     = vim.api.nvim_list_uis()[1]
  local width  = 72
  local height = 25
  vim.cmd('let $MANWIDTH = ' .. width)
  if pcall(vim.cmd.Man, word) then
    vim.api.nvim_win_set_config(0, {
      relative = 'editor',
      width    = width,
      height   = height,
      col      = (ui.width / 2)  - (width / 2),
      row      = (ui.height / 2) - (height / 2),
      anchor   = 'NW',
      style    = 'minimal',
      border   = 'rounded'
    })
    return true
  end
  print('No man page found')
  return false
end

-- Check Tcl syntax and populate the quickfix list with errors.
M.nagelfar = function(target)
  -- Save pre-existing settings to restore at the end.
  local old_makeprg = vim.bo.makeprg     or vim.o.makeprg
  local old_pattern = vim.bo.errorformat or vim.o.errorformat

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
  require('lint').linters_by_ft = {
    tcl = {'nagelfar',}
  }

  vim.api.nvim_create_autocmd(
    {'BufEnter', 'BufWritePost'},
    {callback = function() require('lint').try_lint() end}
  )

  vim.keymap.set({'n'}, 'K', function() M.man(vim.fn.expand('<cword>')) end)

  vim.api.nvim_create_user_command(
    'Nagelfar',
    function(args) M.nagelfar(args.args) end,
    {nargs = 1}
  )

  return true
end

return M
