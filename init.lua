-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set UTF-8 as the default encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

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
require 'custom.config.db.db'

-- [[ PLUGINS ]]
-- Init
require 'custom.config.lazy'

-- submodes
require 'custom.config.submodes'

-- Setup default buffer on startup
vim.opt.shortmess:append 'I' -- Disable intro message
vim.schedule(function()
  -- Only open Oil if no file was specified
  if vim.fn.argc() == 0 then
    require('oil').open()
  end
end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
