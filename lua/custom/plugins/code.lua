local plugins = {
  -- Highlight, edit, and navigate code
  -- https://github.com/nvim-treesitter/nvim-treesitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
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

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
    end,
  },
  -- https://github.com/stevearc/overseer.nvim?tab=readme-ov-file#guides
  {
    'stevearc/overseer.nvim',
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
  },
  -- https://github.com/windwp/nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  -- Handle code comment
  -- https://github.com/numToStr/Comment.nvim
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },
  -- Highlight todo, notes, etc in comments
  -- https://github.com/folke/todo-comments.nvim
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}

-- Keymaps --
local set = vim.keymap.set
set('n', '<leader>rr', '<cmd>OverseerRun<CR>', { desc = 'Run Overseer' })
set('n', '<leader>rt', '<cmd>OverseerToggle<CR>', { desc = 'Toggle Overseer' })
set('n', '<leader>rs', '<cmd>OverseerShell<CR>', { desc = 'Shell Overseer' })

return plugins
