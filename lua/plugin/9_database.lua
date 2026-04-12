vim.pack.add {
  -- Interactive database client for neovim
  {
    src = 'https://github.com/kndndrj/nvim-dbee',
    build = function()
      require('dbee').install 'go'
    end,
  },
}

local dbee_scripts = require 'config.db.dbee-config-scripts'

require('dbee').setup {
  {
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
            dbee_scripts.format_query()

            require('dbee').api.ui.editor_do_action 'run_under_cursor'
            dbee_scripts.reset_query_state()
            dbee_scripts.query_state.base_query = require('dbee').api.ui.result_get_call().query
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
  },
}

vim.schedule(dbee_scripts.setup_autocmd_and_telescope)
