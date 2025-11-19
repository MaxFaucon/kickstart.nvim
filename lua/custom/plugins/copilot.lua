-- https://github.com/zbirenbaum/copilot.lua
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = true,
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<C-v>',
      },
    },
  },
}
