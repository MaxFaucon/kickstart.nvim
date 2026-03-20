local plugins = {
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

return plugins
