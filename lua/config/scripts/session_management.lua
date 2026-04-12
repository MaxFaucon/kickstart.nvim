local M = {}

M.save_current_project = function()
  local project_root = vim.fs.root(0, '.git')
  if project_root == nil then
    vim.notify('No git project root', vim.log.levels.WARN)
    return
  end

  local project_root_name = vim.fn.fnamemodify(project_root, ':t')
  local session_name = project_root_name .. '.vim'
  local session_name_path = vim.fn.stdpath 'state' .. '/sessions/' .. session_name

  vim.cmd(':mksession! ' .. session_name_path)
end

M.load_current_project = function()
  local project_root = vim.fs.root(0, '.git')
  if project_root == nil then
    vim.notify('No git project root', vim.log.levels.WARN)
    return
  end

  local project_root_name = vim.fn.fnamemodify(project_root, ':t')
  local session_name = project_root_name .. '.vim'
  local session_name_path = vim.fn.stdpath 'state' .. '/sessions/' .. session_name

  local session_exists = vim.fn.filereadable(session_name_path)
  if session_exists == 0 then
    M.save_current_project()
  else
    vim.cmd(':source ' .. session_name_path)
  end
end

M.sessions_picker = function()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'

  local sessions_path = vim.fn.stdpath 'state' .. '/sessions/'
  local sessions = vim.fn.globpath(sessions_path, '*', false, true)
  local session_names = vim.tbl_map(function(session_path)
    return { path = session_path, name = vim.fn.fnamemodify(session_path, ':t:r') }
  end, sessions)

  pickers
    .new({}, {
      prompt_title = 'Project sessions picker',
      initial_mode = 'insert',
      layout_config = {
        anchor = 'CENTER',
        height = 0.5,
        width = 0.5,
      },
      finder = finders.new_table {
        results = session_names,
        entry_maker = function(entry)
          return {
            value = entry.path,
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

          M.save_current_project()
          vim.cmd '%bd'
          vim.cmd(':source ' .. selection.value)
        end)

        return true -- Retain default keymaps
      end,
    })
    :find()
end

return M
