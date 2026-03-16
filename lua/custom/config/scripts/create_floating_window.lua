local M = {}

local function get_window_size(opts)
  local max_height = math.floor(vim.o.lines * 0.8)
  local max_width = math.floor(vim.o.columns * 0.8)

  if opts.content ~= nil then
    local content_height = #opts.content
    local content_width = vim.fn.max(vim.tbl_map(function(line)
      return #line
    end, opts.content))

    local height = content_height > max_height and max_height or content_height
    local width = content_width > max_width and max_width or content_width

    return { height, width }
  else
    return { max_height, max_width }
  end
end

M.create_floating_window = function(opts)
  local prev_pos = vim.api.nvim_win_get_cursor(0)
  local prev_win = vim.api.nvim_get_current_win()

  local window_size = get_window_size(opts)
  local height = window_size[1]
  local width = window_size[2]

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

  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.content or {})

  vim.keymap.set('n', 'q', function()
    if opts.callback then
      opts.callback(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
    end

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_set_current_win(prev_win)
    vim.api.nvim_win_set_cursor(prev_win, prev_pos)
  end, { buffer = buf })

  return { buf = buf, win = win }
end

return M
