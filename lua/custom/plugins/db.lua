-- https://github.com/tpope/vim-dadbod
return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
    },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBEnv' },
  },
}
