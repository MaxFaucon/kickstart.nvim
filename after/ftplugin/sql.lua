local sql_keywords_set = require 'custom.config.db.sql_keywords'

for sql_keyword, _ in pairs(sql_keywords_set) do
  vim.cmd('iabbrev <buffer> ' .. sql_keyword .. ' ' .. sql_keyword:upper())
end
