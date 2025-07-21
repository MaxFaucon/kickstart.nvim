local submode = require 'submode'

submode.create('Resize', {
  mode = 'n',
  enter = '<leader>mr',
  leave = { 'q', '<ESC>' },
  default = function(register)
    register('l', '<C-w>>', { desc = 'Resize mode: Increase width' })
    register('j', '<C-w>-', { desc = 'Resize mode: Decrease height' })
    register('k', '<C-w>+', { desc = 'Resize mode: Increase height' })
    register('h', '<C-w><', { desc = 'Resize mode: Decrease width' })
    register('L', '<C-w>5>', { desc = 'Resize mode: Increase width by 5' })
    register('J', '<C-w>5-', { desc = 'Resize mode: Decrease height by 5' })
    register('K', '<C-w>5+', { desc = 'Resize mode: Increase height by 5' })
    register('H', '<C-w>5<', { desc = 'Resize mode: Decrease width by 5' })
  end,
})

submode.create('Debug', {
  mode = 'n',
  enter = '<leader>md',
  leave = { 'q', '<ESC>' },
  default = function(register)
    -- register('s', '<cmd>DapContinue<CR>', { desc = 'Debug mode: Start/Continue' })
    -- register('i', '<cmd>DapStepInto<CR>', { desc = 'Debug mode: Step Into' })
    -- register('o', '<cmd>DapStepOver<CR>', { desc = 'Debug mode: Step Over' })
    -- register('t', '<cmd>DapStepOut<CR>', { desc = 'Debug mode: Step Out' })
    -- register('p', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Debug mode: Toggle Breakpoint' })
    -- register('B', '<cmd>DapSetBreakpoint<CR>', { desc = 'Debug mode: Set Breakpoint' })
    -- register('u', '<cmd>DapUIToggle<CR>', { desc = 'Debug mode: See last session result.' })
    -- register('e', '<cmd>DapUIEval<CR>', { desc = 'Debug mode: Eval expression' })
    register('s', '<leader>dss', { desc = 'Debug mode: Start/Continue' })
    register('i', '<leader>dsi', { desc = 'Debug mode: Step Into' })
    register('o', '<leader>dso', { desc = 'Debug mode: Step Over' })
    register('t', '<leader>dsu', { desc = 'Debug mode: Step Out' })
    register('p', '<leader>dp', { desc = 'Debug mode: Toggle Breakpoint' })
    register('B', '<leader>dB', { desc = 'Debug mode: Set Breakpoint' })
    register('u', '<leader>du', { desc = 'Debug mode: See last session result.' })
    register('e', '<leader>de', { desc = 'Debug mode: Eval expression' })
  end,
})
