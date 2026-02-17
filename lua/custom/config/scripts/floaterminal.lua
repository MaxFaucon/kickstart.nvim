M = require 'custom.config.scripts.create_floating_window'

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = M.create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Create a floating window with default dimensions
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
