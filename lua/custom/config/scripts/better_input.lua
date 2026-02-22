vim.ui.input = function(opts, on_confirm)
  local Input = require 'nui.input'
  local input = Input({
    position = { row = '10%', col = '50%' },
    size = { width = 80 },
    border = { style = 'rounded', text = { top = opts.prompt or 'Input' } },
  }, {
    on_submit = on_confirm,
  })
  input:mount()
end
