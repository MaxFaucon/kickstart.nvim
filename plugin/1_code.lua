vim.pack.add {
  -- Highlight, edit, and navigate code
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- Lightweight yet powerful formatter plugin for Neovim
  'https://github.com/stevearc/conform.nvim',
  -- A task runner and job management plugin for Neovim
  'https://github.com/stevearc/overseer.nvim',
  -- Autopairs for neovim written in lua
  'https://github.com/windwp/nvim-autopairs',
  -- Smart and powerful comment plugin for neovim.
  'https://github.com/numToStr/Comment.nvim',
}

-- Treesitter
-- ensure basic parser are installed
local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'dockerfile',
  'html',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'php',
  'python',
  'query',
  'sql',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then
    return
  end
  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- enables treesitter based folds
  -- for more info on folds see `:help folds`
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldmethod = 'expr'
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- enable the parser if it is installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function()
        treesitter_try_attach(buf, language)
      end)
    else
      -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { 'eslint_d', stop_after_first = true },
    typescript = { 'eslint_d', stop_after_first = true },
  },
}

require('nvim-autopairs').setup()

-- [[ KEYMAPS [c] ]]
-- Keymaps --
local set = vim.keymap.set
set('n', '<leader>cr', '<cmd>OverseerRun<CR>', { desc = 'Run command from list' })
set('n', '<leader>ct', '<cmd>OverseerToggle<CR>', { desc = 'Toggle commands list' })
set('n', '<leader>cs', '<cmd>OverseerShell<CR>', { desc = 'Run shell command' })
