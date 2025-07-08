return {
  {
    'nvim-lualine/lualine.nvim',
    enabled = true,
    opts = {
      theme = 'catppuccin',
      section_separators = '',
      component_separators = '',
      icons_enabled = true,
    },
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress ' },
      lualine_z = { 'location' },
    },
  },
}
