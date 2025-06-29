-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('i', '<C-$>', 'copilot#Accept("<CR>")', { expr = true, silent = true })
  end,
}
