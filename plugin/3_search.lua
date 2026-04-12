vim.pack.add {
  {
    src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  'https://github.com/nvim-telescope/telescope.nvim',
}

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
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'media_files')
pcall(require('telescope').load_extension, 'zf-native')
pcall(require('telescope').load_extension, 'zk')

-- [[ KEYMAPS [s] ]]
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
map('n', '<leader>sS', '<cmd>Telescope spell_suggest<cr>', { desc = '[S]earch [S]pell Suggest' })
map('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s;', '<cmd>Telescope oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader>si', '<cmd>Telescope lsp_document_symbols<cr>', { desc = '[S]earch [I]n-document Symbols' })

map('n', '<leader>sm', function()
  builtin.marks {
    mark_type = 'global',
    entry_maker = function(entry)
      local first_line_char = string.sub(entry.line, 1, 1)
      local is_number_mark = first_line_char:match '%d'

      if is_number_mark then
        return
      end

      return {
        value = first_line_char,
        display = entry.line,
        ordinal = entry.line,
      }
    end,
  }
end, { desc = '[S]earch Global [M]arks' })

map('n', '<leader>se', function()
  builtin.buffers { initial_mode = 'normal', ignore_current_buffer = true, sort_mru = true }
end, { desc = 'Search existing buffers' })

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

map('n', '<leader>s/', function()
  builtin.current_buffer_fuzzy_find()
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>sC', function()
  builtin.find_files { hidden = true, search_dirs = { vim.fn.expand '~' .. '/.zshrc.local', vim.fn.expand '~' .. '/dotfiles' } }
end, { desc = '[S]earch [C]onfig files' })

map('n', '<leader>sP', function()
  builtin.find_files { cwd = vim.fn.expand '~' .. '/Documents/projects' }
end, { desc = '[S]earch [P]roject files' })
