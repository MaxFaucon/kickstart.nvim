-- https://github.com/tpope/vim-dadbod
-- https://github.com/kristijanhusak/vim-dadbod-ui
return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'MaxFaucon/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
    },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBEnv' },
  },
  -- {
  --   dir = '~/Documents/projects/nvim-plugins/neosql.nvim',
  --   dev = true,
  --   config = function()
  --     require('neosql').setup {
  --       -- configuration options
  --     }
  --   end,
  -- },
}
