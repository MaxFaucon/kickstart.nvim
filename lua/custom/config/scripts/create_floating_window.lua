local M = {}

M.create_floating_window = function(opts)
  local prev_pos = opts.cursor_position or vim.api.nvim_win_get_cursor(0)
  local prev_win = vim.api.nvim_get_current_win()
  print('test', vim.inspect(opts.cursor_position), vim.inspect(vim.api.nvim_win_get_cursor(0)))

  opts = opts or {}
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  if opts.width and opts.width < width then
    width = opts.width
  end
  if opts.height and opts.height < height then
    height = opts.height
  end

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = opts.relative or 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal', -- No borders or extra UI elements
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_set_current_win(prev_win)
    vim.api.nvim_win_set_cursor(prev_win, prev_pos)
  end, { buffer = buf })

  return { buf = buf, win = win }
end

return M
