local M = {}

-- Common keymap options
M.default_opts = { noremap = true, silent = true }
M.expr_opts = { expr = true, noremap = true, silent = true }

-- Helper function for completion menu
function M.completion_handler()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    -- Try to trigger LSP completion first
    if vim.lsp.buf.completion_list_available and vim.lsp.get_active_clients({ bufnr = 0 })[1] then
      return vim.lsp.buf.completion()
    else
      -- Fall back to omnifunc or regular completion
      return vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, true, true), 'n')
    end
  end
end

-- Helper function to create repeated keystrokes
local function repeat_key(key, count)
  local result = ""
  for _ = 1, count do
    result = result .. key
  end
  return vim.api.nvim_replace_termcodes(result, true, true, true)
end

-- Helper for conditional popup menu commands
local function popup_or_default(popup_cmd, default_cmd)
  if vim.fn.pumvisible() == 1 then
    return popup_cmd
  else
    return default_cmd
  end
end

function M.c_u_insert_scroll()
    return popup_or_default(repeat_key('<C-p>', 10), '<C-u>')
end

function M.c_d_insert_scroll()
    return popup_or_default(repeat_key('<C-n>', 10), '<C-d>')
end

return M
-- Map completion trigger keys
--- vim.keymap.set('i', '<C-Space>', completion_handler, expr_opts)
--- vim.keymap.set('i', '<C-@>', completion_handler, expr_opts)
---
--- -- Map movement in completion menu
--- vim.keymap.set('i', '<C-j>', '<C-n>', default_opts)
--- vim.keymap.set('i', '<C-k>', '<C-p>', default_opts)
---
--- -- Map scrolling in completion menu
--- vim.keymap.set('i', '<C-d>', function()
---   return popup_or_default(repeat_key('<C-n>', 10), '<C-d>')
--- end, expr_opts)
---
--- vim.keymap.set('i', '<C-u>', function()
---   return popup_or_default(repeat_key('<C-p>', 10), '<C-u>')
--- end, expr_opts)
