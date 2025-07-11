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

-- Insert mode key mapping
vim.keymap.set('i', '<C-h>', '<C-o>h', { desc = 'Move left in insert mode' })
vim.keymap.set('i', '<C-l>', '<C-o>a', { desc = 'Move right in insert mode' })
vim.keymap.set('i', '<C-b>', '<C-o>b', { desc = 'Move to the previous word in insert mode' })
vim.keymap.set('i', '<C-w>', '<C-o>w', { desc = 'Move to the next word in insert mode' })
vim.keymap.set('i', '<C-j>', '<C-o>db', { desc = 'Move down in insert mode' })
-- vim.keymap.set('i', '<C-k>', '<C-o>de', { desc = 'Move up in insert mode' }) -- Not working because mapped on show definition

-- Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap('i', '<C-v>', 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })

-- Bufferline keymaps
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer tab', silent = true })
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer', silent = true })
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle to previous buffer', silent = true })
vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })

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

-- Code rain
vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')
