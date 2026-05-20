local M = {}
local SK = vim.lsp.protocol.SymbolKind

local icons = {
  [SK.Function] = '󰊕 ',
  [SK.Method] = '󰊕 ',
  [SK.Class] = '󰠱 ',
  [SK.Interface] = ' ',
  [SK.Struct] = '󰙅 ',
  [SK.Enum] = ' ',
  [SK.Constructor] = ' ',
}

local function collect_symbols(document_symbols, search_symbols, lines, fns, all_symbols)
  for _, symbol in ipairs(document_symbols) do
    if vim.tbl_contains(search_symbols, symbol.kind) then
      local lnum = symbol.range.start.line + 1
      local line = lines[lnum] or symbol.name

      table.insert(fns, {
        name = symbol.name,
        lnum = lnum,
        icon = icons[symbol.kind] or '',
        line = vim.trim(line),
      })

      if all_symbols == true then
        collect_symbols(symbol.children, search_symbols, lines, fns, all_symbols)
      end
    elseif symbol.children then
      collect_symbols(symbol.children, search_symbols, lines, fns, all_symbols)
    end
  end
end

local function get_level_symbols(callback, search_symbols, all_symbols)
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result)
    if err or not result then
      return
    end

    local fns = {}
    collect_symbols(result, search_symbols, lines, fns, all_symbols)

    callback(fns)
  end)
end

local function pick_symbols(search_symbols, all_symbols)
  get_level_symbols(function(fns)
    vim.schedule(function()
      local filename = vim.api.nvim_buf_get_name(0)

      local max_name_len = 0
      for _, f in ipairs(fns) do
        max_name_len = math.max(max_name_len, #f.name)
      end
      max_name_len = math.min(max_name_len, 50)

      require('helpers.create_picker').create_picker {
        title = 'Functions',
        elements = vim.tbl_map(function(f)
          return {
            display = string.format('%s   %-' .. max_name_len .. 's   %s', f.icon, f.name, f.line),
            value = tostring(f.lnum),
            filename = filename,
            lnum = f.lnum,
          }
        end, fns),
        on_select = function(element)
          vim.api.nvim_win_set_cursor(0, { tonumber(element.value), 0 })
        end,
        layout = {
          position = 'S',
          height = 0.40,
          width = 0.99,
        },
      }
    end)
  end, search_symbols, all_symbols)
end

M.pick_top_level_functions = function()
  pick_symbols({ SK.Function, SK.Method }, false)
end

M.pick_all_functions = function()
  pick_symbols({ SK.Function, SK.Method }, true)
end

M.pick_classes = function()
  pick_symbols({ SK.Class, SK.Interface, SK.Struct, SK.TypeParameter }, true)
end

M.jump_function = function(direction)
  get_level_symbols(function(fns)
    vim.schedule(function()
      local cursor = vim.api.nvim_win_get_cursor(0)[1]

      if direction == 'next' then
        for _, f in ipairs(fns) do
          if f.lnum > cursor then
            vim.api.nvim_win_set_cursor(0, { f.lnum, 0 })
            return
          end
        end
      else
        if direction == 'previous' then
          for i = #fns, 1, -1 do
            if fns[i].lnum < cursor then
              vim.api.nvim_win_set_cursor(0, { fns[i].lnum, 0 })
              return
            end
          end
        end
      end
    end)
  end, { SK.Function, SK.Method }, false)
end

return M
