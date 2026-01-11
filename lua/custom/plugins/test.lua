return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-jest' {
            jestCommand = 'npx jest',
            jestArguments = function(defaultArguments, context)
              return defaultArguments
            end,
            jestConfigFile = 'jest.config.ts',
            env = { CI = true },
            cwd = function(path)
              -- Traverse up from test file to find nearest package.json
              local root = vim.fn.fnamemodify(path, ':p:h')
              while root ~= '/' do
                if vim.fn.filereadable(root .. '/package.json') == 1 and root ~= vim.fn.getcwd() then -- exclude monorepo root
                  return root
                end
                root = vim.fn.fnamemodify(root, ':h')
              end
              return vim.fn.getcwd() -- fallback
            end,
            isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
          },
        },
      }
    end,
  },
}
