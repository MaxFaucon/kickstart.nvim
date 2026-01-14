-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  Remap normal mode to jj instead of <Esc>
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
-- Lua file execution helpers
vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Avoid c, d and x to set text in the default register (clipboard)
-- vim.keymap.set({ 'n', 'v' }, 'd', '"_d')
vim.keymap.set({ 'n', 'v' }, 'c', '"_c')
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
vim.keymap.set({ 'n', 'v' }, 'C', '"_C')
-- vim.keymap.set({ 'n', 'v' }, 'D', '"_D')
vim.keymap.set({ 'n', 'v' }, 'X', '"_X')

-- Toggle focus between floating windows and main windows (ex: K preview, debugger var eveluation, etc.)
vim.keymap.set('n', '<CR>', function()
  local current_win = vim.api.nvim_get_current_win()
  local current_config = vim.api.nvim_win_get_config(current_win)

  if current_config.relative ~= '' then
    vim.cmd 'wincmd p' -- Jump to previous window
    return
  end

  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { desc = 'Toggle floating Windows focus' })

-- Insert mode key mapping
vim.keymap.del('i', '<C-s>') -- Remove default <C-s> mapping in insert mode
vim.keymap.set('i', '<C-h>', '<C-o>h', { desc = 'Move left in insert mode' })
vim.keymap.set('i', '<C-l>', '<C-o>a', { desc = 'Move right in insert mode' })
vim.keymap.set('i', '<C-b>', '<C-o>b', { desc = 'Move to the previous word in insert mode' })
vim.keymap.set('i', '<C-w>', '<C-o>w', { desc = 'Move to the next word in insert mode' })
vim.keymap.set('i', '<C-j>', '<C-o>db', { desc = 'Delete previous word' })
vim.keymap.set('i', '<C-k>', '<C-o>de', { desc = 'Delete next word' })

-- Buffer keymaps
vim.keymap.set('n', '<leader>br', '<cmd>edit!<CR>', { desc = 'Refresh current file' })
vim.keymap.set('n', '<leader>bac', '<cmd>%bd<CR>', { desc = 'Close all buffers', silent = true })
-- Copy absolute path of current file to clipboard
vim.keymap.set('n', '<leader>bp', '<cmd>let @+ = expand("%:p")<CR>', { desc = 'Copy absolute path of current file to clipboard' })

-- Notification keymaps
vim.keymap.set('n', '<leader>ns', '<cmd>Noice telescope<CR>', { desc = '[N]otification [S]how' })
vim.keymap.set('n', '<leader>nd', '<cmd>Noice dismiss<CR>', { desc = '[N]otification [D]ismiss' })

-- Aerial
vim.keymap.set('n', '<leader>sa', '<cmd>Telescope aerial<CR>', { desc = '[S]how [A]erial', silent = true })
vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = '[T]oggle [A]erial', silent = true })
vim.keymap.del('n', '[a') -- Unset default keymap to avoid conflict
vim.keymap.del('n', ']a') -- Unset default keymap to avoid conflict
vim.keymap.set('n', '[a', '<cmd>AerialPrev<CR>', { desc = 'Go to previous symbol in Aerial', silent = true })
vim.keymap.set('n', ']a', '<cmd>AerialNext<CR>', { desc = 'Go to next symbol in Aerial', silent = true })

-- Bufferline keymaps
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer tab', silent = true })
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer', silent = true })
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle to previous buffer', silent = true })
vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })
vim.keymap.set('n', '<leader>so', '<cmd>b#<CR>', { desc = 'Switch to previous buffer', silent = true })

-- Zen mode
vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<CR>', { desc = 'Toggle Zen mode', silent = true })

-- Toggle terminal
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTermToggleAll<CR>', { desc = 'Toggle all terminals', silent = true })
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle floating terminal', silent = true })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal size=30<CR>', { desc = 'Toggle horizontal terminal', silent = true })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=100<CR>', { desc = 'Toggle horizontal terminal', silent = true })

-- Quickfix
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qs', ':vimgrep /<C-r>//g %<CR>:copen<CR>', { desc = 'Search to quickfix' })
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>', { desc = 'Go to next diagnostic [Q]uickfix' })
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>', { desc = 'Go to previous diagnostic [Q]uickfix' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open [Q]uickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close [Q]uickfix list' })

-- Oil
vim.keymap.set('n', '<leader>o', '<cmd>Oil<CR>', { desc = 'Open Oil', silent = true })

-- Persistence
vim.keymap.set('n', '<leader>ps', function()
  require('persistence').load()
end, { desc = 'Load session for current dir' })
vim.keymap.set('n', '<leader>pS', function()
  require('persistence').select()
end, { desc = 'Select session to load' })
vim.keymap.set('n', '<leader>pl', function()
  require('persistence').load { last = true }
end, { desc = 'Load last session' })
-- stop Persistence => session won't be saved on exit
vim.keymap.set('n', '<leader>pd', function()
  require('persistence').stop()
end, { desc = 'Stop persistence' })

-- Git
-- Neogit - Core operations
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit status' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<cr>', { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<cr>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gP', '<cmd>Neogit pull<cr>', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gB', '<cmd>Neogit branch<cr>', { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gl', '<cmd>Neogit log<cr>', { desc = 'Git log' })

-- Diffview - Visualization & comparison
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diff working tree' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewOpen HEAD~1<cr>', { desc = 'Diff last commit' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history (current)' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history (all)' })
vim.keymap.set('n', '<leader>gm', '<cmd>DiffviewOpen origin/main...HEAD<cr>', { desc = 'Diff with main' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' })

-- Git conflict resolution
vim.keymap.set('n', '<leader>gx', '<cmd>DiffviewOpen<cr>', { desc = 'Resolve conflicts' })

-- Code diff
vim.keymap.set('n', '<leader>gv', '<cmd>CodeDiff<cr>', { desc = 'Open CodeDiff' })

-- Calcium (math)
vim.keymap.set('n', '<leader>mc', '<cmd>Calcium<cr>', { desc = 'Calculate' })

-- Env
vim.keymap.set('n', '<leader>se', '<cmd>e .env<CR>', { desc = 'Open .env file' })

-- Laravel
vim.keymap.set('n', '<leader>ll', function()
  local log_path = vim.fn.getcwd() .. '/storage/logs/laravel.log'
  if vim.fn.filereadable(log_path) == 1 then
    vim.cmd('edit ' .. log_path)
  else
    vim.notify('Laravel log file not found', vim.log.levels.WARN)
  end
end, { desc = 'Laravel: Open Log File' })

-- Neotest keymaps
vim.keymap.set('n', '<leader>nr', '<cmd>lua require("neotest").run.run()<CR>', { desc = 'Run Nearest Test' })
vim.keymap.set('n', '<leader>nf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = 'Run File Tests' })
vim.keymap.set('n', '<leader>nq', '<cmd>lua require("neotest").run.stop()<CR>', { desc = 'Stop Test' })
vim.keymap.set('n', '<leader>np', '<cmd>lua require("neotest").summary.toggle()<CR>', { desc = 'Toggle Test Summary' })
vim.keymap.set('n', '<leader>no', '<cmd>lua require("neotest").output.open()<CR>', { desc = 'Open Test Output' })
vim.keymap.set('n', '<leader>nl', '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', { desc = 'Run Nearest Test with DAP' })
vim.keymap.set('n', '<leader>na', '<cmd>lua require("neotest").run.attach()<CR>', { desc = 'Attach to Running Test' })

-- Tmux: Switch to last tmux window
vim.keymap.set('n', '<leader>tl', function()
  vim.fn.system 'tmux last-window'
end, { desc = 'Switch to last tmux window' })

-- Zk notes
vim.keymap.set('n', '<leader>zd', "<cmd>ZkNew { dir = 'journal/daily' }<CR>", { desc = 'Create a daily note' })
vim.keymap.set('n', '<leader>zf', "<cmd>ZkNotes { hrefs = { 'learning/' }, sort = { 'modified' } }<CR>", { desc = 'Search notes' })

vim.keymap.set('n', '<leader>zt', function()
  local tags_input = vim.fn.input 'Tags (comma-separated): '
  if tags_input == '' then
    return
  end

  -- Split by comma and trim whitespace
  local tags = {}
  for tag in tags_input:gmatch '([^,]+)' do
    table.insert(tags, vim.trim(tag))
  end

  require('zk.commands').get 'ZkNotes' { hrefs = { 'learning/' }, tags = tags, sort = { 'modified' } }
end, { noremap = true, silent = false, desc = 'Search notes by tags' })

vim.keymap.set('n', '<leader>zn', function()
  require('zk.commands').get 'ZkNew' {
    dir = 'learning',
    title = vim.fn.input 'Title: ',
    extra = {
      tags = vim.fn.input 'Tags (comma-separated): ',
      source = vim.fn.input 'Source: ',
      source_type = vim.fn.input 'Source type (book/article/personal/etc): ',
    },
  }
end, { desc = 'Create a new note' })

vim.keymap.set('n', '<leader>zl', '<cmd>ZkInsertLink<CR>', { desc = 'Link a note' })

-- Miscellaneous
-- Open .env
vim.keymap.set('n', '<leader>me', '<cmd>e .env<CR>', { desc = 'Open .env file' })

-- Change case (camel to snake or the opposite)
vim.keymap.set('n', '<leader>tc', function()
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
