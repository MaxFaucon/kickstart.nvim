-- https://github.com/zbirenbaum/copilot.lua
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = false,
          },
        },
      }

      vim.keymap.set('i', '<C-v>', function()
        if require('copilot.suggestion').is_visible() then
          require('copilot.suggestion').accept()
        end
      end)
    end,
  },
}
