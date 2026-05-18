vim.pack.add {
  -- A Neovim plugin that provides VSCode-style diff rendering
  'https://github.com/esmuellert/codediff.nvim',
  -- Git integration for buffers
  'https://github.com/lewis6991/gitsigns.nvim',
  -- Git PR reviews, requires gh and gh-dash
  'https://github.com/daliusd/ghlite.nvim',
}

require('ghlite').setup {
  diff_tool = 'codediff',
}

require('codediff').setup {
  diff = {
    layout = 'inline',
  },
  keymaps = {
    conflict = {
      accept_incoming = '<leader>gct',
      accept_current = '<leader>gco',
      accept_both = '<leader>gcb',
      discard = '<leader>gcd',
    },
  },
}

require('gitsigns').setup {
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
    end, { desc = 'Jump to next git change' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git change' })
  end,
}

-- [[ KEYMAPS [g] ]]
local map = vim.keymap.set

-- Gitsigns - Buffer operations
-- normal mode
map('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', { desc = 'git [s]tage hunk' })
map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'git [r]eset hunk' })
map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>', { desc = 'git [S]tage buffer' })
map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', { desc = 'git [R]eset buffer' })
map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { desc = 'git [p]review hunk' })
map('n', '<leader>gi', '<cmd>Gitsigns preview_hunk_inline<cr>', { desc = 'git [p]review hunk inline' })
map('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', { desc = 'git [b]lame line' })
map('n', '<leader>gD', '<cmd>Gitsigns diffthis "@"<cr>', { desc = 'git [D]iff against last commit' })

-- Code diff
map('n', '<leader>gv', '<cmd>CodeDiff<cr>', { desc = 'Open CodeDiff' })
map('n', '<leader>gf', '<cmd>CodeDiff file HEAD<cr>', { desc = 'Git diff current buffer' })
map('n', '<leader>gD', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Diff last commit' })
map('n', '<leader>gH', '<cmd>CodeDiff history %<cr>', { desc = 'File history (current)' })
-- map('n', '<leader>gH', '<cmd>CodeDiff history<cr>', { desc = 'File history (all)' })
map('n', '<leader>gm', '<cmd>CodeDiff origin/main...HEAD<cr>', { desc = 'Diff with main' })

-- GH lite
map('n', '<leader>ghs', '<cmd>GHLite<cr>', { desc = 'PR Select' })
map('n', '<leader>gho', '<cmd>GHLitePRCheckout<cr>', { desc = 'PR Checkout' })
map('n', '<leader>ghv', '<cmd>GHLitePRView<cr>', { desc = 'PR View' })
map('n', '<leader>ghu', '<cmd>GHLitePRLoadComments<cr>', { desc = 'PR Load Comments' })
map('n', '<leader>ghp', '<cmd>GHLitePRDiff<cr>', { desc = 'PR Diff' })
map('n', '<leader>ghl', '<cmd>GHLitePRDiffview<cr>', { desc = 'PR Diffview' })
map('n', '<leader>gha', '<cmd>GHLitePRAddComment<cr>', { desc = 'PR Add comment' })
map('x', '<leader>gha', '<cmd>GHLitePRAddComment<cr>', { desc = 'PR Add comment' })
map('n', '<leader>ghc', '<cmd>GHLitePRUpdateComment<cr>', { desc = 'PR Update comment' })
map('n', '<leader>ghd', '<cmd>GHLitePRDeleteComment<cr>', { desc = 'PR Delete comment' })
map('n', '<leader>ghg', '<cmd>GHLitePROpenComment<cr>', { desc = 'PR Open comment' })
