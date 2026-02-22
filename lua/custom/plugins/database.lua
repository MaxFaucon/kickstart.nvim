local sql_helpers = require 'custom.config.db.helpers'
local dbee_scripts = require 'custom.config.db.dbee-config-scripts'

local plugins = {
  -- https://github.com/tpope/vim-dadbod
  -- https://github.com/kristijanhusak/vim-dadbod-ui
  {
    'tpope/vim-dadbod',
    dependencies = {
      'MaxFaucon/vim-dadbod-completion',
      'kristijanhusak/vim-dadbod-ui',
    },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBEnv' },
  },
  -- https://github.com/kndndrj/nvim-dbee
  {
    'kndndrj/nvim-dbee',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    build = function()
      require('dbee').install()
    end,
    config = function()
      require('dbee').setup {
        sources = {
          require('dbee.sources').FileSource:new(vim.fn.stdpath 'cache' .. '/dbee/persistence.json'),
        },
        editor = {
          mappings = {
            { key = 'BB', mode = 'v', action = 'run_selection' },
            {
              key = '<CR>',
              mode = 'n',
              action = function()
                local start_line, end_line = sql_helpers.get_sql_query()
                -- Format the SQL query and get updated range
                sql_helpers.format_sql_query(start_line, end_line)

                require('dbee').api.ui.editor_do_action 'run_under_cursor'
              end,
            },
            { key = 'BB', mode = 'n', action = 'run_under_cursor' },
          },
        },
        drawer = {
          mappings = {
            -- manually refresh drawer
            { key = 'r', mode = 'n', action = 'refresh' },
            -- actions perform different stuff depending on the node:
            -- action_1 opens a note or executes a helper
            {
              key = '<CR>',
              mode = 'n',
              action = function()
                require('dbee').api.ui.drawer_do_action 'action_1'

                local current_connection = require('dbee').api.core.get_current_connection()

                if current_connection ~= nil then
                  dbee_scripts.dbee_connection_changed(current_connection.name, current_connection.url)
                end
              end,
            },
            -- action_2 renames a note or sets the connection as active manually
            { key = 'cw', mode = 'n', action = 'action_2' },
            -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
            { key = 'dd', mode = 'n', action = 'action_3' },
            -- these are self-explanatory:
            -- { key = "c", mode = "n", action = "collapse" },
            -- { key = "e", mode = "n", action = "expand" },
            { key = 'o', mode = 'n', action = 'toggle' },
            -- mappings for menu popups:
            { key = '<CR>', mode = 'n', action = 'menu_confirm' },
            { key = 'y', mode = 'n', action = 'menu_yank' },
            { key = '<Esc>', mode = 'n', action = 'menu_close' },
            { key = 'q', mode = 'n', action = 'menu_close' },
          },
        },
      }
    end,
  },
}

vim.schedule(dbee_scripts.setup_autocmd_and_telescope)

return plugins
