local session_management = require 'tools.session_management'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Enable spelling check in specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt.spelllang = { 'en', 'fr' }
  end,
})

-- Terminal
-- Start in insert mode when opening a terminal
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  pattern = { 'term://*' },
  callback = function()
    vim.cmd.startinsert()
  end,
})

-- Marks
vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Dynamically update global marks when leaving a buffer',
  callback = function()
    local global_marks = vim.fn.getmarklist()
    local user_global_marks = vim.tbl_filter(function(v)
      local mark_name = string.sub(v.mark, 2, 2)

      -- The mark is not a number
      return not mark_name:match '%d'
    end, global_marks)

    if #user_global_marks == 0 then
      return
    end

    local file_path = vim.fn.expand '%:~'
    for _, user_global_mark in ipairs(user_global_marks) do
      if user_global_mark.file == file_path then
        local current_cursor_position = vim.api.nvim_win_get_cursor(0)
        local mark_name = string.sub(user_global_mark.mark, 2, 2)

        vim.api.nvim_buf_set_mark(0, mark_name, current_cursor_position[1], current_cursor_position[2], {})
      end
    end
  end,
})

-- Sessions
vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Save the current project in a session when leaving vim',
  callback = function()
    -- Remove terminal buffers since the process if killed when leaving neovim
    local current_buffers = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(current_buffers) do
      local bt = vim.bo[buffer].buftype
      if bt == 'terminal' then
        vim.api.nvim_buf_delete(buffer, { force = true })
      end
    end

    local project_root = vim.fs.root(0, '.git')
    if project_root ~= nil then
      session_management.save_current_project()
    end
  end,
})

-- Skip session restore for git files
local file = vim.fn.argv(0)
if file:match 'git%-rebase%-todo' or file:match 'COMMIT_EDITMSG' or file:match 'MERGE_MSG' then
  -- don't load session
  return
end

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Source the current project session when entering vim',
  callback = function()
    -- Don't load a session if a file is passed as an argument to nvim
    if vim.fn.argc() > 0 then
      return
    end

    local project_root = vim.fs.root(0, '.git')
    if project_root ~= nil then
      session_management.source_current_project()
      vim.cmd ':filetype detect'
    end
  end,
})
