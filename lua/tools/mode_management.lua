local M = {}

---@class ModeKeymap
---@field default string
---@field new string

---@type ModeKeymap[]
M.resize_window_keymaps = {
  { default = '<C-w><', new = 'h' },
  { default = '5<C-w><', new = 'H' },
  { default = '<C-w>-', new = 'j' },
  { default = '5<C-w>-', new = 'J' },
  { default = '<C-w>+', new = 'k' },
  { default = '5<C-w>+', new = 'K' },
  { default = '<C-w>>', new = 'l' },
  { default = '5<C-w>>', new = 'L' },
}

---@param keymaps ModeKeymap[]
---@param mode_name string
M.toggle_mode = function(keymaps, mode_name)
  local map = vim.keymap.set
  local unmap = vim.keymap.del
  local saved = {}

  for _, keymap in ipairs(keymaps) do
    -- Save existing buffer-local mapping if any
    local existing = vim.fn.maparg(keymap.new, 'n', false, true)
    saved[keymap.new] = existing

    map('n', keymap.new, keymap.default, { buf = 0, nowait = true })
  end

  map('n', '<Esc>', function()
    for _, keymap in ipairs(keymaps) do
      local existing = saved[keymap.new]

      if existing and existing.buffer and existing.buffer == 1 then
        -- Restore the original buffer-local mapping
        vim.fn.mapset(existing)
      else
        unmap('n', keymap.new, { buf = 0 })
      end
    end

    unmap('n', '<Esc>', { buf = 0 })
    vim.notify(mode_name .. ' mode off', vim.log.levels.INFO)
  end, { buf = 0, nowait = true })

  vim.notify(mode_name .. ' mode on', vim.log.levels.INFO)
end

return M
