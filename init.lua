-- Set <space> as the leader key
-- See `:help mapleader`

-- [[ CONFIG ]]
-- Options
require 'config.options'
-- Keymaps
require 'config.keymaps'
-- Autocommands
require 'config.autocommands'

-- Custom plugins
require 'lua.config.db.db'

-- [[ Scripts ]]
require 'lua.config.scripts.better_input'
require 'lua.config.scripts.floating_notes'
