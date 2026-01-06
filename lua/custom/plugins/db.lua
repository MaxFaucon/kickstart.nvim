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
}
