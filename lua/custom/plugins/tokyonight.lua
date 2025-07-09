return {
  {
    'folke/tokyonight.nvim',
    enabled = false,
    priority = 1000,
    opts = {},
    integrations = {
      -- 						The theme offers four styles: |tokyonight.nvim-storm|, |tokyonight.nvim-moon|,
      -- |tokyonight.nvim-night|, and |tokyonight.nvim-day|.

      bufferline = true,
      gitsigns = true,
      neotree = true,
      nvimtree = true,
      treesitter = true,
      telescope = {
        enabled = true,
      },
      which_key = true,
    },

    config = function()
      vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },
}
