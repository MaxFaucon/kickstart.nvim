vim.pack.add {
  -- Interactive database client for neovim
  {
    src = 'https://github.com/MaxFaucon/nvim-dbee',
  },
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-dbee' then
      require('dbee').install 'go'
    end
  end,
})

local dbee_config = require 'config.plugin.dbee'

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
          dbee_config.format_query()

          require('dbee').api.ui.editor_do_action 'run_under_cursor'
          dbee_config.reset_query_state()
          dbee_config.query_state.base_query = require('dbee').api.ui.result_get_call().query
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
            dbee_config.dbee_connection_changed(current_connection.name, current_connection.url)
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

vim.schedule(dbee_config.setup_autocmd_and_telescope)
