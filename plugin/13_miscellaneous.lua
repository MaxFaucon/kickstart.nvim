vim.pack.add {
  -- Library of 40+ independent Lua modules improving Neovim experience with minimal effort
  'https://github.com/nvim-mini/mini.nvim',
}

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

require('mini.comment').setup()

require('mini.snippets').setup()

require('mini.pairs').setup()

local miniclue = require 'mini.clue'
miniclue.setup {
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- Builtin completion commands
    { mode = 'n', keys = '<C-x>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = 'n', keys = '<Leader>a', desc = '+AI' },
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>n', desc = '+Neotest' },
    { mode = 'n', keys = '<Leader>p', desc = '+Perso' },
    { mode = 'n', keys = '<Leader>q', desc = '+Quickfix' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
    { mode = 'n', keys = '<Leader>w', desc = '+Window' },
    { mode = 'n', keys = '<Leader>z', desc = '+ZK' },
  },

  -- Clue window settings
  window = {
    config = { anchor = 'SW', row = 'auto', col = 'auto' },
    -- Delay before showing clue window
    delay = 200,

    -- Keys to scroll inside the clue window
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
}

require('mini.indentscope').setup {
  symbol = '│',
  draw = {
    delay = 100,
    animation = require('mini.indentscope').gen_animation.none(),
  },
}
