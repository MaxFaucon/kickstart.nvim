local plugins = {
  -- Calculator in buffer
  -- https://github.com/necrom4/calcium.nvim
  {
    'necrom4/calcium.nvim',
    cmd = { 'Calcium' },
    opts = {},
  },
  -- Note taking
  -- https://github.com/zk-org/zk-nvim
  {
    'zk-org/zk-nvim',
    config = function()
      require('zk').setup {
        -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
        -- or select" (`vim.ui.select`).
        picker = 'telescope',

        lsp = {
          -- `config` is passed to `vim.lsp.start(config)`
          config = {
            name = 'zk',
            cmd = { 'zk', 'lsp' },
            filetypes = { 'markdown' },
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start()`
          },

          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
          },
        },
      }
    end,
  },
  {
    'letieu/jira.nvim',
    opts = {
      jira = {
        base = os.getenv 'JIRA_BASE_URL',
        email = os.getenv 'JIRA_EMAIL',
        token = os.getenv 'JIRA_TOKEN',
        type = 'basic', -- Authentication type: "basic" (default) or "pat"
        limit = 200,
      },

      -- Override active sprint query with my tasks query
      active_sprint_query = '(assignee = currentUser() OR assignee WAS currentUser()) AND status NOT IN ("Released", "Cancelled") AND (project = "%s" OR status != "Done") AND updated >= -4w ORDER BY updated DESC',

      queries = {
        ['Active sprint'] = "project = '%s' AND sprint in openSprints() AND assignee = currentUser() ORDER BY Rank ASC",
        ['Next sprint'] = "project = '%s' AND sprint in futureSprints() ORDER BY Rank ASC",
        ['Backlog'] = "project = '%s' AND (issuetype IN standardIssueTypes() OR issuetype = Sub-task) AND (sprint IS EMPTY OR sprint NOT IN openSprints()) AND statusCategory != Done ORDER BY Rank ASC",
        ['My Tasks'] = 'assignee = currentUser() AND statusCategory != Done AND created >= -4w ORDER BY updated DESC',
      },
    },
  },
}

-- Keymaps
local map = vim.keymap.set
-- Calcium (math)
map('n', '<leader>mc', '<cmd>Calcium<cr>', { desc = 'Calculate' })

-- Zk notes
map('n', '<leader>zd', "<cmd>ZkNew { dir = 'journal/daily' }<CR>", { desc = 'Create a daily note' })
map('n', '<leader>zf', "<cmd>ZkNotes { hrefs = { 'learning/' }, sort = { 'modified' } }<CR>", { desc = 'Search notes' })
map('n', '<leader>zl', '<cmd>ZkInsertLink<CR>', { desc = 'Link a note' })

map('n', '<leader>zt', function()
  local tags_input = vim.fn.input 'Tags (comma-separated): '
  if tags_input == '' then
    return
  end

  -- Split by comma and trim whitespace
  local tags = {}
  for tag in tags_input:gmatch '([^,]+)' do
    table.insert(tags, vim.trim(tag))
  end

  require('zk.commands').get 'ZkNotes' { hrefs = { 'learning/' }, tags = tags, sort = { 'modified' } }
end, { noremap = true, silent = false, desc = 'Search notes by tags' })

map('n', '<leader>zn', function()
  require('zk.commands').get 'ZkNew' {
    dir = 'learning',
    title = vim.fn.input 'Title: ',
    extra = {
      tags = vim.fn.input 'Tags (comma-separated): ',
      source = vim.fn.input 'Source: ',
      source_type = vim.fn.input 'Source type (book/article/personal/etc): ',
    },
  }
end, { desc = 'Create a new note' })

return plugins
