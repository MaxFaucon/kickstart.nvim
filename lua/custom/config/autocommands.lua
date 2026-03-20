local session_management = require 'custom.config.scripts.session_management'

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

-- Toggleterm navigation config
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }

  vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], opts)

  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd 'autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()'

-- Enable spelling check in specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt.spelllang = { 'en', 'fr' }
  end,
})

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

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Save the current project in a session when leaving vim',
  callback = function()
    local project_root = vim.fs.root(0, '.git')
    if project_root ~= nil then
      session_management.save_current_project()
    end
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Save the current project in a session when leaving vim',
  callback = function()
    local project_root = vim.fs.root(0, '.git')
    if project_root ~= nil then
      session_management.load_current_project()
      vim.cmd ':filetype detect'
    end
  end,
})
