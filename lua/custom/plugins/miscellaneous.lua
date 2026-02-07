local plugins = {
  -- Session management
  -- https://github.com/folke/persistence.nvim
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  -- Improve quickfix list
  -- https://github.com/stevearc/quicker.nvim
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  -- Misc mini plugins
  -- https://github.com/echasnovski/mini.nvim
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
    end,
  },
  -- Create submodes for keymaps
  -- https://github.com/pogyomo/submode.nvim
  {
    'pogyomo/submode.nvim',
    lazy = false,
    -- (recommended) specify version to prevent unexpected change.
    version = '6.4.2',
  },
}

-- Keymaps
local map = vim.keymap.set
-- Persistence
map('n', '<leader>ps', function()
  require('persistence').load()
end, { desc = 'Load session for current dir' })
map('n', '<leader>pS', function()
  require('persistence').select()
end, { desc = 'Select session to load' })
map('n', '<leader>pl', function()
  require('persistence').load { last = true }
end, { desc = 'Load last session' })
-- stop Persistence => session won't be saved on exit
map('n', '<leader>pd', function()
  require('persistence').stop()
end, { desc = 'Stop persistence' })

return plugins
