--- The bufferline displayed at the top of the Vim window.

---@diagnostic disable: need-check-nil, cast-local-type
local M = {}

-- Default configuration options
local default_config = {
  always_show_bufferline = true,
  enable_keymaps = false,
  keymaps = {
    next_buffer = '<leader>bn',
    prev_buffer = '<leader>bp'
  }
}

-- Store the active configuration
local config = {}

-- The main bufferline function (now local to the module)
local function get_bufferline()
  local result = {}
  -- Only get buflisted buffers
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local current_buf = vim.fn.bufnr('%')

  -- Filter out terminal buffers, netrw, and unnamed buffers
  local filtered_buffers = {}
  for _, buf in ipairs(buffers) do
    local buftype = vim.api.nvim_buf_get_option(buf.bufnr, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf.bufnr, 'filetype')
    -- Only include buffers that:
    -- 1. Are not terminals
    -- 2. Are not netrw
    -- 3. Have a name (not unnamed)
    -- 4. Don't have special buftypes like nofile, quickfix, etc.
    if buftype ~= 'terminal' and
       buftype ~= 'nofile' and
       buftype ~= 'quickfix' and
       filetype ~= 'netrw' and
       buf.name ~= "" then
      table.insert(filtered_buffers, buf)
    end
  end

  -- Add buffer indicators
  for _, buf in ipairs(filtered_buffers) do
    local name = vim.fn.fnamemodify(buf.name, ":t")
    local modified = buf.changed == 1 and "+" or ""
    local buffer_number = " " .. buf.bufnr .. ": "

    -- Highlight current buffer
    if buf.bufnr == current_buf then
      table.insert(result, "%#TabLineSel#" .. buffer_number .. name .. modified .. " ")
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

-- Apply keymaps based on the configuration
local function setup_keymaps()
  if config.enable_keymaps then
    vim.keymap.set('n', config.keymaps.next_buffer, ':bnext<CR>', {silent = true})
    vim.keymap.set('n', config.keymaps.prev_buffer, ':bprevious<CR>', {silent = true})
  end
end

-- Setup function to initialize the bufferline
function M.setup(user_config)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", default_config, user_config or {})

  -- Set the bufferline function in the global namespace for Vim to access
  _G.bufferline_get_tabline = get_bufferline

  -- Configure the tabline options
  if config.always_show_bufferline then
    vim.opt.showtabline = 2  -- Always show tabline
  end

  -- Set the tabline to use our function
  vim.opt.tabline = "%!v:lua.bufferline_get_tabline()"

  -- Setup keymaps if enabled
  setup_keymaps()
end

-- Return the module
return M
