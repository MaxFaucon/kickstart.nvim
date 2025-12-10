local sql_keywords_set = require 'custom.config.db.sql_keywords'

local M = {}

M.get_sql_query = function()
  local cursor_line = vim.fn.line '.'

  -- Find query start (look backwards for semicolon or buffer start)
  local start_line = cursor_line
  while start_line > 1 do
    local line_content = vim.fn.getline(start_line - 1)
    if line_content:match ';%s*$' then -- ends with semicolon
      break
    end
    start_line = start_line - 1
  end

  -- Find query end (look forward for semicolon)
  local end_line = cursor_line
  local last_line = vim.fn.line '$'
  while end_line <= last_line do
    local line_content = vim.fn.getline(end_line)
    if line_content:match ';%s*$' then -- ends with semicolon
      break
    end
    end_line = end_line + 1
  end

  return start_line, end_line
end

M.highlight_sql_query = function(start_line, end_line)
  -- Highlight using extmarks
  local ns_id = vim.api.nvim_create_namespace 'db_query_highlight'
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  for line = start_line, end_line do
    local line_content = vim.fn.getline(line)
    local line_length = #line_content

    vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, 0, {
      end_line = line - 1,
      end_col = line_length,
      hl_group = 'Visual',
      priority = 200,
    })
  end

  -- Clear highlight after delay
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end, 500)
end

M.convert_sql_keywords_to_uppercase = function(start_line, end_line)
  for line = start_line, end_line do
    local line_content = vim.fn.getline(line)
    local updated_content = line_content:gsub('(%a[%w_]*)', function(word)
      return sql_keywords_set[word] and word:upper() or word
    end)

    -- Update the line if it changed
    if line_content ~= updated_content then
      vim.fn.setline(line, updated_content)
    end
  end
end

M.format_sql_query = function(start_line, end_line)
  -- Get the query content
  local lines = {}
  for line = start_line, end_line do
    table.insert(lines, vim.fn.getline(line))
  end
  local query = table.concat(lines, '\n')

  -- Create a temporary file with the query
  local temp_file = vim.fn.tempname() .. '.sql'
  local file = io.open(temp_file, 'w')
  if not file then
    vim.notify('Failed to create temporary file for formatting', vim.log.levels.ERROR)
    return
  end
  file:write(query)
  file:close()

  -- Format using pg_format
  local cmd = string.format('pg_format --no-extra-line %s', temp_file)
  local formatted = vim.fn.system(cmd)

  -- Clean up temp file
  os.remove(temp_file)

  -- Check if formatting was successful
  if vim.v.shell_error ~= 0 then
    vim.notify('pg_format failed: ' .. formatted, vim.log.levels.ERROR)
    return
  end

  -- Replace the lines with formatted content
  local formatted_lines = vim.split(formatted, '\n')
  -- Remove empty last line if it exists
  if formatted_lines[#formatted_lines] == '' then
    table.remove(formatted_lines)
  end

  -- Replace the original lines
  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, formatted_lines)
end

M.save_to_history = function()
  local buffer_first_line = 2
  local buffer_last_line = vim.fn.line '$'
  local buffer_directory = vim.fn.expand '%:h:t'
  local history_file = os.getenv 'HOME' .. '/Documents/sql_queries/' .. buffer_directory .. '/history.sql'
  local file, err = io.open(history_file, 'a')

  if not file then
    vim.notify('Failed to open history file for writing', vim.log.levels.ERROR, { title = err })
    return
  end

  file:write('-- ' .. os.date '%Y-%m-%d %H:%M:%S' .. '\n')
  for line = buffer_first_line, buffer_last_line do
    local line_content = vim.fn.getline(line)
    file:write(line_content .. '\n')
  end
  file:write '\n'

  file:close()

  -- Delete the current buffer content
  vim.api.nvim_buf_set_lines(0, buffer_first_line, buffer_last_line, false, {})
end

return M
