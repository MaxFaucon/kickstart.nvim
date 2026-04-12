vim.pack.add {
  -- AI side buffer
  {
    src = 'https://www.github.com/olimorris/codecompanion.nvim',
    version = vim.version.range '^19.0.0',
  },
  -- Copilot completion
  -- https://github.com/zbirenbaum/copilot.lua
  {
    src = 'https://github.com/zbirenbaum/copilot.lua',
    build = ':Copilot auth',
  },
  -- Local completion plugin
  -- https://github.com/milanglacier/minuet-ai.nvim
}

local adapter_name = ''
local model_name = ''
local opencode_zen = nil
local opencode_api_key = os.getenv 'OPENCODE_API_KEY'

if opencode_api_key then
  adapter_name = 'opencode_zen'
  model_name = 'claude-sonnet-4-6'

  opencode_zen = function()
    return require('codecompanion.adapters').extend('openai_compatible', {
      env = {
        url = 'https://opencode.ai/zen',
        api_key = opencode_api_key,
        chat_url = '/v1/chat/completions',
      },
      schema = {
        model = {
          default = model_name,
        },
      },
    })
  end
else
  adapter_name = 'copilot'
  model_name = 'claude-sonnet-4.6'
end

require('codecompanion').setup {
  adapters = { http = { opencode_zen = opencode_zen } },
  interactions = {
    chat = {
      adapter = {
        name = adapter_name,
        model = model_name,
      },
    },
    inline = {
      variables = {
        ['staged_changes'] = {
          callback = function()
            local git_status = vim.fn.systemlist 'git diff --cached'

            return table.concat(git_status, '\n')
          end,
          description = 'Get the current staged git changes',
        },
      },
      adapter = {
        name = adapter_name,
        model = model_name,
      },
    },
    cmd = {
      adapter = {
        name = adapter_name,
        model = model_name,
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

  system_prompt = [[ code only. no explain. no markdown unless asked. short answers. fix what asked, nothing more.]],

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
}

require('copilot').setup {
  panel = { enabled = false },
  suggestion = { enabled = false },
}

-- [[ KEYMAPS [a] ]]
local map = vim.keymap.set

-- CodeCompanion
-- Chat
map({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'AI: Toggle chat' })
map('v', '<leader>av', '<cmd>CodeCompanionChat Add<cr>', { desc = 'AI: Add to chat' })

-- Inline assistant
map({ 'n', 'v' }, '<leader>ai', '<cmd>CodeCompanion<cr>', { desc = 'AI: Inline assistant' })
map({ 'n', 'v' }, '<leader>am', '<cmd>CodeCompanion /commit<cr>', { desc = 'AI: Generate commit message' })
map('v', '<leader>ae', '<cmd>CodeCompanion /explain<cr>', { desc = 'AI: Explain selection' })
map('v', '<leader>af', '<cmd>CodeCompanion /fix<cr>', { desc = 'AI: Fix selection' })
map('v', '<leader>ar', '<cmd>CodeCompanion /refactor<cr>', { desc = 'AI: Refactor selection' })
map('v', '<leader>at', '<cmd>CodeCompanion /test<cr>', { desc = 'AI: Generate tests' })
map('v', '<leader>ad', '<cmd>CodeCompanion Generate documentation for this code<cr>', { desc = 'AI: Document code' })
map('v', '<leader>aw', '<cmd>CodeCompanion Review this code for potential issues<cr>', { desc = 'AI: Review code' })

-- Action palette (all available actions/prompts)
map({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = 'AI: Actions' })

vim.cmd [[cab cc CodeCompanion]]
