local plugins = {
  -- Agents management
  {
    'olimorris/codecompanion.nvim',
    version = '^18.0.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionCmd',
      'CodeCompanionActions',
    },
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = 'copilot',
            -- Best quality model available through your Copilot subscription.
            -- You can switch models on the fly in the chat buffer with `ga`.
            -- Other good options: "claude-sonnet-4", "gpt-4.1", "gemini-2.5-pro"
            model = 'claude-sonnet-4',
          },
        },
        inline = {
          adapter = {
            name = 'copilot',
            -- Sonnet is a good balance of speed/quality for inline.
            -- If you find it slow, try "gpt-4.1" which streams faster.
            model = 'claude-sonnet-4',
          },
        },
        cmd = {
          adapter = {
            name = 'copilot',
            model = 'claude-sonnet-4',
          },
        },
      },

      display = {
        action_palette = {
          provider = 'telescope',
          width = 95,
          height = 15,
        },
        chat = {
          -- Render markdown nicely in chat buffer (uses your render-markdown.nvim)
          render_headers = false,
          -- Start in insert mode when opening chat
          start_in_insert_mode = true,
          window = {
            layout = 'vertical',
            width = 0.4,
            height = 0.8,
            border = 'rounded',
          },
          separator = '─',
          show_settings = true,
        },
      },

      opts = {
        -- Set to "DEBUG" or "TRACE" when troubleshooting
        log_level = 'ERROR',
        -- Send code context with inline requests for better results
        send_code = true,
      },

      system_prompt = [[
				You are a senior software engineer and code reviewer. Be concise and focus on practical solutions. Always consider:
				- Code readability and maintainability
			  - Performance implications
				- Security best practices
				- Language-specific idioms

				Prefer showing working code examples over lengthy explanations.
			]],

      slash_commands = {
        ['buffer'] = {
          callback = 'strategies.chat.slash_commands.buffer',
          description = 'Insert open buffers',
          opts = {
            contains_code = true,
            provider = 'telescope',
          },
        },
        ['commit'] = {
          callback = function()
            return 'Generate a conventional commit message for the staged changes'
          end,
          description = 'Generate commit message',
        },
        ['test'] = {
          callback = function()
            return 'Generate comprehensive unit tests for the selected code'
          end,
          description = 'Generate tests',
        },
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

-- Keymaps --
local set = vim.keymap.set
-- CodeCompanion
set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'AI: Toggle chat' })
-- Inline assistant (works on visual selection too)
set({ 'n', 'v' }, '<leader>ai', '<cmd>CodeCompanion<cr>', { desc = 'AI: Inline assistant' })
-- Action palette (all available actions/prompts)
set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = 'AI: Actions' })
-- Add visual selection to current chat
set('v', '<leader>av', '<cmd>CodeCompanionChat Add<cr>', { desc = 'AI: Add to chat' })
-- Quick prompts from the built-in prompt library
set('v', '<leader>ae', '<cmd>CodeCompanion /explain<cr>', { desc = 'AI: Explain selection' })
set('v', '<leader>af', '<cmd>CodeCompanion /fix<cr>', { desc = 'AI: Fix selection' })
set('v', '<leader>ar', '<cmd>CodeCompanion /refactor<cr>', { desc = 'AI: Refactor selection' })
-- Additional workflow keybindings
set('v', '<leader>at', '<cmd>CodeCompanion /test<cr>', { desc = 'AI: Generate tests' })
set('v', '<leader>ad', '<cmd>CodeCompanion Generate documentation for this code<cr>', { desc = 'AI: Document code' })
set('v', '<leader>aw', '<cmd>CodeCompanion Review this code for potential issues<cr>', { desc = 'AI: Review code' })
-- Command mode (generate Neovim commands from natural language)
set('n', '<leader>a:', '<cmd>CodeCompanionCmd<cr>', { desc = 'AI: Generate command' })
vim.cmd [[cab cc CodeCompanion]]

return plugins
