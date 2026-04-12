local sql_keywords_set = require 'helpers.sql_keywords'

local M = {}

M.get_sql_query = function()
  local cursor_line = vim.fn.line '.'

  -- Find query start (look backwards for semicolon or empty line)
  local start_line = cursor_line
  while start_line > 1 do
    local line_content = vim.fn.getline(start_line - 1)
    if line_content:match ';%s*$' or line_content:match '^%s*$' then -- previous line ends with semicolon or is empty
      break
    end
    start_line = start_line - 1
  end

  -- Find query end (look forward for semicolon or empty line, but stop before empty line)
  local end_line = cursor_line
  local last_line = vim.fn.line '$'
  while end_line <= last_line do
    local line_content = vim.fn.getline(end_line)
    if line_content:match ';%s*$' then -- current line ends with semicolon - include this line
      break
    elseif line_content:match '^%s*$' then -- current line is empty - exclude this line
      end_line = end_line - 1
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

M.add_soft_delete_condition_on_join = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local word_before_on = vim.fn.matchlist(current_line:sub(1, col), '\\v(\\w+)\\s+ON')[2]

  if word_before_on ~= nil then
    local soft_delete_string = 'AND ' .. word_before_on .. '.deleted_at IS NULL'
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { soft_delete_string })
    vim.api.nvim_win_set_cursor(0, { row, col + #soft_delete_string + 1 })
  else
    vim.notify('No JOIN condition found on the current line', vim.log.levels.WARN)
  end
end

M.add_table_abbreviation = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local previous_word = vim.fn.matchlist(current_line:sub(1, col), '\\v(\\w+)\\s*$')[2]

  if previous_word == nil then
    vim.notify('No table name found before the cursor', vim.log.levels.WARN)
    return
  end

  local abbreviation = ''
  for w in string.gmatch(previous_word, '%w+') do
    abbreviation = abbreviation .. w:sub(1, 1)
  end

  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { abbreviation })
  vim.api.nvim_win_set_cursor(0, { row, col + #abbreviation + 1 })
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
    return start_line, end_line -- return original range on error
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
    return start_line, end_line -- return original range on error
  end

  -- Replace the lines with formatted content
  local formatted_lines = vim.split(formatted, '\n')
  -- Remove empty last line if it exists
  if formatted_lines[#formatted_lines] == '' then
    table.remove(formatted_lines)
  end

  -- Replace the original lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted_lines)

  -- Return the new end line after formatting
  local new_end_line = start_line + #formatted_lines - 1
  return start_line, new_end_line
end

---@param history_file_path? string The path of the file to store sql history
M.save_to_history = function(history_file_path)
  if history_file_path == nil then
    history_file_path = os.getenv 'HOME' .. '/Documents/sql_queries/history.sql'
  end

  local buffer_first_line = 0
  local buffer_last_line = vim.fn.line '$'
  local file, err = io.open(history_file_path, 'a')

  if not file then
    vim.notify('Failed to open history file for writing', vim.log.levels.ERROR, { title = err })
    return
  end

  file:write('\n-- ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' --')
  for line = buffer_first_line, buffer_last_line do
    local line_content = vim.fn.getline(line)
    file:write(line_content .. '\n')
  end
  file:write '\n'

  file:close()

  -- Delete the current buffer content
  vim.api.nvim_buf_set_lines(0, buffer_first_line, buffer_last_line, false, {})
end

M.inspect_table_query = [[
WITH column_constraints AS (
    SELECT
        unnest(conkey) AS attnum,
        string_agg(
            CASE contype
                WHEN 'p' THEN 'PRIMARY KEY'
                WHEN 'u' THEN 'UNIQUE'
                WHEN 'f' THEN 'REFERENCES ' || (SELECT relname FROM pg_class WHERE oid = confrelid)
                WHEN 'c' THEN 'CHECK'
            END, ' | '
        ) AS constraints
    FROM pg_constraint
    WHERE conrelid = '{}'::regclass
    GROUP BY 1
)
SELECT
    a.attname AS column_name,
    format_type(a.atttypid, a.atttypmod) AS data_type,
    CASE WHEN a.attnotnull THEN 'NOT NULL' ELSE '' END AS is_nullable,
    COALESCE(pg_get_expr(d.adbin, d.adrelid), '') AS default_value,
    COALESCE(cc.constraints, '') AS constraints,
    COALESCE(col_description(a.attrelid, a.attnum), '') AS column_comment
FROM pg_attribute a
LEFT JOIN pg_attrdef d ON d.adrelid = a.attrelid AND d.adnum = a.attnum
LEFT JOIN column_constraints cc ON cc.attnum = a.attnum
WHERE a.attrelid = '{}'::regclass
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attnum;
]]

M.execute_psql_query = function(connection_url, query)
  local result = vim.fn.system {
    'psql',
    connection_url,
    '-t',
    '-A',
    '-c',
    query,
  }

  return result
end

return M
