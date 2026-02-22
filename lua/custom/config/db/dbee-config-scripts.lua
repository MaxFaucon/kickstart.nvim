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

  local function db_notes_picker()
    local dbee_global_notes = require('dbee').api.ui.editor_namespace_get_notes 'global'

    pickers
      .new({}, {
        prompt_title = 'Database notes picker',
        initial_mode = 'normal',
        layout_config = {
          anchor = 'CENTER',
          height = 0.5,
          width = 0.5,
        },
        finder = finders.new_table {
          results = dbee_global_notes,
          entry_maker = function(entry)
            return {
              value = entry.id,
              display = entry.name,
              ordinal = entry.name,
            }
          end,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(bufnr, map)
          map({ 'i', 'n' }, '<CR>', function()
            local selection = require('telescope.actions.state').get_selected_entry()

            require('telescope.actions').close(bufnr)
            require('dbee').api.ui.editor_set_current_note(selection.value)

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
      vim.keymap.set('n', 'q', function()
        require('dbee').close()
      end, { desc = 'Close DBee' })
      vim.keymap.set('n', '<leader>sc', db_connections_picker, { desc = 'Dbee search connections' })
      vim.keymap.set('n', '<leader>sn', db_notes_picker, { desc = 'Dbee search notes' })
      vim.keymap.set('n', '<leader>nc', function()
        vim.ui.input({ prompt = 'Enter note name: ' }, function(input)
          if input then
            local new_note = require('dbee').api.ui.editor_namespace_create_note('global', input)
            require('dbee').api.ui.editor_set_current_note(new_note)
          end
        end)
      end, { desc = 'DBee create note' })
      vim.keymap.set('n', '<leader>so', function()
        local current_result = require('dbee').api.ui.result_get_call()

        if current_result == nil then
          vim.notify('No result in the output', vim.log.levels.WARN)
          return
        end

        vim.ui.select({ 'csv', 'json', 'table' }, {
          prompt = 'Choose export format:',
        }, function(format_choice)
          if format_choice then
            vim.ui.select({ 'file', 'yank' }, {
              prompt = 'Choose where to store:',
            }, function(store_choice)
              if store_choice == 'file' then
                vim.ui.input({ prompt = 'Enter file path:', default = '~/Documents/extracts/' }, function(file_path)
                  local expanded_path = vim.fn.expand(file_path)
                  local stat = vim.loop.fs_stat(expanded_path)
                  local path_exists = stat and stat.type == 'directory'

                  if not path_exists then
                    vim.notify('Directory does not exist', vim.log.levels.ERROR)
                  else
                    local timestamp = os.time()

                    vim.ui.input({ prompt = 'Enter file name: ', default = timestamp .. '_' }, function(filename)
                      if filename then
                        local complete_path = expanded_path .. filename
                        require('dbee').api.core.call_store_result(current_result.id, format_choice, store_choice, { extra_arg = complete_path })
                        vim.notify('Output copied to ' .. complete_path, vim.log.levels.INFO)
                      end
                    end)
                  end
                end)
              else
                require('dbee').api.core.call_store_result(current_result.id, format_choice, store_choice, { extra_arg = '+' })
                vim.notify('Output copied to clipboard', vim.log.levels.INFO)
              end
            end)
          end
        end)
      end, { desc = 'Dbee store output' })
    end,
  })
end

return M
