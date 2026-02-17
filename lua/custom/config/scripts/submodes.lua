local submode = require 'submode'

submode.create('Resize', {
  mode = 'n',
  enter = '<leader>mr',
  desc = 'Resize buffer',
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
