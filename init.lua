-- Set <space> as the leader key
-- See `:help mapleader`

-- [[ CONFIG ]]
-- Options
require 'config.options'
-- Keymaps
require 'config.keymaps'
-- Autocommands
require 'config.autocommands'

-- [[ PLUGINS ]]
require 'plugin.0_dependencies'
require 'plugin.1_code'
require 'plugin.2_file-explorer'
require 'plugin.3_search'
require 'plugin.4_ui'
require 'plugin.5_completion'
require 'plugin.6_lsp'
require 'plugin.7_git'
require 'plugin.8_ai'
require 'plugin.9_database'
require 'plugin.10_debug'
require 'plugin.11_markdown'
require 'plugin.12_terminal'
require 'plugin.13_miscellaneous'
require 'plugin.14_navigation'
require 'plugin.15_testing'
require 'plugin.16_tools'

-- Custom plugins
require 'lua.config.db.db'

-- [[ Scripts ]]
require 'lua.config.scripts.better_input'
require 'lua.config.scripts.floating_notes'
