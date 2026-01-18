local plugins = {
  -- File explorer in buffer
  -- https://github.com/stevearc/oil.nvim
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        -- Mappings can be a function
        ['gd'] = function()
          require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
        end,
        ['q'] = { 'actions.close', mode = 'n' },
      },
    },
    -- Optional dependencies
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}

-- Keymaps
local map = vim.keymap.set
-- Oil
map('n', '<leader>o', '<cmd>Oil<CR>', { desc = 'Open Oil', silent = true })

return plugins
