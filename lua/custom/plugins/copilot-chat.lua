-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'claude-sonnet-4', -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float'
        width = 0.4, -- 50% of screen width
      },
      headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },
      auto_insert_mode = true, -- Enter insert mode when opening
      title = '🤖 AI Assistant',
      auto_fold = true,
    },
  },
}
