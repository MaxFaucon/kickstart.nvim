-- https://github.com/folke/zen-mode.nvim
return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      width = 180,
    },
    plugins = {
      tmux = { enabled = true },
      wezterm = { enabled = false },
    },
  },
}
