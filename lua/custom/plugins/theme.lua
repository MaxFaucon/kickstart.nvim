-- https://github.com/catppuccin/nvim
return {
  {
    'catppuccin/nvim',
    enabled = true,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      transparent_background = true, -- disables setting the background color.
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      default_integrations = true,
      integrations = {
        bufferline = true,
        gitsigns = true,
        neotree = true,
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },

    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
}
