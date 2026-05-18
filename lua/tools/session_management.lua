local create_picker = require 'helpers.create_picker'
local M = {}

local last_session_path = nil

local function get_current_session_path()
  local project_root = vim.fs.root(0, '.git')
  if project_root == nil then
    vim.notify('No git project root', vim.log.levels.WARN)
    return ''
  end

  local project_root_name = vim.fn.fnamemodify(project_root, ':t')
  local session_name = project_root_name .. '.vim'

  return vim.fn.stdpath 'state' .. '/sessions/' .. session_name
end

M.save_current_project = function()
  local session_name_path = get_current_session_path()

  vim.cmd(':mksession! ' .. session_name_path)
end

M.delete_current_project_session = function()
  local session_name_path = get_current_session_path()

  local session_exists = vim.fn.filereadable(session_name_path)
  if session_exists == 1 then
    os.remove(session_name_path)
  end
end

M.source_current_project = function()
  local session_name_path = get_current_session_path()

  local session_exists = vim.fn.filereadable(session_name_path)
  if session_exists == 0 then
    M.save_current_project()
  else
    vim.cmd(':source ' .. session_name_path)
  end
end

M.switch_project = function(session_path)
  M.save_current_project()

  local current_buffers = vim.api.nvim_list_bufs()
  for _, buffer in ipairs(current_buffers) do
    local bt = vim.bo[buffer].buftype
    if bt ~= 'terminal' and vim.bo[buffer].buflisted then
      vim.api.nvim_buf_delete(buffer, {})
    end
  end

  last_session_path = get_current_session_path()
  vim.cmd(':source ' .. session_path)
end

M.switch_last_project = function()
  if last_session_path == nil then
    vim.notify('No last project', vim.log.levels.WARN)
  else
    M.switch_project(last_session_path)
  end
end

M.sessions_picker = function()
  local sessions_path = vim.fn.stdpath 'state' .. '/sessions/'
  local sessions = vim.fn.globpath(sessions_path, '*', false, true)
  local session_names = vim.tbl_map(function(session_path)
    return { value = session_path, display = vim.fn.fnamemodify(session_path, ':t:r') }
  end, sessions)

  create_picker.create_picker {
    title = 'Project sessions picker',
    elements = session_names,
    on_select = function(value)
      M.switch_project(value)
    end,
  }
end

return M
