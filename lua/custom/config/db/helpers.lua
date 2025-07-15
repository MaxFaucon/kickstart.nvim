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

return M
