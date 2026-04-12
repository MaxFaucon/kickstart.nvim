vim.pack.add {
  -- A neovim lua plugin to help easily manage multiple terminal windows
  'https://github.com/akinsho/toggleterm.nvim',
}

require('toggleterm').setup {}

-- [[ KEYMAPS [d] ]]
local map = vim.keymap.set

-- Toggle terminal
map('n', '<leader>tt', '<cmd>ToggleTermToggleAll<CR>', { desc = 'Toggle all terminals', silent = true })
map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle floating terminal', silent = true })
map('n', '<leader>ts', '<cmd>ToggleTerm direction=horizontal size=30<CR>', { desc = 'Toggle horizontal terminal', silent = true })
map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical size=100<CR>', { desc = 'Toggle horizontal terminal', silent = true })
