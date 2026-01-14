-- https://github.com/folke/sidekick.nvim
return {
  {
    'folke/sidekick.nvim',
    opts = {
      -- Context configuration
      context = {
        auto_include = { buffer = true, cursor = true, diagnostics = true, selection = true },
      },
      cli = {
        mux = {
          backend = 'tmux',
          enabled = true,
        },
        tools = {
          opencode = {
            keys = { prompt = { '<a-p>', 'prompt' } },
          },
        },
      },
      -- Custom prompts for better context usage
      prompts = {
        explain_selection = 'Explain the selected code:',
        fix_diagnostics = 'Fix the diagnostics in this buffer:',
        optimize_code = 'Optimize this code for better performance:',
        add_tests = 'Write comprehensive tests for this code:',
      },
      nes = {
        enabled = false,
      },
    },
    keys = {
      prompt = { '<a-p>', 'prompt' },
      {
        '<tab>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function()
          require('sidekick.cli').focus()
        end,
        mode = { 'n', 'x', 'i', 't' },
        desc = 'Sidekick Switch Focus',
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle { focus = true }
        end,
        desc = 'Sidekick Toggle CLI',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ac',
        function()
          require('sidekick.cli').toggle { name = 'claude', focus = true }
        end,
        desc = 'Sidekick Claude Toggle',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ag',
        function()
          require('sidekick.cli').toggle { name = 'grok', focus = true }
        end,
        desc = 'Sidekick Grok Toggle',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').select_prompt()
        end,
        desc = 'Sidekick Ask Prompt',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ae',
        function()
          require('sidekick.cli').ask_with_context 'explain_selection'
        end,
        desc = 'Sidekick Explain Selection',
        mode = { 'v' },
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').ask_with_context 'fix_diagnostics'
        end,
        desc = 'Sidekick Fix Diagnostics',
        mode = { 'n' },
      },
      {
        '<leader>ao',
        function()
          require('sidekick.cli').ask_with_context 'optimize_code'
        end,
        desc = 'Sidekick Optimize Code',
        mode = { 'n', 'v' },
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').ask_with_context 'add_tests'
        end,
        desc = 'Sidekick Add Tests',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ai',
        function()
          require('sidekick.cli').include_buffer_context()
        end,
        desc = 'Sidekick Include Buffer Context',
        mode = { 'n', 'v' },
      },
      {
        '<leader>au',
        function()
          require('sidekick.nes').update()
        end,
        desc = 'Sidekick Fresh Edit Suggestions',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ah',
        function()
          require('sidekick.nes').have()
        end,
        desc = 'Sidekick Check If Any Edits Active In Buffer',
        mode = { 'n', 'v' },
      },
    },
  },
}
