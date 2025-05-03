-- no dependency bufferline at top of window
function _G.bufferline()
  local result = {}
  -- Only get buflisted buffers
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  local current_buf = vim.fn.bufnr('%')

  -- Filter out terminal buffers
  local filtered_buffers = {}
  for _, buf in ipairs(buffers) do
    local buftype = vim.api.nvim_buf_get_option(buf.bufnr, 'buftype')
    if buftype ~= 'terminal' then
      table.insert(filtered_buffers, buf)
    end
  end

  -- Add buffer indicators
  for _, buf in ipairs(filtered_buffers) do
    local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":t") or "[No Name]"
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

-- Set the tabline option
vim.opt.showtabline = 2  -- Always show tabline
vim.opt.tabline = "%!v:lua.bufferline()"

-- Add keymaps to navigate buffers
if vim.g.enable_custom_keymaps then
  vim.keymap.set('n', '<leader>bn', ':bnext<CR>', {silent = true})
  vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', {silent = true})
end
