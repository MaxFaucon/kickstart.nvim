-- https://github.com/axkirillov/hbac.nvim
return {
  {
    'axkirillov/hbac.nvim',
    enabled = false, -- Disabled because issues when manipulating a lot of buffers
    config = true,
    opts = {
      auto_close = true,
      threshold = 7,
    },
  },
}
