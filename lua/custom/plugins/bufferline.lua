-- plugins/bufferline.lua
return {
  {
    'akinsho/bufferline.nvim',
    enabled = true,
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- separator_style = 'thick',
      -- -- mode = 'buffers',
      -- offset = {
      --   filetype = 'neo-tree',
      --
      --   highlight = 'Directory',
      --   text_align = 'center',
      --   separator = true,
      -- },
    },
  },
}
