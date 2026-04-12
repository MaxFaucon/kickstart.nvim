vim.pack.add {
  -- File explorer in buffer
  'https://github.com/stevearc/oil.nvim',
}

require('oil').setup {
  keymaps = {
    -- Mappings can be a function
    ['gd'] = function()
      require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
    end,
    ['q'] = { 'actions.close', mode = 'n' },
  },
}

-- [[ KEYMAPS [b] ]]
local map = vim.keymap.set
-- Oil
map('n', '<leader>bo', '<cmd>Oil<CR>', { desc = 'Open Oil', silent = true })
