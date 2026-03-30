local floating_window = require 'custom.config.scripts.create_floating_window'

local todolist_state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local draft_state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function setup_todolist_keymaps()
  vim.keymap.set('n', '<leader>tn', function()
    local cursor_position = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_buf_set_lines(0, cursor_position[1], cursor_position[1], false, { '- [ ] ' })
    vim.api.nvim_win_set_cursor(0, { cursor_position[1] + 1, 0 })

    vim.cmd 'startinsert!'
  end, { buffer = todolist_state.floating.buf, desc = 'Add a new item' })

  vim.keymap.set('n', '<leader>ts', function()
    local line = vim.api.nvim_get_current_line()
    if line:match '%[ %]' then
      local done_item = line:gsub('%[ %]', '[x]')
      vim.api.nvim_set_current_line(done_item)
    elseif line:match '%[x%]' then
      local undone_item = line:gsub('%[x%]', '[ ]')
      vim.api.nvim_set_current_line(undone_item)
    end
  end, { buffer = todolist_state.floating.buf, desc = 'Toggle item status' })

  vim.keymap.set('n', 'q', function()
    vim.cmd ':x'
  end, { buffer = todolist_state.floating.buf, desc = 'Close todo list' })
end

local toggle_todo_list = function()
  if not vim.api.nvim_win_is_valid(todolist_state.floating.win) then
    local todo_list_path = vim.fn.stdpath 'state' .. '/todolist.md'
    if not vim.uv.fs_stat(todo_list_path) then
      vim.notify('Todo list file does not exist: ' .. todo_list_path, vim.log.levels.ERROR)
      return
    end

    todolist_state.floating = floating_window.create_floating_window { use_default_size = true }

    -- Open a file and replace previous buffer
    vim.cmd.edit(todo_list_path)
    vim.api.nvim_buf_delete(todolist_state.floating.buf, { force = true })
    todolist_state.floating.buf = vim.api.nvim_win_get_buf(todolist_state.floating.win)

    setup_todolist_keymaps()
  else
    vim.api.nvim_win_close(todolist_state.floating.win, false)
  end
end

local function setup_draft_keymaps()
  vim.keymap.set('n', '<leader>c', function()
    vim.api.nvim_buf_set_lines(draft_state.floating.buf, 0, -1, false, {})
  end, { buffer = todolist_state.floating.buf, desc = 'Clear draft note' })

  vim.keymap.set('n', 'q', function()
    vim.cmd ':x'
  end, { buffer = todolist_state.floating.buf, desc = 'Close draft note' })
end

local toggle_draft = function()
  if not vim.api.nvim_win_is_valid(draft_state.floating.win) then
    local draft_path = vim.fn.stdpath 'state' .. '/draft.md'
    if not vim.uv.fs_stat(draft_path) then
      vim.notify('The draft note file does not exist: ' .. draft_path, vim.log.levels.ERROR)
      return
    end

    draft_state.floating = floating_window.create_floating_window { use_default_size = true }

    -- Open a file and replace previous buffer
    vim.cmd.edit(draft_path)
    vim.api.nvim_buf_delete(draft_state.floating.buf, { force = true })
    draft_state.floating.buf = vim.api.nvim_win_get_buf(draft_state.floating.win)

    setup_draft_keymaps()
  else
    vim.api.nvim_win_close(draft_state.floating.win, false)
  end
end

vim.api.nvim_create_user_command('Todolist', toggle_todo_list, {})
vim.api.nvim_create_user_command('Draft', toggle_draft, {})
