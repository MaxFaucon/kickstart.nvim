local plugins = {
  -- Methods/functions navigation
  -- https://github.com/stevearc/aerial.nvim
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  -- Force more efficient navigation
  -- https://github.com/m4xshen/hardtime.nvim
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
}

-- Keymaps
local map_set = vim.keymap.set
local map_del = vim.keymap.del
-- Aerial
map_set('n', '<leader>sa', '<cmd>Telescope aerial<CR>', { desc = '[S]how [A]erial', silent = true })
map_set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = '[T]oggle [A]erial', silent = true })
map_del('n', '[a') -- Unset default keymap to avoid conflict
map_del('n', ']a') -- Unset default keymap to avoid conflict
map_set('n', '[a', '<cmd>AerialPrev<CR>', { desc = 'Go to previous symbol in Aerial', silent = true })
map_set('n', ']a', '<cmd>AerialNext<CR>', { desc = 'Go to next symbol in Aerial', silent = true })

return plugins
