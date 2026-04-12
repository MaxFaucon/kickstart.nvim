vim.pack.add {
  -- Plugin to improve viewing Markdown files in Neovim
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {
  file_types = { 'markdown', 'codecompanion' },
}
