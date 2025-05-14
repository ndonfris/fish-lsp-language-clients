-- Helper functions for hover documentation scrolling
local M = {}

-- Check if a hover window is currently visible
function M.is_hover_visible()
  -- Get all floating windows
  local float_wins = vim.tbl_filter(function(win)
    local config = vim.api.nvim_win_get_config(win)
    return config.relative ~= ""
  end, vim.api.nvim_list_wins())

  -- Check if any are LSP hover windows
  for _, win in ipairs(float_wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "markdown" or ft:match("lsp") then
      return win, buf
    end
  end

  return nil, nil
end

-- Scroll the hover window or use default behavior
function M.scroll_hover(scroll_cmd, default_cmd)
  local hover_win, _ = M.is_hover_visible()

  if hover_win then
    -- Send scroll command to the hover window
    local keystrokes = vim.api.nvim_replace_termcodes(scroll_cmd, true, false, true)
    vim.api.nvim_win_call(hover_win, function()
      vim.cmd("normal! " .. keystrokes)
    end)
  else
    -- Use default scroll behavior
    local keystrokes = vim.api.nvim_replace_termcodes(default_cmd, true, false, true)
    vim.cmd("normal! " .. keystrokes)
  end
end

-- Return the module for reuse
return M
