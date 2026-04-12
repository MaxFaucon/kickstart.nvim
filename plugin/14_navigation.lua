vim.pack.add {
  -- Neovim plugin for a code outline window
  'https://github.com/stevearc/aerial.nvim',
}

require('aerial').setup {}

-- [[ KEYMAPS ]]
local map = vim.keymap.set
local unmap = vim.keymap.del

-- Aerial
map('n', '<leader>sa', '<cmd>Telescope aerial<CR>', { desc = '[S]how [A]erial', silent = true })
map('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = '[T]oggle [A]erial', silent = true })
unmap('n', '[a') -- Unset default keymap to avoid conflict
unmap('n', ']a') -- Unset default keymap to avoid conflict
map('n', '[a', '<cmd>AerialPrev<CR>', { desc = 'Go to previous symbol in Aerial', silent = true })
map('n', ']a', '<cmd>AerialNext<CR>', { desc = 'Go to next symbol in Aerial', silent = true })
