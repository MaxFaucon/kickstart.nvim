local plugins = {
  -- https://github.com/NeogitOrg/neogit
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'esmuellert/codediff.nvim',

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
      -- 'nvim-mini/mini.pick', -- optional
      -- 'folke/snacks.nvim', -- optional
    },
    opts = {
      integrations = { telescope = true, codediff = true },
      graph_style = 'kitty',
    },
  },
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })
      end,
    },
  },
  -- https://github.com/esmuellert/codediff.nvim
  {
    'esmuellert/codediff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    config = function()
      require('codediff').setup {
        keymaps = {
          conflict = {
            accept_incoming = '<leader>gct',
            accept_current = '<leader>gco',
            accept_both = '<leader>gcb',
            discard = '<leader>gcd',
          },
        },
      }
    end,
  },
  -- PR management
  -- https://github.com/pwntester/octo.nvim
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    opts = {
      -- or "fzf-lua" or "snacks" or "default"
      picker = 'telescope',
      -- bare Octo command opens picker of commands
      enable_builtin = true,
      use_local_fs = true,
    },
    keys = {
      {
        '<leader>goo',
        '<CMD>Octo<CR>',
        desc = 'Open Octo menu',
      },
      {
        '<leader>gop',
        '<CMD>Octo pr list<CR>',
        desc = 'List GitHub PullRequests',
      },
      {
        '<leader>gor',
        '<CMD>Octo review start<CR>',
        desc = 'Start code review',
      },
      {
        '<leader>gon',
        '<CMD>Octo notification list<CR>',
        desc = 'List GitHub Notifications',
      },
      {
        '<leader>os',
        function()
          require('octo.utils').create_base_search_command { include_current_repo = true }
        end,
        desc = 'Search GitHub',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- OR "ibhagwan/fzf-lua",
      -- OR "folke/snacks.nvim",
      'nvim-tree/nvim-web-devicons',
    },
  },
}

-- Keymaps
local map = vim.keymap.set
-- Neogit - Core operations
map('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit status' })
map('n', '<leader>gc', '<cmd>Neogit commit<cr>', { desc = 'Git commit' })
map('n', '<leader>gp', '<cmd>Neogit push<cr>', { desc = 'Git push' })
map('n', '<leader>gP', '<cmd>Neogit pull<cr>', { desc = 'Git pull' })
map('n', '<leader>gB', '<cmd>Neogit branch<cr>', { desc = 'Git branches' })
map('n', '<leader>gl', '<cmd>Neogit log<cr>', { desc = 'Git log' })

-- Gitsigns - Buffer operations
-- normal mode
map('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', { desc = 'git [s]tage hunk' })
map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'git [r]eset hunk' })
map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>', { desc = 'git [S]tage buffer' })
map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', { desc = 'git [R]eset buffer' })
map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { desc = 'git [p]review hunk' })
map('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<cr>', { desc = 'git [p]review hunk inline' })
map('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', { desc = 'git [b]lame line' })
-- map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
map('n', '<leader>gD', '<cmd>Gitsigns diffthis "@"<cr>', { desc = 'git [D]iff against last commit' })

-- Code diff
map('n', '<leader>gv', '<cmd>CodeDiff<cr>', { desc = 'Open CodeDiff' })
map('n', '<leader>gf', '<cmd>CodeDiff file HEAD<cr>', { desc = 'Git diff current buffer' })
map('n', '<leader>gD', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Diff last commit' })
map('n', '<leader>gh', '<cmd>CodeDiff history %<cr>', { desc = 'File history (current)' })
map('n', '<leader>gH', '<cmd>CodeDiff history<cr>', { desc = 'File history (all)' })
map('n', '<leader>gm', '<cmd>CodeDiff origin/main...HEAD<cr>', { desc = 'Diff with main' })

return plugins
