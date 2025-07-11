-- https://github.com/folke/noice.nvim
-- Description: A feature-rich notification and command-line UI for Neovim, enhancing
-- the user experience with a more interactive and visually appealing interface.
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
}
