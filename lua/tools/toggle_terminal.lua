-- Helper functions

local floating_window_helper = require 'helpers.create_floating_window'

local close_terminal_window = function(buf_id, terminal_type)
  local win_id = vim.fn.bufwinid(buf_id)

  if win_id ~= -1 then
    if terminal_type == 'default' then
      vim.api.nvim_win_call(win_id, function()
        vim.cmd(vim.fn.bufnr("#") > 0 and "buffer #" or "enew")
      end)
    else
      vim.api.nvim_win_close(win_id, true)
    end
  end
end

local setup_terminal_config = function(buf_id, terminal_type)
  local map = vim.keymap.set
  local opts = { buffer = buf_id }

  map('t', '<esc><esc>', [[<C-\><C-n>]], opts)
  map('t', '<C-t>', function()
    close_terminal_window(buf_id, terminal_type)
  end, opts)
  map('n', 'q', function()
    close_terminal_window(buf_id, terminal_type)
  end, opts)
  map('t', '<C-h>', function()
    close_terminal_window(buf_id, terminal_type)
  end, opts)
  map('t', '<C-j>', function()
    close_terminal_window(buf_id, terminal_type)
  end, opts)
  map('t', '<C-k>', function()
    close_terminal_window(buf_id, terminal_type)
  end, opts)

  vim.bo[buf_id].buflisted = false
end

local toggle_tab_terminal = function(buf_id)
  local tab = vim.api.nvim_open_tabpage(buf_id, true, {})
  local tab_win = vim.api.nvim_tabpage_get_win(tab)

  return tab_win
end

local toggle_floating_terminal = function(buf_id)
  return floating_window_helper.create_floating_window({ buf = buf_id, bufName = 'floating-terminal', use_default_size = true })
      .win
end

---@alias SplitDirection "above" | "below" | "left" | "right"
---@param buf_id integer The buffer id
---@param direction SplitDirection The direction for the split window
local toggle_split_terminal = function(buf_id, direction)
  return vim.api.nvim_open_win(buf_id, true, {
    split = direction,
    win = 0,
  })
end

-- Main functions

local M = {}

---@alias TerminalType "float" | "split" | "tab" | "default"
---@param terminal_type TerminalType The type of terminal to toggle
---@param split_direction? SplitDirection The direction for the split terminal
---@param buffer_name? string The name of the terminal buffer
M.toggle_terminal = function(terminal_type, split_direction, buffer_name)
  local existing_buffers = vim.fn.getbufinfo()
  local terminal_buf = nil
  local new_terminal = false

  if buffer_name == nil then
    buffer_name = 'scratch'
  end

  for i = 1, #existing_buffers, 1 do
    local existing_buffer = existing_buffers[i].bufnr
    local buf_type = vim.bo[existing_buffer].buftype

    if buf_type == 'terminal' then
      terminal_buf = existing_buffer
      break
    end
  end

  if terminal_buf == nil then
    terminal_buf = vim.api.nvim_create_buf(true, false)
    -- vim.api.nvim_buf_set_name(terminal_buf, buffer_name)
    new_terminal = true
  end

  local terminal_win = nil
  if terminal_type == 'default' then
    terminal_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_win, terminal_buf)
  elseif terminal_type == 'tab' then
    terminal_win = toggle_tab_terminal(terminal_buf)
  elseif terminal_type == 'float' then
    terminal_win = toggle_floating_terminal(terminal_buf)
  elseif terminal_type == 'split' then
    if split_direction == nil then
      vim.notify('Split terminal requires a direction', vim.log.levels.ERROR)
      return
    end

    terminal_win = toggle_split_terminal(terminal_buf, split_direction)
  end

  if new_terminal then
    vim.cmd.terminal()
    setup_terminal_config(terminal_buf, terminal_type)
  end

  vim.wo[terminal_win].relativenumber = true
end

return M
