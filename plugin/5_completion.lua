vim.pack.add {
  -- To have copilot suggestion in blink
  'https://github.com/giuxtaposition/blink-cmp-copilot',
  -- Snippet Engine for Neovim written in Lua.
  {
    src = 'https://github.com/L3MON4D3/LuaSnip',
  },
  -- Set of preconfigured snippets for different languages.
  'https://github.com/rafamadriz/friendly-snippets',
  -- Performant, batteries-included completion plugin for Neovim
  {
    src = 'https://github.com/Saghen/blink.cmp',
    version = '1.*',
  },
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'blink.cmp' then
      vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
    end
    if ev.data.spec.name == 'LuaSnip' then
      if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
        vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path })
      end
    end
  end,
})

-- Blink
require('blink.cmp').setup {
  keymap = {
    preset = 'default',

    ['<C-k>'] = false, -- Disable the default signature help keymap
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    ghost_text = { enabled = true },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'copilot' },
    per_filetype = {
      sql = { 'lsp', 'snippets', 'buffer' },
    },
    providers = {
      copilot = {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        score_offset = 100,
        async = true,
      },
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },

  snippets = { preset = 'luasnip' },

  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = {
      force_version = 'v1.10.2',
    },
    sorts = {
      'score',
      function(a, b)
        local kinds = require('blink.cmp.types').CompletionItemKind
        local priority = {
          [kinds.Keyword] = 1, -- SQL keywords
          [kinds.Class] = 2, -- Tables
          [kinds.Field] = 3, -- Columns
          [kinds.Module] = 4, -- Schemas
          [kinds.Function] = 5, -- SQL functions
          [kinds.Variable] = 6, -- Aliases
        }

        local a_priority = priority[a.kind] or 99
        local b_priority = priority[b.kind] or 99

        if a_priority ~= b_priority then
          return a_priority < b_priority
        else
          -- Fallback to score comparison if priorities are equal
          return a.score > b.score
        end
      end,
      'sort_text',
      'exact',
    },
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

-- Snippets
require('luasnip.loaders.from_lua').load {
  paths = { '~/.config/nvim/lua/custom/config/snippets' },
}

local ls = require 'luasnip'
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)
