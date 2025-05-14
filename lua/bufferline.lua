--- The bufferline displayed at the top of the Vim window.

---@class BufferlineHighlightConfig
---@field fg? string # Foreground color for the highlight group (e.g. "#ff9e64")
---@field bg? string # Background color for the highlight group
---@field bold? boolean # Whether to make the text bold
---@field italic? boolean # Whether to make the text italic
---@field underline? boolean # Whether to add an underline

---@class BufferlineHighlights
---@field modified BufferlineHighlightConfig # Highlight configuration for the modified indicator

---@class BufferlineKeymaps
---@field next_buffer string # Keymap for navigating to the next buffer
---@field prev_buffer string # Keymap for navigating to the previous buffer
---@field enable_number_jump? boolean # Whether to enable jump-to-index keymaps
---@field number_jump_prefix? string # Prefix for number-based jumps (default: '<leader><leader>')

---@class BufferlineConfig
---@field always_show_bufferline? boolean # Whether to always show the bufferline (default: true)
---@field enable_keymaps? boolean # Whether to enable the default keymaps (default: false)
---@field keymaps? BufferlineKeymaps # Configuration for keymaps
---@field highlights? BufferlineHighlights # Configuration for highlight groups

---@diagnostic disable: need-check-nil, cast-local-type

local M = {}

-- Default configuration options
---@type BufferlineConfig
local default_config = {
  always_show_bufferline = true,
  enable_keymaps = true,
  keymaps = {
    next_buffer = '<leader>bn',
    prev_buffer = '<leader>bp',
    enable_number_jump = true,      -- Enable/disable jump-to-index feature
    number_jump_prefix = '<leader>' -- Prefix for number-based jumps
  },
  highlights = {
    modified = {
      fg = "#00ff00", -- Default to a reddish color for modified indicator
      bold = true     -- Make it bold by default
    }
  }
}

-- Store the active configuration
local config = {}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                        the local functions                              ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Add these functions to your module
local function get_filtered_buffers()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local filtered_buffers = {}

  for _, buf in ipairs(buffers) do
    local buftype = vim.api.nvim_buf_get_option(buf.bufnr, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf.bufnr, 'filetype')

    if buftype ~= 'terminal' and
        buftype ~= 'nofile' and
        buftype ~= 'quickfix' and
        filetype ~= 'netrw' and
        buf.name ~= "" then
      table.insert(filtered_buffers, buf)
    end
  end

  return filtered_buffers
end

-- The main bufferline function
local function get_bufferline()
  local result = {}
  -- Only get buflisted buffers
  -- local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local current_buf = vim.fn.bufnr('%')

  -- Filter out terminal buffers, netrw, and unnamed buffers
  local filtered_buffers = get_filtered_buffers()

  -- Add buffer indicators
  for idx, buf in ipairs(filtered_buffers) do
    local name = vim.fn.fnamemodify(buf.name, ":t")
    local modified = buf.changed == 1 and " %#BufferlineModified#+" or ""
    local buffer_number = " " .. idx .. ": "

    -- Highlight current buffer
    if buf.bufnr == current_buf then
      table.insert(result, "%#TabLineSel#|" .. buffer_number .. name .. modified .. " %#TabLineSel#|")
    else
      table.insert(result, "%#TabLine#" .. buffer_number .. name .. modified .. " ")
    end
  end

  -- Add a spacer
  table.insert(result, "%#TabLineFill#%=")

  -- Add a total count of buffers
  table.insert(result, "%#TabLine#" .. " " .. #filtered_buffers .. " buffers ")

  return table.concat(result)
end

--- Set up highlight groups
local function setup_highlights()
  -- Create highlight group for modified indicators
  local modified_hl = config.highlights.modified
  local cmd = "highlight BufferlineModified"

  if modified_hl.fg then
    cmd = cmd .. " guifg=" .. modified_hl.fg
  end

  if modified_hl.bg then
    cmd = cmd .. " guibg=" .. modified_hl.bg
  end

  local attributes = {}
  if modified_hl.bold then table.insert(attributes, "bold") end
  if modified_hl.italic then table.insert(attributes, "italic") end
  if modified_hl.underline then table.insert(attributes, "underline") end

  if #attributes > 0 then
    cmd = cmd .. " gui=" .. table.concat(attributes, ",")
  end

  vim.cmd(cmd)
end

--- setup the users keymaps
local function setup_keymaps()
  if config.enable_keymaps then
    -- Previous keymaps
    vim.keymap.set('n', config.keymaps.next_buffer, function() M.next_buffer() end, { silent = true, desc = 'jump to next buffer' })
    vim.keymap.set('n', config.keymaps.prev_buffer, function() M.prev_buffer() end, { silent = true, desc = 'jump to prev buffer' })

    -- For number jump keymaps, use the hidden option
    if config.keymaps.enable_number_jump then
      -- Create a group name for the documentation
      local prefix = config.keymaps.number_jump_prefix
      local has_which_key = pcall(require, "which-key")

      if has_which_key then
        local wk = require("which-key")

        -- add single group
        wk.add({
          { prefix .. '#', desc = 'jump to buffer # (1-9)' }
        })

        -- Hide all the numeric keymaps from which-key
        for i = 1, 9 do
          wk.add({
            { prefix .. i, hidden = true }
          })
        end
      end

      -- Still create the actual keymaps for functionality
      for i = 1, 9 do
        vim.keymap.set('n', prefix .. i, function()
          M.jump_to_buffer(i)
        end, {
          silent = true,
        })
      end
    end
  end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---               the functions to export from the module                   ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--- Navigate to the next buffer in the bufferline.
--- Wraps around to the first buffer if at the end.
function M.next_buffer()
  local filtered_buffers = get_filtered_buffers()
  local current_buf = vim.fn.bufnr('%')
  local next_buf = nil

  -- If no filtered buffers, do nothing
  if #filtered_buffers == 0 then
    return
  end

  -- Find the current buffer in the filtered list
  local current_index = nil
  for i, buf in ipairs(filtered_buffers) do
    if buf.bufnr == current_buf then
      current_index = i
      break
    end
  end

  -- Determine the next buffer index (with wrap-around)
  if current_index then
    -- If we're at the last buffer, wrap to the first
    if current_index == #filtered_buffers then
      next_buf = filtered_buffers[1].bufnr
    else
      next_buf = filtered_buffers[current_index + 1].bufnr
    end
  else
    -- If current buffer isn't in the filtered list, go to the first one
    next_buf = filtered_buffers[1].bufnr
  end

  -- Switch to the next buffer
  if next_buf then
    vim.api.nvim_set_current_buf(next_buf)
  end
end

--- Navigate to the previous buffer in the bufferline.
--- Wraps around to the last buffer if at the beginning.
function M.prev_buffer()
  local filtered_buffers = get_filtered_buffers()
  local current_buf = vim.fn.bufnr('%')
  local prev_buf = nil

  -- If no filtered buffers, do nothing
  if #filtered_buffers == 0 then
    return
  end

  -- Find the current buffer in the filtered list
  local current_index = nil
  for i, buf in ipairs(filtered_buffers) do
    if buf.bufnr == current_buf then
      current_index = i
      break
    end
  end

  -- Determine the previous buffer index (with wrap-around)
  if current_index then
    -- If we're at the first buffer, wrap to the last
    if current_index == 1 then
      prev_buf = filtered_buffers[#filtered_buffers].bufnr
    else
      prev_buf = filtered_buffers[current_index - 1].bufnr
    end
  else
    -- If current buffer isn't in the filtered list, go to the last one
    prev_buf = filtered_buffers[#filtered_buffers].bufnr
  end

  -- Switch to the previous buffer
  if prev_buf then
    vim.api.nvim_set_current_buf(prev_buf)
  end
end

--- Jump directly to a buffer by its index in the bufferline.
---@param index number # The index of the buffer to jump to (1-based)
function M.jump_to_buffer(index)
  local filtered_buffers = get_filtered_buffers()

  -- Check if the index is valid
  if index > 0 and index <= #filtered_buffers then
    local target_buf = filtered_buffers[index].bufnr
    vim.api.nvim_set_current_buf(target_buf)
  end
end

--- Setup the bufferline with the given configuration.
---
--- Example:
--- ```lua
--- require('bufferline').setup({
---   always_show_bufferline = true,
---   enable_keymaps = true,
---   keymaps = {
---     next_buffer = '<Tab>',
---     prev_buffer = '<S-Tab>',
---     enable_number_jump = true,
---     number_jump_prefix = '<leader>'
---   },
---   highlights = {
---     modified = {
---       fg = "#ff9e64",
---       bold = true,
---       italic = true
---     }
---   }
--- })
--- ```
---@param user_config? BufferlineConfig # User configuration table to override defaults
function M.setup(user_config)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", default_config, user_config or {})

  -- Set the bufferline function in the global namespace for Vim to access
  _G.bufferline_get_tabline = get_bufferline

  -- Configure the tabline options
  if config.always_show_bufferline then
    vim.opt.showtabline = 2 -- Always show tabline
  end

  -- Set the tabline to use our function
  vim.opt.tabline = "%!v:lua.bufferline_get_tabline()"

  -- Set up highlights
  setup_highlights()

  -- Setup keymaps if enabled
  setup_keymaps()
end

-- Return the module
return M
