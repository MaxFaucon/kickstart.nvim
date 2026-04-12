vim.pack.add {
  -- Visualize debugging sessions in neovim
  'https://github.com/igorlfs/nvim-dap-view',
  -- Debug Adapter Protocol client implementation for Neovim
  'https://github.com/mfussenegger/nvim-dap',
}

require('dap-view').setup {
  auto_toggle = true,
}

local dap = require 'dap'

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

-- [[ KEYMAPS [d] ]]
local map = vim.keymap.set
local unmap = vim.keymap.del

map('n', '<leader>dss', function()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })

map('n', '<leader>dp', function()
  require('dap').toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })

map('n', '<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint with condition' })

map('n', '<leader>dc', function()
  require('dap').clear_breakpoints()
end, { desc = 'Debug: Clear breakpoints' })

dap.listeners.after.event_initialized['dap_keymaps'] = function()
  map('n', '<leader>di', function()
    require('dap').step_into()
  end, { desc = 'Debug: Step Into' })

  map('n', '<leader>do', function()
    require('dap').step_over()
  end, { desc = 'Debug: Step Over' })

  map('n', '<leader>du', function()
    require('dap').step_out()
  end, { desc = 'Debug: Step Out' })

  map('n', '<leader>dv', function()
    require('dap-view').toggle()
  end, { desc = 'Debug: Toggle view' })

  map('n', '<leader>de', function()
    require('dap-view').virtual_text_toggle()
  end, { desc = 'Debug: Toggle virtual text' })
end

local exit_events = { 'event_terminated', 'event_exited' }
for _, exit_event in ipairs(exit_events) do
  dap.listeners.before[exit_event]['dap_keymaps'] = function()
    unmap('n', '<leader>di')
    unmap('n', '<leader>do')
    unmap('n', '<leader>du')
    unmap('n', '<leader>dv')
    unmap('n', '<leader>de')
  end
end
