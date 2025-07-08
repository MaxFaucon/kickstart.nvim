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

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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

-- Bufferline keymaps
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLinePick<CR>', { desc = 'Pick a buffer tab', silent = true })
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle to next buffer', silent = true })
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle to previous buffer', silent = true })
vim.keymap.set('n', '<leader>bc', '<cmd>bdelete<CR>', { desc = 'Close a buffer tab', silent = true })

-- Code rain
vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>')
