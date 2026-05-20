local M = {}

---@class Element The picker elements
---@field value string The picker element value
---@field display string The picker element to display
---@field additional_data? string Any additional information to add on the picker element
---@field filename string? The filename (used for preview)
---@field lnum integer? The line number in the file (used for preview)

---@alias Position "CENTER"|"NW"|"N"|"NE"|"E"|"SE"|"S"|"SW"|"W"
---@class Layout The picker layout
---@field position Position The position of the picker on the screen
---@field height integer The height of the picker (between 0 and 1)
---@field width integer The width of the picker (between 0 and 1)

---@alias InitialMode "insert"|"normal"
---@class PickerOptions
---@field title string The picker title
---@field elements Element[] The picker elements
---@field on_select fun(element: Element) Callback when an element is selected
---@field mappings? table<string, fun(bufnr: integer)> Extra mappings (key -> handler)
---@field layout? Layout The picker layout options
---@field initial_mode? InitialMode The picker initial mode

---@param options PickerOptions The picker options
M.create_picker = function(options)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values

  if options.layout == nil then
    options.layout = {
      position = 'CENTER',
      height = 0.5,
      width = 0.5,
    }
  end

  if options.initial_mode == nil then
    options.initial_mode = 'insert'
  end

  local needs_preview = vim.iter(options.elements):all(function(e)
    return e.filename and e.lnum
  end)

  pickers
      .new({}, {
        prompt_title = options.title,
        previewer = needs_preview and conf.grep_previewer {} or nil,
        initial_mode = options.initial_mode,
        layout_config = {
          anchor = options.layout.position,
          height = options.layout.height,
          width = options.layout.width,
        },
        finder = finders.new_table {
          results = options.elements,
          entry_maker = function(entry)
            return {
              value = entry.value,
              display = entry.display,
              ordinal = entry.display,
              additional_data = entry.additional_data,
              filename = entry.filename,
              lnum = entry.lnum,
            }
          end,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(bufnr, map)
          map({ 'i', 'n' }, '<CR>', function()
            local selection = require('telescope.actions.state').get_selected_entry()
            require('telescope.actions').close(bufnr)

            options.on_select(selection)
          end)

          if options.mappings then
            for key, handler in pairs(options.mappings) do
              map({ 'i', 'n' }, key, function()
                local selection = require('telescope.actions.state').get_selected_entry()
                require('telescope.actions').close(bufnr)

                handler(selection.value)
              end)
            end
          end
          return true
        end,
      })
      :find()
end

return M
