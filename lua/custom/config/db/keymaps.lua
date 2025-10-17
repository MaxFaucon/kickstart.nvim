local helpers = require 'custom.config.db.helpers'

-- Open DBUI
vim.keymap.set('n', '<leader>dbo', function()
  vim.cmd 'enew'
  vim.cmd 'DBUI'
end, { desc = 'Open DBUI' })

-- Toggle DBUI sidebar
vim.keymap.set('n', '<leader>dbt', '<cmd>DBUIToggle<cr>', { desc = 'Toggle DBUI sidebar' })

-- Find/switch DB environment
vim.keymap.set('n', '<leader>dbe', '<cmd>DBUIFindBuffer<cr>', { desc = 'Find/switch DB environment' })

-- Last query info
vim.keymap.set('n', '<leader>dbl', '<cmd>DBUILastQueryInfo<cr>', { desc = 'Last query info' })

-- Execute SQL query between two semicolons
vim.keymap.set('n', '<leader>dbq', function()
  local start_line, end_line = helpers.get_sql_query()
  -- Highlight the SQL query range
  helpers.highlight_sql_query(start_line, end_line)
  -- Format the SQL query
  helpers.format_sql_query(start_line, end_line)
  -- Get updated line range after formatting (may have changed)
  start_line, end_line = helpers.get_sql_query()
  -- Convert SQL keywords to uppercase
  helpers.convert_sql_keywords_to_uppercase(start_line, end_line)
  -- Execute the range
  vim.cmd(start_line .. ',' .. end_line .. 'DB')
end, { desc = 'Execute current query (semicolon-bounded)' })

-- Set SQL keywords uppercase
vim.keymap.set('n', '<leader>dbu', function()
  local start_line, end_line = helpers.get_sql_query()
  -- Highlight the SQL query range
  helpers.highlight_sql_query(start_line, end_line)
  -- Convert SQL keywords to uppercase
  helpers.convert_sql_keywords_to_uppercase(start_line, end_line)
end, { desc = 'Convert SQL keywords to uppercase' })
