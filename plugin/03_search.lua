vim.pack.add {
  {
    -- FZF sorter for telescope written in c
    src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  },
  -- Variable user customization for telescope.live_grep to set rg flags on-the-fly
  'https://github.com/fdschmidt93/telescope-egrepify.nvim',
  -- Find, Filter, Preview, Pick.
  'https://github.com/nvim-telescope/telescope.nvim',
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end,
})

local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    layout_strategy = 'center',
    layout_config = {
      anchor = 'S',
      height = 0.40,
      width = 0.99,
      preview_cutoff = 1,
    },
    mappings = {
      i = {
        ['<C-f>'] = actions.to_fuzzy_refine,
      },
    },
    file_ignore_patterns = { 'vendor/*', 'node_modules/*', '.git/*', '.idea/*', '_ide_helper_models.php', '_ide_helper.php' },
  },
  pickers = {
    find_files = {
      hidden = false, -- Show hidden files
      no_ignore = false, -- Don't respect .gitignore
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    egrepify = {
      title = true, -- inline filenames instead of section headers
      lnum = true, -- line numbers
      col = true, -- column numbers
      results_ts_hl = true, -- treesitter highlighting in results
      prefixes = {
        ['-'] = {
          flag = 'glob',
          cb = function(input)
            return string.format([[!*{%s}*]], input)
          end,
        },
        ['!'] = {
          flag = 'invert-match',
        },
      },
    },
  },
}

require('telescope').load_extension 'fzf'
require('telescope').load_extension 'ui-select'
require('telescope').load_extension 'zk'
require('telescope').load_extension 'egrepify'

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
map('n', '<leader>sg', '<cmd>Telescope egrepify<cr>', { desc = '[S]earch by [G]rep' })
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
