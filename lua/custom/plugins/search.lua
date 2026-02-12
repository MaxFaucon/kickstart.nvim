local plugins = {
  { 'natecraddock/telescope-zf-native.nvim' },
  -- Fuzzy Finder (files, lsp, etc)
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-media-files.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'center',
          layout_config = {
            anchor = 'S',
            height = 0.40,
            width = 0.99,
            preview_cutoff = 1,
          },
        },
        pickers = {
          find_files = {
            hidden = false, -- Show hidden files
            no_ignore = false, -- Don't respect .gitignore
            file_ignore_patterns = { 'vendor/*', 'node_modules/*', '.git/*', '.idea/*' },
          },
        },
        extensions = {
          ['zf-native'] = {
            -- options for sorting file-like items
            file = {
              -- override default telescope file sorter
              enable = true,

              -- highlight matching text in results
              highlight_results = true,

              -- enable zf filename match priority
              match_filename = true,

              -- optional function to define a sort order when the query is empty
              initial_sort = nil,

              -- set to false to enable case sensitive matching
              smart_case = true,
            },

            -- options for sorting all other items
            generic = {
              -- override default telescope generic item sorter
              enable = false,

              -- highlight matching text in results
              highlight_results = true,

              -- disable zf filename match priority
              match_filename = false,

              -- optional function to define a sort order when the query is empty
              initial_sort = nil,

              -- set to false to enable case sensitive matching
              smart_case = true,
            },
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          media_files = {
            filetypes = { 'png', 'jpg', 'jpeg', 'mp4', 'webm', 'mkv' },
            find_cmd = 'rg',
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'media_files')
      pcall(require('telescope').load_extension, 'zf-native')
      pcall(require('telescope').load_extension, 'zk')
    end,
  },
}

-- Keymaps
local map = vim.keymap.set
local builtin = require 'telescope.builtin'
-- Telescope builtin functions
map('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', '<cmd>Telescope keymaps<cr>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', '<cmd>Telescope builtin<cr>', { desc = '[S]earch [S]elect Telescope' })
map('n', '<leader>sw', '<cmd>Telescope grep_string<cr>', { desc = '[S]earch current [W]ord' })
map('n', '<leader>su', '<cmd>Telescope git_status<cr>', { desc = '[S]earch Git Stat[U]s' })
map('n', '<leader>sb', '<cmd>Telescope git_branches<cr>', { desc = '[S]earch Git [B]ranches' })
map('n', '<leader>sp', '<cmd>Telescope spell_suggest<cr>', { desc = '[S]earch S[P]ell Suggest' })
map('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s;', '<cmd>Telescope oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader>si', '<cmd>Telescope lsp_document_symbols<cr>', { desc = '[S]earch [I]n-document Symbols' })

map('n', '<leader><leader>', function()
  builtin.buffers { initial_mode = 'normal', ignore_current_buffer = true, sort_mru = true }
end, { desc = '[ ] Find existing buffers' })

map('n', '<leader>sF', function()
  builtin.find_files {
    find_command = {
      'fd',
      '--type',
      'f',
      '--hidden',
      '--no-ignore',
      '--exclude',
      'node_modules',
      '--exclude',
      '.git',
      '--exclude',
      'vendor',
      '--exclude',
      '.idea',
      '--exclude',
      '.vscode',
    },
  }
end, { desc = '[F]ind [F]iles (all)' })

map('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

map('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

return plugins
