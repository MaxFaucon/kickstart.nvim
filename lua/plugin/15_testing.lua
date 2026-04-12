vim.pack.add {
  -- A library for asynchronous IO in Neovim
  'https://github.com/nvim-neotest/nvim-nio',
  -- Fix CursorHold Performance.
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  -- Jest adapter for Neotest
  'https://github.com/nvim-neotest/neotest-jest',
  -- An extensible framework for interacting with tests within NeoVim.
  'https://github.com/nvim-neotest/neotest',
}

require('neotest').setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = function()
        local filename = vim.fn.expand '%:t'
        if string.find(filename, 'integration') then
          return 'npx jest --detectOpenHandles --testTimeout=60000'
        end
        return 'npx jest'
      end,

      jestConfigFile = function()
        local filename = vim.fn.expand '%:t'
        local jest_config_file = 'jest.config.js'

        -- Soil cap specific config
        if string.find(filename, 'spec') then
          jest_config_file = 'jest.unit.config.js'
        else
          if string.find(filename, 'integration') then
            jest_config_file = 'jest.integration.config.js'
          end
        end

        return jest_config_file
      end,

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

-- [[ KEYMAPS [n] ]]
local map = vim.keymap.set

map('n', '<leader>nr', '<cmd>lua require("neotest").run.run()<CR>', { desc = 'Run Nearest Test' })
map('n', '<leader>nf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = 'Run File Tests' })
map('n', '<leader>nq', '<cmd>lua require("neotest").run.stop()<CR>', { desc = 'Stop Test' })
map('n', '<leader>np', '<cmd>lua require("neotest").summary.toggle()<CR>', { desc = 'Toggle Test Summary' })
map('n', '<leader>no', '<cmd>lua require("neotest").output.open()<CR>', { desc = 'Open Test Output' })
map('n', '<leader>nl', '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', { desc = 'Run Nearest Test with DAP' })
map('n', '<leader>na', '<cmd>lua require("neotest").run.attach()<CR>', { desc = 'Attach to Running Test' })
