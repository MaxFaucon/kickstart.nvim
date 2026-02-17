-- [[ Core Keymaps ]]
local map_set = vim.keymap.set
local map_del = vim.keymap.del

-- [[ General ]]
-- Lua file execution helpers
map_set('n', '<space><space>x', '<cmd>source %<CR>')
-- map_set('n', '<space>x', ':.lua<CR>')
-- map_set('v', '<space>x', ':lua<CR>')

-- Navigation
map_set({ 'i', 'n' }, '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map_set({ 'i', 'n' }, '<C-j>', '<C-w>j', { desc = 'Go to bottom window' })
map_set({ 'i', 'n' }, '<C-k>', '<C-w>k', { desc = 'Go to top window' })
map_set({ 'i', 'n' }, '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Insert mode key mapping
map_del('i', '<C-s>') -- Remove default <C-s> mapping in insert mode
map_set('i', '<C-h>', '<C-o>h', { desc = 'Move left in insert mode' })
map_set('i', '<C-l>', '<C-o>a', { desc = 'Move right in insert mode' })
map_set('i', '<C-b>', '<C-o>b', { desc = 'Move to the previous word in insert mode' })
map_set('i', '<C-w>', '<C-o>w', { desc = 'Move to the next word in insert mode' })
map_set('i', '<C-j>', '<C-o>db', { desc = 'Delete previous word' })
map_set('i', '<C-k>', '<C-o>de', { desc = 'Delete next word' })

-- Clear highlights on search when pressing <Esc> in normal mode
map_set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffer keymaps
map_set('n', '<leader>br', '<cmd>edit!<CR>', { desc = 'Refresh current file' })
map_set('n', '<leader>bac', '<cmd>%bd<CR>', { desc = 'Close all buffers', silent = true })
-- Copy absolute path of current file to clipboard
map_set('n', '<leader>bp', '<cmd>let @+ = expand("%:p")<CR>', { desc = 'Copy absolute path of current file to clipboard' })
map_set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })
map_set('n', '<leader>so', '<cmd>b#<CR>', { desc = 'Switch to previous buffer', silent = true })

-- Avoid c, d and x to set text in the default register (clipboard)
-- map_set({ 'n', 'v' }, 'd', '"_d')
map_set({ 'n', 'v' }, 'c', '"_c')
map_set({ 'n', 'v' }, 'x', '"_x')
map_set({ 'n', 'v' }, 'C', '"_C')
-- map_set({ 'n', 'v' }, 'D', '"_D')
map_set({ 'n', 'v' }, 'X', '"_X')

-- Quickfix
map_set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map_set('n', '<leader>qs', ':vimgrep /<C-r>//g %<CR>:copen<CR>', { desc = 'Search to quickfix' })
map_set('n', '<M-j>', '<cmd>cnext<CR>', { desc = 'Go to next diagnostic [Q]uickfix' })
map_set('n', '<M-k>', '<cmd>cprev<CR>', { desc = 'Go to previous diagnostic [Q]uickfix' })
map_set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open [Q]uickfix list' })
map_set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close [Q]uickfix list' })

-- [[ Code ]]
-- Search
map_set('n', '<leader>se', '<cmd>e .env<CR>', { desc = 'Open .env file' })

-- Laravel
map_set('n', '<leader>ll', function()
  local log_path = vim.fn.getcwd() .. '/storage/logs/laravel.log'
  if vim.fn.filereadable(log_path) == 1 then
    vim.cmd('edit ' .. log_path)
  else
    vim.notify('Laravel log file not found', vim.log.levels.WARN)
  end
end, { desc = 'Laravel: Open Log File' })

-- [[ Small script keymaps ]]
-- Change case (camel to snake or the opposite)
map_set('n', '<leader>tc', function()
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
