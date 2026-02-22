local M = {}

local postgres_lsp_template = require 'custom.config.db.postgres-lsp-config-template'
local previous_connection_url = nil

local dbee_drawer_window = nil
M.dbee_connection_changed = function(current_connection_name, current_connection_url)
  if current_connection_name ~= nil and current_connection_url ~= nil and current_connection_url ~= previous_connection_url then
    previous_connection_url = current_connection_url

    local postgres_lsp_config_path = vim.fn.stdpath 'state' .. '/dbee/notes/global/postgres-language-server.jsonc'
    local fd, err = vim.uv.fs_open(postgres_lsp_config_path, 'w', 0x666)

    if err or fd == nil then
      print('Error creating file: ' .. err)
    else
      -- Write content to the file
      local _, write_err = vim.uv.fs_write(fd, postgres_lsp_template.get_config_template(current_connection_url), 0)
      if write_err then
        print('Error writing to file: ' .. write_err)
      end

      -- Restart postgres lsp
      vim.cmd 'LspRestart! postgres_lsp'

      -- Close the file descriptor
      vim.uv.fs_close(fd)
    end

    if dbee_drawer_window ~= nil then
      print('Connection:', current_connection_name)
      vim.wo[dbee_drawer_window].winbar = 'Connection: ' .. current_connection_name
    end
  end
end

M.setup_autocmd_and_telescope = function()
  -- Telescope entries for connections
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'

  local function db_connections_picker()
    local dbee_sources = require('dbee').api.core.get_sources()
    local available_connections = {}

    for i = 1, #dbee_sources, 1 do
      local dbee_source = dbee_sources[i]
      local source_connections = require('dbee').api.core.source_get_connections(dbee_source.name(dbee_source))

      for j = 1, #source_connections, 1 do
        table.insert(available_connections, source_connections[j])
      end
    end

    pickers
      .new({}, {
        prompt_title = 'Database connections picker',
        initial_mode = 'normal',
        layout_config = {
          anchor = 'CENTER',
          height = 0.5,
          width = 0.5,
        },
        finder = finders.new_table {
          results = available_connections,
          entry_maker = function(entry)
            return {
              value = entry.id,
              display = entry.name,
              ordinal = entry.url,
            }
          end,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(bufnr, map)
          map({ 'i', 'n' }, '<CR>', function()
            local selection = require('telescope.actions.state').get_selected_entry()

            require('telescope.actions').close(bufnr)
            require('dbee').api.core.set_current_connection(selection.value)

            M.dbee_connection_changed(selection.display, selection.ordinal)
          end)

          return true -- Retain default keymaps
        end,
      })
      :find()
  end

  -- Autocommands
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*dbee-drawer' },
    callback = function()
      local current_connection = require('dbee').api.core.get_current_connection()

      if dbee_drawer_window == nil then
        dbee_drawer_window = vim.api.nvim_get_current_win()
      end

      if current_connection ~= nil then
        M.dbee_connection_changed(current_connection.name, current_connection.url)
      end

      -- Dbee context keymaps
      vim.keymap.set('n', '<leader>s', db_connections_picker, { desc = 'Database connections Telescope picker' })
    end,
  })
end

return M
