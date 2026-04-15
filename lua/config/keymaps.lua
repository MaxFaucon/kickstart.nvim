local session_management = require 'tools.session_management'
local mode_management = require 'tools.mode_management'

-- [[ User Commands ]]
vim.api.nvim_create_user_command('Path', function()
  local relative_path = vim.fn.expand '%:~:.'
  if relative_path == '' then
    vim.notify('No file associated with the current buffer', vim.log.levels.WARN)
  else
    vim.notify(relative_path, vim.log.levels.INFO)
  end
end, { desc = 'Shows the relative path of the current file' })

-- [[ Keymaps ]]
local map = vim.keymap.set

-- General
-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Avoid c, d and x to set text in the default register (clipboard)
map({ 'n', 'v' }, 'c', '"_c')
map({ 'n', 'v' }, 'x', '"_x')
map({ 'n', 'v' }, 'C', '"_C')
map({ 'n', 'v' }, 'X', '"_X')

-- Navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to bottom window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to top window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })
map('i', '<C-w>', '<C-o><C-w>W', { desc = 'Focus window above' })

-- Window [w]
map('n', '<leader>wz', function()
  local cursor_position = vim.api.nvim_win_get_cursor(0)

  if vim.t.zen then
    vim.cmd 'tabclose'
    vim.api.nvim_win_set_cursor(0, cursor_position)
  else
    vim.cmd 'tabnew %'
    vim.api.nvim_win_set_cursor(0, cursor_position)
    vim.t.zen = true
  end
end, { desc = '[W]indow zoom' })
map('n', '<leader>wr', function()
  local keymaps = mode_management.resize_window_keymaps
  mode_management.toggle_mode(keymaps, 'Window Resize')
end, { desc = 'Resize window' })

-- Buffer [b]
map('n', '<leader>br', '<cmd>edit!<CR>', { desc = 'Reload current file' })
map('n', '<leader>bac', '<cmd>%bd<CR>', { desc = 'Close all buffers', silent = true })
-- Copy absolute path of current file to clipboard
map('n', '<leader>bp', '<cmd>let @+ = expand("%:p")<CR>', { desc = 'Copy absolute path of current file to clipboard' })
map('n', '<leader>bf', '<cmd>let @+ = expand("%:p:t")<CR>', { desc = 'Copy file name to clipboard' })
map('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })
map('n', '<leader>bs', '<cmd>b#<CR>', { desc = 'Switch to previous buffer', silent = true })

-- Quickfix [q] and Toggle [t]
map('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>qs', ':vimgrep /<C-r>//g %<CR>:copen<CR>', { desc = 'Search to quickfix' })
map('n', '<leader>tq', function()
  local quickfix_window_id = vim.fn.getqflist({ winid = 0 })['winid']

  return quickfix_window_id ~= 0 and vim.cmd 'cclose' or vim.cmd 'copen'
end, { desc = '[T]oggle quickfix list' })

map('n', '<leader>tl', function()
  vim.cmd 'Todolist'
end, { desc = 'Open todo list' })

map('n', '<leader>td', function()
  vim.cmd 'Draft'
end, { desc = 'Open draft note' })

-- Code [c]
map('n', '<leader>ce', '<cmd>e .env<CR>', { desc = 'Open .env file' })

-- Personal [p]
-- Change case (camel to snake or the opposite)
map('n', '<leader>pc', function()
  local current_word = vim.fn.expand '<cword>'
  local is_snake_case = string.match(current_word, '^[a-z][a-z0-9_]*$') ~= nil
  local transformed_word = ''

  if is_snake_case then
    -- transformed_word = current_word:gsub('[_]',
    transformed_word = current_word:gsub('_(%w)', function(c)
      return c:upper()
    end)
  else
    transformed_word = current_word:gsub('(%u)', '_%1'):gsub('^_', ''):lower()
  end

  vim.api.nvim_command('normal! ciw' .. transformed_word .. '\x1b')
end, { desc = 'Change word case' })

-- Sessions
map('n', '<leader>ps', session_management.save_current_project, { desc = 'Save session for current project' })
map('n', '<leader>pp', session_management.sessions_picker, { desc = 'Select and load a session' })
map('n', '<leader>pl', session_management.switch_last_project, { desc = 'Load the last session' })
map('n', '<leader>pr', function()
  session_management.save_current_project()
  vim.cmd 'restart'
end, { desc = 'Reload the current project' })

-- Treesitter text objects
map('n', '<CR>', function()
  require('vim.treesitter._select').select_parent(vim.v.count1)
end, { desc = 'Init treesitter selection' })

map('x', '<CR>', function()
  require('vim.treesitter._select').select_parent(vim.v.count1)
end, { desc = 'Expand treesitter selection' })

map('x', '<BS>', function()
  require('vim.treesitter._select').select_child(vim.v.count1)
end, { desc = 'Shrink treesitter selection' })

map('n', ']n', function()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify('No treesitter node found', vim.log.levels.WARN)
    return
  end

  local current = node
  while current do
    local next_sibling = current:next_sibling()
    if next_sibling then
      local next_sibling_row, next_sibling_col = next_sibling:range()

      vim.api.nvim_win_set_cursor(0, { next_sibling_row + 1, next_sibling_col })
      return
    end
    current = current:parent()
  end
end)

map('n', '[n', function()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify('No treesitter node found', vim.log.levels.WARN)
    return
  end

  local current = node
  while current do
    local prev_sibling = current:prev_sibling()
    if prev_sibling then
      local prev_sibling_row, prev_sibling_col = prev_sibling:range()

      vim.api.nvim_win_set_cursor(0, { prev_sibling_row + 1, prev_sibling_col })
      return
    end
    current = current:parent()
  end
end)

map('n', ']p', function()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end

  local start_row, start_col = node:range()
  local current = node:parent()
  while current do
    local row, col = current:range()
    if row ~= start_row or col ~= start_col then
      vim.api.nvim_win_set_cursor(0, { row + 1, col })
      return
    end
    current = current:parent()
  end
end)
