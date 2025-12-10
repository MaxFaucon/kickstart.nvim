local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  s('txx', {
    t { 'BEGIN;', '-- Changes', '' },
    i(1, '-- Your SQL here'),
    t { '', '', '-- Verification', '' },
    i(2, 'SELECT COUNT(*) FROM affected_table;'),
    t { '', '', '-- Finalize', '' },
    c(3, {
      t 'ROLLBACK; -- Safe by default',
      t 'COMMIT; -- Verified!',
    }),
  }),

  s('ddlv', {
    t "SELECT pg_get_viewdef('views.",
    i(1, 'view_name'),
    t "'::regclass, true);",
  }),

  s('ddlc', {
    t { "SELECT * FROM information_schema.columns WHERE table_name = '" },
    i(1, 'table_name'),
    t { " AND table_schema = 'public'; " },
  }),
}
