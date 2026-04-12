-- Imports
local sql_helpers = require 'helpers.sql_helpers'
local window_helpers = require 'helpers.create_floating_window'

local M = {}

M.query_state = {
  base_query = nil,
  select = nil,
  where = nil,
  order_by = nil,
}

M.reset_query_state = function()
  M.query_state.select = nil
  M.query_state.where = nil
  M.query_state.order_by = nil
end

-- Helpers
local function url_encode(str)
  str = str:gsub('\n', '')
  str = str:gsub('([^%w%-%.%_%~])', function(c)
    return string.format('%%%02X', string.byte(c))
  end)
  return str
end

local function get_column_name()
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  vim.fn.cursor(1, cursor_position[2])
  vim.fn.search('\\k', 'bcW')
  local column_name = vim.fn.expand '<cword>'

  -- Reset cursor position
  vim.api.nvim_win_set_cursor(0, cursor_position)

  return column_name
end

local function get_final_query()
  local select = M.query_state.select and M.query_state.select or '*'
  local where = M.query_state.where and ' ' .. M.query_state.where or ''
  local order_by = M.query_state.order_by and ' ORDER BY ' .. M.query_state.order_by or ''

  return 'SELECT ' .. select .. ' FROM (' .. M.query_state.base_query .. ') sub' .. where .. '' .. order_by .. ';'
end

local function get_config_template(connection_string)
  local config = {
    ['$schema'] = 'https://pg-language-server.com/latest/schema.json',
    linter = {
      enabled = true,
      rules = {
        recommended = true,
      },
    },
    typecheck = {
      enabled = true,
    },
    plpgsqlCheck = {
      enabled = true,
    },
    db = {
      connectionString = connection_string,
      connTimeoutSecs = 10,
    },
  }

  return vim.json.encode(config)
end

local function store_output()
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
end

-- Exports

local dbee_drawer_window = nil

M.dbee_connection_changed = function(current_connection_name, current_connection_url)
  local previous_connection_url = nil

  if current_connection_name ~= nil and current_connection_url ~= nil and current_connection_url ~= previous_connection_url then
    previous_connection_url = current_connection_url

    if current_connection_name == 'LOCAL' then
      local postgres_lsp_config_path = vim.fn.stdpath 'state' .. '/dbee/notes/global/postgres-language-server.jsonc'
      local fd, err = vim.uv.fs_open(postgres_lsp_config_path, 'w', 0x666)

      if err or fd == nil then
        print('Error creating file: ' .. err)
      else
        -- Write content to the file
        local _, write_err = vim.uv.fs_write(fd, get_config_template(current_connection_url), 0)
        if write_err then
          print('Error writing to file: ' .. write_err)
        end

        -- Restart postgres lsp (not needed since lsp does not work for remote connections)
        -- vim.cmd 'lsp restart postgres_lsp'

        -- Close the file descriptor
        vim.uv.fs_close(fd)
      end
    end

    if dbee_drawer_window ~= nil then
      print('Connection:', current_connection_name)
      vim.wo[dbee_drawer_window].winbar = 'Connection: ' .. current_connection_name
    end
  end
end

M.format_query = function()
  local start_line, end_line = sql_helpers.get_sql_query()

  -- Format the SQL query and get updated range
  sql_helpers.format_sql_query(start_line, end_line)
end

M.setup_autocmd_and_telescope = function()
  -- Telescope entries for connections
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'

  -- Pickers
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
      vim.keymap.set('n', '<leader>sc', db_connections_picker, { desc = 'Dbee search connections' })
      vim.keymap.set('n', '<leader>sn', db_notes_picker, { desc = 'Dbee search notes' })

      vim.keymap.set('n', '<leader>dn', function()
        vim.ui.input({ prompt = 'Enter note name: ' }, function(input)
          if input then
            local new_note = require('dbee').api.ui.editor_namespace_create_note('global', input)
            require('dbee').api.ui.editor_set_current_note(new_note)
          end
        end)
      end, { desc = 'DBee create note' })

      vim.keymap.set('n', '<leader>do', function()
        store_output()
      end, { desc = 'Dbee store output' })

      vim.keymap.set('n', '<leader>dg', function()
        local active_connection = require('dbee').api.core.get_current_connection()

        if active_connection == nil then
          vim.notify('No active connection', vim.log.levels.ERROR)
          return
        end

        local base_query = require('dbee').api.ui.result_get_call().query
        vim.ui.input({ prompt = 'Enter geom column name: ', default = 'geom' }, function(geom)
          if geom then
            local feature_collection_query = "SELECT json_build_object('type', 'FeatureCollection', 'features', json_agg(json_build_object('type', 'Feature', 'geometry', extensions.ST_AsGeoJSON ("
              .. geom
              .. ")::json, 'properties', (to_jsonb (sub) - '"
              .. geom
              .. "')))) FROM ("
              .. base_query
              .. ') sub WHERE sub.'
              .. geom
              .. ' IS NOT NULL;'

            local result = sql_helpers.execute_psql_query(active_connection.url, feature_collection_query)

            local url = 'https://geojson.io/#data=data:application/json,' .. url_encode(result)
            vim.fn.system { 'open', url }
          end
        end)
      end, { desc = 'Visualize geometries' })

      vim.keymap.set('n', '<leader>dh', function()
        local history_file_path = vim.fn.stdpath 'state' .. '/dbee/notes/global/history.sql'
        sql_helpers.save_to_history(history_file_path)
      end, { desc = '[D]atabase save to [H]istory' })

      vim.keymap.set('n', '<leader>di', function()
        local table_name = vim.fn.expand '<cword>'
        if table_name == '' then
          print 'No table name found under cursor'
          return
        end

        local query = sql_helpers.inspect_table_query:gsub('{}', table_name)
        require('dbee').execute(query)
      end, { desc = '[D]atabase [I]nspect Table (dbee)' })

      vim.keymap.set('n', '<leader>dv', function()
        local active_connection = require('dbee').api.core.get_current_connection()
        if active_connection == nil then
          vim.notify('No active connection', vim.log.levels.ERROR)
          return
        end

        local view_name = vim.fn.expand '<cword>'
        if view_name == '' then
          print 'No view name found under cursor'
          return
        end

        local query = "SELECT * FROM pg_catalog.pg_get_viewdef('views." .. view_name .. "', TRUE)"
        local result = sql_helpers.execute_psql_query(active_connection.url, query)
        local result_lines = vim.split(result, '\n')

        window_helpers.create_floating_window {
          content = result_lines,
        }
      end, { desc = '[D]atabase inspect [V]iew' })

      vim.keymap.set('n', '<leader>dk', function()
        local row = vim.fn.search([[^\s*[0-9]\+]], 'bnc', 1)
        if row == 0 then
          error "Couldn't retrieve current row number: row = 0"
        end

        -- Get the line and extract the line number
        local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or ''
        local index = tonumber(line:match '%d+')
        if not index then
          error "couldn't retrieve current row number"
        end

        require('dbee').store('json', 'yank', { from = index - 1, to = index })
        local yanked_json = vim.fn.getreg '"'
        local decoded_table = vim.json.decode(yanked_json)

        local column_name = get_column_name()

        local cell_value = decoded_table[1][column_name]
        local cell_value_string = type(cell_value) == 'string' and cell_value or vim.inspect(cell_value)
        local cell_value_lines = vim.split(cell_value_string, '\n')

        window_helpers.create_floating_window {
          content = cell_value_lines,
        }
      end, { desc = 'Inspect cell value' })

      vim.keymap.set('n', '<leader>ds', function()
        vim.ui.select({ 'ASC', 'DESC' }, {
          prompt = 'Choose sort direction',
        }, function(sort_direction)
          local column_name = get_column_name()

          M.query_state.order_by = column_name .. ' ' .. sort_direction

          require('dbee').execute(get_final_query())
        end)
      end, { desc = 'Sort on column' })

      vim.keymap.set('n', '<leader>df', function()
        local column_name = get_column_name()
        local where_condition = M.query_state.where and M.query_state.where .. ' AND ' .. column_name or 'WHERE ' .. column_name

        vim.ui.input({ prompt = 'Enter filter condition for column: ', default = where_condition }, function(filter_condition)
          if filter_condition then
            M.query_state.where = filter_condition

            require('dbee').execute(get_final_query())
          end
        end)
      end, { desc = 'Filter on column' })

      vim.keymap.set('n', '<leader>dr', function()
        M.reset_query_state()

        require('dbee').execute(M.query_state.base_query)
      end, { desc = 'Reset filters and sorting' })

      vim.keymap.set('n', '<leader>dd', function()
        local header_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
        local columns = {}
        for col in header_line:gmatch '[^│]+' do
          local trimmed = vim.trim(col)
          if trimmed ~= '' then
            table.insert(columns, trimmed)
          end
        end

        local callback = function(new_columns)
          local new_columns_string = table.concat(new_columns, ',')
          M.query_state.select = new_columns_string

          require('dbee').execute(get_final_query())
        end

        window_helpers.create_floating_window { content = columns, callback = callback }
      end, { desc = 'Remove columns' })
    end,
  })
end

return M
