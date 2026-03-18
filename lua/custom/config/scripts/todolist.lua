local floating_window = require 'custom.config.scripts.create_floating_window'

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function setup_keymaps()
  vim.keymap.set('n', '<leader>tn', function()
    local cursor_position = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_buf_set_lines(0, cursor_position[1], cursor_position[1], false, { '- [ ] ' })
    vim.api.nvim_win_set_cursor(0, { cursor_position[1] + 1, 0 })

    vim.cmd 'startinsert!'
  end, { buffer = state.floating.buf, desc = 'Add a new item' })

  vim.keymap.set('n', '<leader>ts', function()
    local line = vim.api.nvim_get_current_line()
    if line:match '%[ %]' then
      local done_item = line:gsub('%[ %]', '[x]')
      vim.api.nvim_set_current_line(done_item)
    elseif line:match '%[x%]' then
      local undone_item = line:gsub('%[x%]', '[ ]')
      vim.api.nvim_set_current_line(undone_item)
    end
  end, { buffer = state.floating.buf, desc = 'Toggle item status' })

  vim.keymap.set('n', 'q', function()
    vim.cmd ':x'
  end, { buffer = state.floating.buf, desc = 'Close todo list' })
end

local toggle_todo_list = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    local todo_list_path = vim.fn.stdpath 'state' .. '/todolist.md'
    if not vim.uv.fs_stat(todo_list_path) then
      vim.notify('Todo list file does not exist: ' .. todo_list_path, vim.log.levels.ERROR)
      return
    end

    state.floating = floating_window.create_floating_window { use_default_size = true }

    -- Open a file and replace previous buffer
    vim.cmd.edit(todo_list_path)
    vim.api.nvim_buf_delete(state.floating.buf, { force = true })
    state.floating.buf = vim.api.nvim_win_get_buf(state.floating.win)

    setup_keymaps()
  else
    vim.api.nvim_win_close(state.floating.win, false)
  end
end

vim.api.nvim_create_user_command('Todolist', toggle_todo_list, {})
