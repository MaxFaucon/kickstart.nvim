local plugins = {
  -- Flash navigation
  -- https://github.com/folke/flash.nvim
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<c-s>", mode = { "i" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
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
  -- Tmux/Neovim navigation
  -- https://github.com/christoomey/vim-tmux-navigator
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
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
