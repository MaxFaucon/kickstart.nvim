local plugins = {
  -- Agents management
  -- https://github.com/folke/sidekick.nvim
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
          require('sidekick.cli').prompt()
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
  -- Copilot completion
  -- https://github.com/zbirenbaum/copilot.lua
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
  -- Local completion plugin
  -- https://github.com/milanglacier/minuet-ai.nvim
  {
    'milanglacier/minuet-ai.nvim',
    enabled = false,
    config = function()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        -- notify = 'debug',
        -- debounce = 0,
        virtualtext = {
          auto_trigger_ft = { '*' },
          keymap = {
            -- accept whole completion
            accept = '<C-v>',
            -- accept one line
            accept_line = '<A-a>',
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<A-[>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },

        n_completions = 1, -- recommend for local model for resource saving
        context_window = 256,
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as a good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        request_timeout = 15,

        provider_options = {
          openai_fim_compatible = {
            -- For Windows users, TERM may not be present in environment variables.
            -- Consider using APPDATA instead.
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            model = 'qwen2.5-coder:1.5b-base',
            optional = {
              max_tokens = 56,
              top_p = 0.9,
            },
          },
        },
      }
    end,
  },
}

return plugins
