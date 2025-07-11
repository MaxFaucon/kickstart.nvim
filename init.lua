-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ CONFIG ]]
-- Options
require 'custom.config.options'
-- Keymaps
require 'custom.config.keymaps'
-- Autocommands
require 'custom.config.autocommands'
-- Custom plugins
-- require 'custom.config.floaterminal'
require 'custom.config.db'

-- [[ PLUGINS ]]
-- Init
require 'custom.config.lazy'

-- submodes
require 'custom.config.submodes'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
