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

-- Tabs keymaps
-- vim.keymap.set('n', 'H', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
-- vim.keymap.set('n', 'L', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
-- vim.keymap.set('n', 'X', '<cmd>tabclose<CR>', { desc = 'Close current tab' })
-- vim.keymap.set('n', 'T', '<cmd>tabnew<CR>', { desc = 'Open new tab' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
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

-- Insert mode key mapping
vim.keymap.del('i', '<C-s>') -- Remove default <C-s> mapping in insert mode
vim.keymap.set('i', '<C-h>', '<C-o>h', { desc = 'Move left in insert mode' })
vim.keymap.set('i', '<C-l>', '<C-o>a', { desc = 'Move right in insert mode' })
vim.keymap.set('i', '<C-b>', '<C-o>b', { desc = 'Move to the previous word in insert mode' })
vim.keymap.set('i', '<C-w>', '<C-o>w', { desc = 'Move to the next word in insert mode' })
vim.keymap.set('i', '<C-j>', '<C-o>db', { desc = 'Delete previous word' })
vim.keymap.set('i', '<C-k>', '<C-o>de', { desc = 'Delete next word' })

-- Refresh the current file
vim.keymap.set('n', '<leader>r', '<cmd>edit!<CR>', { desc = 'Refresh current file' })

-- Notification keymaps
vim.keymap.set('n', '<leader>ns', '<cmd>Noice telescope<CR>', { desc = '[N]otification [S]how' })
vim.keymap.set('n', '<leader>nd', '<cmd>Noice dismiss<CR>', { desc = '[N]otification [D]ismiss' })

-- Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap('i', '<C-v>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

-- Bufferline keymaps
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer tab', silent = true })
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer', silent = true })
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle to previous buffer', silent = true })
vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })
vim.keymap.set('n', '<leader>so', '<cmd>b#<CR>', { desc = 'Switch to previous buffer', silent = true })

-- Buffer keymaps
vim.keymap.set('n', '<leader>bac', '<cmd>%bd<CR>', { desc = 'Close all buffers', silent = true })

-- Zen mode
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle Zen mode', silent = true })

-- Toggle terminal
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTermToggleAll<CR>', { desc = 'Toggle all terminals', silent = true })
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle floating terminal', silent = true })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal size=30<CR>', { desc = 'Toggle horizontal terminal', silent = true })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=100<CR>', { desc = 'Toggle horizontal terminal', silent = true })

-- Quickfix
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>', { desc = 'Go to next diagnostic [Q]uickfix' })
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>', { desc = 'Go to previous diagnostic [Q]uickfix' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open [Q]uickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close [Q]uickfix list' })

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

-- Copilot
vim.keymap.set('n', '<leader>co', '<cmd>CopilotChatOpen<CR>', { desc = '[C]opilot chat [O]pen' })
vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChatClose<CR>', { desc = '[C]opilot chat [C]lose' })
vim.keymap.set('n', '<leader>cr', '<cmd>CopilotChatReset<CR>', { desc = '[C]opilot chat [R]eset' })
vim.keymap.set('n', '<leader>cs', function()
  local name = vim.fn.input 'Save chat as: '
  if name ~= '' then
    vim.cmd('CopilotChatSave ' .. name)
  end
end, { desc = '[C]opilot chat [S]ave with name' })
vim.keymap.set('n', '<leader>cl', function()
  local name = vim.fn.input 'Load chat: '
  if name ~= '' then
    vim.cmd('CopilotChatLoad ' .. name)
  end
end, { desc = '[C]opilot chat [L]oad by name' })
vim.keymap.set('v', '<leader>ca', function()
  -- Save visual selection range before any input prompts
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  local actions = {
    'e - Explain this code',
    'r - Refactor this code',
    'i - Improve this code',
    'f - Fix this code',
    'v - Review this code',
    'o - Optimize this code',
    'q - Ask custom question about this code',
  }

  print 'Choose action:'
  for _, action in ipairs(actions) do
    print('  ' .. action)
  end

  local choice = vim.fn.input 'Enter choice (e/r/i/f/v/o/q): '
  local action_map = {
    e = 'Explain',
    r = 'Refactor',
    i = 'Improve',
    f = 'Fix',
    v = 'Review',
    o = 'Optimize',
  }

  if action_map[choice] then
    vim.cmd(start_line .. ',' .. end_line .. 'CopilotChat ' .. action_map[choice])
  elseif choice == 'q' then
    local question = vim.fn.input 'Ask question about this code: '
    if question ~= '' then
      vim.cmd(start_line .. ',' .. end_line .. 'CopilotChat ' .. question)
    end
  end
end, { desc = '[C]opilot chat [A]ction on selection' })

-- Code rain
vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')
