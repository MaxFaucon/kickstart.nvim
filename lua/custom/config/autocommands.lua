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

-- Disable copilot in specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typr',
  callback = function()
    vim.b.copilot_enabled = false
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
