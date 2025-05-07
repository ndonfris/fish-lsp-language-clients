local M = {}

-- util to format a symbol's range into a string
function M.get_range_string(symbol)
  -- Extract range information
  local start_line = symbol.range.start.line + 1
  local start_char = symbol.range.start.character + 1
  local end_line = symbol.range["end"].line + 1
  local end_char = symbol.range["end"].character + 1

  -- Format range information
  local range_str
  if start_line == end_line then
    range_str = string.format("line %d:%d-%d", start_line, start_char, end_char)
  else
    range_str = string.format("line %d:%d - %d:%d", start_line, start_char, end_line, end_char)
  end
  return range_str
end

-- Create a floating window with document symbols
-- Store window ID in module scope for toggling
local symbols_outline_win_id = nil

function M.document_symbols_outline()
  -- Close window if already open (toggle functionality)
  if symbols_outline_win_id and vim.api.nvim_win_is_valid(symbols_outline_win_id) then
    vim.api.nvim_win_close(symbols_outline_win_id, true)
    symbols_outline_win_id = nil
    return
  end

  --- @diagnostic disable-next-line: missing-parameter
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  --- @diagnostic disable-next-line: param-type-mismatch
  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, _, _)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("No symbols found", vim.log.levels.WARN)
      return
    end

    -- Format symbols for display
    local lines = {}
    local symbol_positions = {}

    local function process_symbols(symbols, level)
      for _, symbol in ipairs(symbols) do
        local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Unknown"
        local indent = string.rep("  ", level)

        local line = string.format("%s%s: %s [%s]", indent, kind, symbol.name, M.get_range_string(symbol))
        table.insert(lines, line)

        -- Store position information for jumping
        local range = symbol.range or symbol.location.range
        symbol_positions[#lines] = {
          line = range.start.line,
          character = range.start.character,
        }

        if symbol.children then
          process_symbols(symbol.children, level + 1)
        end
      end
    end

    process_symbols(result, 0)

    -- Create floating window with symbols
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- Set buffer options
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")

    local width = 80
    local height = math.min(#lines, 20)
    local opts = {
      relative = "editor",
      width = width,
      height = height,
      row = (vim.o.lines - height) / 2,
      col = (vim.o.columns - width) / 2,
      style = "minimal",
      border = "rounded",
      title = " Symbol Outline ",
      title_pos = "center",
    }

    -- Store original window and buffer to return to
    local orig_win = vim.api.nvim_get_current_win()
    -- local orig_buf = vim.api.nvim_get_current_buf()

    -- Store window ID for toggle functionality
    symbols_outline_win_id = vim.api.nvim_open_win(bufnr, true, opts)

    local function close_window()
      vim.api.nvim_win_close(symbols_outline_win_id, true)
      symbols_outline_win_id = nil
      vim.api.nvim_create_augroup("SymbolsOutlineAutoScroll", { clear = true }) -- Clean up autocmd
    end

    -- Enable cursor line highlighting
    -- Set up highlighting for the cursor line
    vim.schedule(function()
      -- Enable cursor line highlighting with explicit window options
      vim.api.nvim_win_set_option(symbols_outline_win_id, "cursorline", true)

      vim.api.nvim_win_set_option(symbols_outline_win_id, "cursorlineopt", "line")

      -- Create a stronger highlight for the outline window
      -- Use win_set_option with proper namespace to ensure it applies to this window
      vim.api.nvim_set_hl(0, "SymbolsOutlineCursorLine", {
        bg = "#4e6cfa",
        bold = true,
        default = false,
      })

      -- Set window-local highlight
      vim.api.nvim_win_set_option(
        symbols_outline_win_id,
        "winhl",
        "CursorLine:SymbolsOutlineCursorLine,lCursor:SymbolsOutlineCursorLine,Cursor:SymbolsOutlineCursorLine,TermCursor:SymbolsOutlineCursorLine,CursorIM:SymbolsOutlineCursorLine"
      )

      -- Force redraw to make highlight visible immediately
      vim.cmd("redraw")
    end)
    vim.api.nvim_win_set_option(symbols_outline_win_id, "winblend", 10)

    -- Create highlight group for symbol line with better visibility
    vim.cmd([[
      highlight SymbolsOutlineCursorLine guibg=#4e6cfa gui=bold
      highlight! link CursorLine SymbolsOutlineCursorLine
    ]])

    -- Function to scroll the original document to the symbol location
    local function scroll_to_symbol()
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local pos = symbol_positions[curr_line]

      if pos and vim.api.nvim_win_is_valid(orig_win) then
        -- Save current view
        local saved_view = vim.fn.winsaveview()

        -- Switch to original window, move cursor, and center view
        local current_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(orig_win)
        vim.api.nvim_win_set_cursor(orig_win, { pos.line + 1, pos.character })
        vim.cmd("normal! zz")

        -- Return to outline window and restore previous position
        vim.api.nvim_set_current_win(current_win)
        vim.fn.winrestview(saved_view)
      end
    end

    -- Set up autocommand to scroll to symbol on cursor movement
    local outline_augroup = vim.api.nvim_create_augroup("SymbolsOutlineAutoScroll", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      buffer = bufnr,
      group = outline_augroup,
      callback = scroll_to_symbol,
    })

    -- Better implementation of the WinLeave autocommand
    --- @diagnostic disable-next-line
    local function setup_winleave_autocmd(bufnr, outline_win_id)
      local outline_leave_augroup = vim.api.nvim_create_augroup("SymbolsOutlineWinLeave", { clear = true })

      -- Use WinLeave with window ID check to be more precise
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          -- Get the window we're leaving
          local leaving_win = vim.api.nvim_get_current_win()

          -- Only close if we're actually leaving the outline window
          -- and not just temporarily switching for preview
          if leaving_win == outline_win_id then
            -- Use vim.schedule to defer the close until after current
            -- operation completes (prevents conflicts with cursor movement)
            vim.schedule(function()
              -- Double-check the window is still valid before closing
              if vim.api.nvim_win_is_valid(outline_win_id) then
                -- Check if focus actually left (not just a temporary switch)
                if vim.api.nvim_get_current_win() ~= outline_win_id then
                  vim.api.nvim_win_close(outline_win_id, true)
                  symbols_outline_win_id = nil
                  vim.api.nvim_create_augroup("SymbolsOutlineWinLeave", { clear = true })
                  vim.api.nvim_create_augroup("SymbolsOutlineAutoGroup", { clear = true })
                end
              end
            end)
          end
        end,
        group = outline_leave_augroup,
      })

      return outline_leave_augroup
    end

    -- Create an autogroup for cursor movement autocommands
    vim.api.nvim_create_augroup("SymbolsOutlineAutoGroup", { clear = true })

    -- Set up WinLeave autocommand separately with proper window ID
    setup_winleave_autocmd(bufnr, symbols_outline_win_id)

    -- Jump to symbol on <CR> and close outline
    vim.keymap.set("n", "<CR>", function()
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local pos = symbol_positions[curr_line]

      if pos then
        vim.api.nvim_win_close(symbols_outline_win_id, true)
        symbols_outline_win_id = nil

        -- Jump to original window and position cursor
        vim.api.nvim_set_current_win(orig_win)
        vim.api.nvim_win_set_cursor(orig_win, { pos.line + 1, pos.character })
        vim.cmd("normal! zz") -- Center view on the cursor
      end
    end, { buffer = bufnr, noremap = true, silent = true })

    --- create the close mappings
    local close_mappings = { "<C-c>", "q", "<Esc>" }
    for _, key in ipairs(close_mappings) do
      vim.keymap.set("n", key, function()
        close_window()
      end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
    end

    -- Set filetype for potential highlighting
    vim.api.nvim_buf_set_option(bufnr, "filetype", "SymbolsOutline")

    -- Initial scroll to first symbol
    vim.schedule(scroll_to_symbol)

    -- Set filetype for potential highlighting
    vim.api.nvim_buf_set_option(bufnr, "filetype", "SymbolsOutline")
  end)
end

return M
