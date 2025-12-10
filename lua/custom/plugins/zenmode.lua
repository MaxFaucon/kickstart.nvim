-- https://github.com/folke/zen-mode.nvim
return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      width = 1,
    },
    plugins = {
      tmux = { enabled = false },
      wezterm = { enabled = false },
    },
  },
}
