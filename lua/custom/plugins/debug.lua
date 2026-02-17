-- https://github.com/mfussenegger/nvim-dap
local plugins = {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    -- {
    -- {
    --   'microsoft/vscode-js-debug',
    --   -- After install, build it and rename the dist directory to out
    --   build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
    --   version = '1.*',
    -- },
    -- },
    -- 'mxsdev/nvim-dap-vscode-js',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>dss',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>dsi',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>dso',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>dsu',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>dp',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      desc = 'Debug: Eval expression',
    },
    {
      '<leader>dc',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = 'Debug: Clear breakpoints',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'php-debug-adapter',
        'js-debug-adapter',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- JS/TS Debug Adapter Configuration
    -- require('dap-vscode-js').setup {
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    -- debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    -- adapters = { 'node', 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    -- }

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' },
      },
    }

    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to process',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
        sourceMaps = true,
      },
      {
        name = 'Attach to Node',
        type = 'pwa-node',
        request = 'attach',
        restart = true,
        port = 9229,
        address = 'localhost',
        localRoot = '${workspaceFolder}',
        sourceMaps = true,
      },
      {
        name = 'Docker: Attach to Node',
        type = 'pwa-node',
        request = 'attach',
        restart = true,
        port = 9211,
        address = 'localhost',
        localRoot = '${workspaceFolder}',
        remoteRoot = '/app',
        sourceMaps = true,
      },
    }

    -- PHP Debug Adapter Configuration
    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        -- Only if PHP is running in a container
        pathMappings = {
          ['/var/www/html'] = vim.fn.getcwd(),
        },
      },
      {
        type = 'php',
        request = 'launch',
        name = 'Debug current script (CLI)',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'php',
        port = 9003,
      },
    }
  end,
}

return plugins
