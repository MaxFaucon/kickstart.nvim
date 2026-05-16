vim.pack.add {
  -- Keymaps helper
  'https://github.com/folke/which-key.nvim',
  -- Status line
  'https://github.com/nvim-lualine/lualine.nvim',
  -- Theme
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  -- Scroll past the end of file just like scrolloff option
  'https://github.com/Aasim-A/scrollEOF.nvim',
  -- Indent guides for Neovim
  'https://github.com/lukas-reineke/indent-blankline.nvim',
}

require('vim._core.ui2').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = {
      [''] = 'msg',
      empty = 'msg',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'cmd',
      echo = 'cmd',
      echomsg = 'cmd',
      echoerr = 'msg',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'cmd',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'pager',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      -- /!\ Also applies on bufwrite
      -- typed_cmd = 'msg',
    },
    -- targets = 'msg',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
}

require('which-key').setup {
  delay = 100,
  preset = 'modern',
  icons = {
    mappings = false,
  },

  -- Document existing key chains
  spec = {
    { '<leader>a', group = '[A]I' },
    { '<leader>b', group = '[B]uffer' },
    { '<leader>c', group = '[C]ode' },
    { '<leader>d', group = '[D]atabase/[D]ebug' },
    { '<leader>g', group = '[G]it' },
    { '<leader>n', group = '[N]eotest' },
    { '<leader>p', group = '[P]erso' },
    { '<leader>q', group = '[Q]uickfix' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>u', group = '[U]I' },
    { '<leader>w', group = '[W]indow' },
    { '<leader>z', group = '[Z]K' },
  },
}

local function show_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then
    return ''
  end
  return 'Recording @' .. reg
end

require('lualine').setup {
  options = {
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        'mode',
      },
    },
    lualine_b = {
      'branch',
      'diff',
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        path = 0, -- Show filename only
        symbols = {
          modified = ' ●',
        },
      },
      'lsp_status',
      'overseer',
      {
        'macro-recording',
        fmt = show_macro_recording,
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype', 'searchcount', 'selectioncount' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

-- Force statusline update on macro events
vim.api.nvim_create_autocmd('RecordingEnter', {
  callback = function()
    require('lualine').refresh { place = { 'statusline' } }
  end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
  callback = function()
    -- Wait 50ms to ensure reg_recording clears before refresh
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        require('lualine').refresh { place = { 'statusline' } }
      end)
    )
  end,
})

require('catppuccin').setup {
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  -- https://github.com/catppuccin/nvim#integrations
  integrations = {
    aerial = true,
    blink_cmp = true,
    dap = true,
    dap_ui = true,
    gitsigns = true,
    lualine = true,
    neogit = true,
    neotest = true,
    overseer = true,
    render_markdown = true,
    treesitter = true,
    telescope = {
      enabled = true,
    },
    which_key = true,
  },
  highlight_overrides = {
    mocha = function(mocha)
      return {
        LineNrAbove = { fg = mocha.overlay2 },
        LineNrBelow = { fg = mocha.overlay2 },
      }
    end,
  },
}
vim.cmd.colorscheme 'catppuccin-nvim'

require('scrollEOF').setup()

require('ibl').setup()

-- [[ KEYMAPS [u] ]]
local map = vim.keymap.set

-- Which key
map('n', '<leader>?', function()
  require('which-key').show { global = false }
end, { desc = 'Buffer Local Keymaps (which-key)' })
