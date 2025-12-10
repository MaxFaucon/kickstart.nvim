-- https://github.com/kdheepak/lazygit.nvim
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      { 'sindrets/diffview.nvim' }, -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
      -- 'nvim-mini/mini.pick', -- optional
      -- 'folke/snacks.nvim', -- optional
    },
    opts = {
      integrations = { diffview = true },
    },
  },
  {
    'rickhowe/diffchar.vim',
  },
  {
    'isakbm/gitgraph.nvim',
    opts = {
      git_cmd = 'git',
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        on_select_commit = function(commit)
          print('selected commit:', commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print('selected range:', from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        '<leader>gL',
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = 'GitGraph - Draw',
      },
    },
  },
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

        -- Actions
        -- visual mode
        -- map('v', '<leader>hs', function()
        --   gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'git [s]tage hunk' })
        -- map('v', '<leader>hr', function()
        --   gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        -- end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        -- map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        -- map('n', '<leader>gu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        -- map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'git [p]review hunk inline' })
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        -- map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        -- map('n', '<leader>gD', function()
        --   gitsigns.diffthis '@'
        -- end, { desc = 'git [D]iff against last commit' })
      end,
    },
  },
}
