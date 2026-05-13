vim.pack.add {
  -- Faster LuaLS setup for Neovim
  'https://github.com/folke/lazydev.nvim',
  -- Find, Filter, Preview, Pick.
  'https://github.com/nvim-telescope/telescope.nvim',
  -- Helper functions for Neovim
  'https://github.com/nvim-lua/plenary.nvim',
  -- An implementation of the Popup API from vim in Neovim
  'https://github.com/nvim-lua/popup.nvim',
  -- Replaces Neovim's built-in vim.ui.select
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  -- UI Component Library for Neovim
  'https://github.com/MunifTanjim/nui.nvim',
  -- Provides Nerd Font icons (glyphs) for use by neovim plugins
  'https://github.com/nvim-tree/nvim-web-devicons',
  -- A task runner and job management plugin for Neovim
  'https://github.com/stevearc/overseer.nvim',
  -- API for interacting with Github Copilot
  'https://github.com/zbirenbaum/copilot.lua',
}

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
