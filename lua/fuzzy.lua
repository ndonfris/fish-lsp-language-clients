-- small utility I wrote for finding files (like telescope or fzf)
-- Mostly boilerplate for popup & keymaps
-- Opens via `<C-space>`/`<leader>ff` for finding files
-- Opens via `<leader>fb` for finding buffers

-- fuzzy.lua - A lightweight interactive fuzzy finder for Neovim

local api = vim.api
local fn = vim.fn
local M = {}

-- Fuzzy match scoring function
function M.score(str, query)
  if query == "" then
    return 100
  end

  str, query = str:lower(), query:lower()
  local score, str_i, query_i, consecutive = 0, 1, 1, 0

  while query_i <= #query and str_i <= #str do
    if query:sub(query_i, query_i) == str:sub(str_i, str_i) then
      query_i = query_i + 1
      consecutive = consecutive + 1
      score = score + (consecutive * 2) -- Bonus for consecutive matches
    else
      consecutive = 0
    end
    str_i = str_i + 1
  end

  -- If we matched all query chars
  if query_i > #query then
    score = score + (100 - str_i) / 10 -- Bonus for matches closer to start
    return score
  end

  return nil -- No match
end

-- Create floating windows for UI
function M.create_windows()
  -- Main results window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 3)

  local results_buf = api.nvim_create_buf(false, true)
  local results_win = api.nvim_open_win(results_buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Results ",
    title_pos = "center",
  })

  -- Input window (below results window)
  local input_buf = api.nvim_create_buf(false, true)
  local input_win = api.nvim_open_win(input_buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    row = row + height + 1,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Search ",
    title_pos = "center",
  })

  -- Set buffer options
  api.nvim_buf_set_option(results_buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(input_buf, "bufhidden", "wipe")

  -- Disable completion in the input buffer
  api.nvim_buf_set_option(input_buf, "omnifunc", "")
  api.nvim_buf_set_option(input_buf, "completefunc", "")

  -- Disable other completion-related options
  vim.bo[input_buf].complete = ""
  vim.bo[input_buf].completeopt = ""

  return {
    results = { buf = results_buf, win = results_win, height = height },
    input = { buf = input_buf, win = input_win },
  }
end

-- Update the display with filtered items
function M.update_display(state)
  -- Clear buffer
  api.nvim_buf_set_lines(state.windows.results.buf, 0, -1, false, {})

  -- Add filtered items
  local lines = {}
  for i, item in ipairs(state.filtered_items) do
    if i > state.windows.results.height then
      break
    end

    if i == state.selected then
      table.insert(lines, "> " .. item)
    else
      table.insert(lines, "  " .. item)
    end
  end

  -- Show "No matches" message if no results
  if #lines == 0 then
    table.insert(lines, "  No matches found")
  end

  api.nvim_buf_set_lines(state.windows.results.buf, 0, -1, false, lines)

  -- Highlight selected item
  if state.selected <= #state.filtered_items and #state.filtered_items > 0 then
    api.nvim_buf_add_highlight(state.windows.results.buf, -1, "PmenuSel", state.selected - 1, 0, -1)
  end

  -- Highlight matched characters in each result
  if state.query ~= "" then
    local query = state.query:lower()

    for line_num, item in ipairs(state.filtered_items) do
      if line_num > state.windows.results.height then
        break
      end

      local item_lower = item:lower()
      local query_idx = 1

      for i = 1, #item_lower do
        if query_idx <= #query and item_lower:sub(i, i) == query:sub(query_idx, query_idx) then
          api.nvim_buf_add_highlight(
            state.windows.results.buf,
            -1,
            "IncSearch",
            line_num - 1,
            i + 1,
            i + 2 -- +2 for the prefix "  " or "> "
          )
          query_idx = query_idx + 1
        end
      end
    end
  end
end

-- Filter and sort items based on query
function M.filter_items(items, query)
  if query == "" then
    return items
  end

  local results = {}

  for _, item in ipairs(items) do
    local score = M.score(item, query)
    if score then
      table.insert(results, { item = item, score = score })
    end
  end

  table.sort(results, function(a, b)
    return a.score > b.score
  end)

  local filtered = {}
  for _, result in ipairs(results) do
    table.insert(filtered, result.item)
  end

  return filtered
end

-- Main fuzzy finder function
function M.fuzzy_find(items, opts)
  opts = opts or {}
  opts.prompt = opts.prompt or "> "
  opts.on_select = opts.on_select or function(selected)
    print("Selected: " .. selected)
  end

  -- Create windows
  local windows = M.create_windows()

  -- Set up initial state
  local state = {
    items = items,
    filtered_items = items,
    query = "",
    selected = 1,
    windows = windows,
  }

  -- Display initial state
  M.update_display(state)

  -- Set prompt
  api.nvim_buf_set_lines(windows.input.buf, 0, -1, false, { opts.prompt })

  -- close the popup
  local function close_action()
    vim.cmd("stopinsert")
    -- Exit insert mode by feeding an Escape key
    --- @diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

    api.nvim_win_close(windows.input.win, true)
    api.nvim_win_close(windows.results.win, true)
  end

  -- Helper function to select item with specified action
  local function select_with_action(action)
    if #state.filtered_items > 0 and state.selected <= #state.filtered_items then
      local selected = state.filtered_items[state.selected]

      -- Exit insert mode via feedkeys
      --- @diagnostic disable-next-line: param-type-mismatch
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

      -- Close the windows
      api.nvim_win_close(windows.input.win, true)
      api.nvim_win_close(windows.results.win, true)

      -- Schedule the callback to ensure windows are closed first
      vim.schedule(function()
        -- Make sure to explicitly pass the action parameter
        --- @diagnostic disable-next-line: redundant-parameter
        opts.on_select(selected, action)
      end)
    end
  end

  -- Helper function to scroll by pages
  local function page_scroll(direction)
    local page_size = math.floor(state.windows.results.height / 2)

    if direction == "down" then
      state.selected = math.min(state.selected + page_size, #state.filtered_items)
    else -- direction == "up"
      state.selected = math.max(state.selected - page_size, 1)
    end

    M.update_display(state)
  end

  -- helper function to move up/down the selection entries
  local function move_selection(direction)
    if direction == "down" then
      if state.selected < #state.filtered_items then
        state.selected = state.selected + 1
        M.update_display(state)
      end
    else
      if state.selected > 1 then
        state.selected = state.selected - 1
        M.update_display(state)
      end
    end
  end

  -- Keymaps

  -- select mappings
  vim.keymap.set("i", "<CR>", function()
    select_with_action("edit")
  end, { buffer = windows.input.buf })

  -- close maappings
  vim.keymap.set("i", "<Esc>", function()
    close_action()
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<C-c>", function()
    close_action()
  end, { buffer = windows.input.buf })

  -- move up/down mappings
  vim.keymap.set("i", "<C-n>", function()
    move_selection("down")
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<C-p>", function()
    move_selection("up")
  end, { buffer = windows.input.buf })

  vim.keymap.set("i", "<C-j>", function()
    move_selection("down")
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<C-k>", function()
    move_selection("up")
  end, { buffer = windows.input.buf })

  vim.keymap.set("i", "<Down>", function()
    move_selection("down")
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<Up>", function()
    move_selection("up")
  end, { buffer = windows.input.buf })

  -- Add C-d and C-u for page scrolling
  vim.keymap.set("i", "<C-d>", function()
    page_scroll("down")
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<C-u>", function()
    page_scroll("up")
  end, { buffer = windows.input.buf })

  -- Add C-v and C-s for vertical and horizontal splits
  vim.keymap.set("i", "<C-v>", function()
    select_with_action("vsplit")
  end, { buffer = windows.input.buf })
  vim.keymap.set("i", "<C-s>", function()
    select_with_action("split")
  end, { buffer = windows.input.buf })

  -- Completion keys (remove completions)
  local completion_keys = { "<C-x>", "<Tab>", "<C-n>", "<C-p>", "<C-space>" }
  for _, key in ipairs(completion_keys) do
    if key ~= "<C-n>" and key ~= "<C-p>" then -- Keep your navigation keys
      vim.keymap.set("i", key, function()
        -- Do nothing or just continue filtering
        --- @diagnostic disable-next-line: redundant-return
        return
      end, { buffer = windows.input.buf, noremap = true })
    end
  end

  -- Start insert mode at end of prompt
  vim.cmd("startinsert")
  vim.api.nvim_win_set_cursor(windows.input.win, { 1, #opts.prompt })

  -- Set up autocommand for text changes
  local group = api.nvim_create_augroup("FuzzyFinder", { clear = true })
  api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
    group = group,
    buffer = windows.input.buf,
    callback = function()
      local line = api.nvim_buf_get_lines(windows.input.buf, 0, 1, false)[1]
      state.query = line:sub(#opts.prompt + 1)
      state.filtered_items = M.filter_items(state.items, state.query)
      state.selected = 1
      M.update_display(state)
    end,
  })
end

-- Find the workspace root directory
function M.find_workspace_root()
  -- First try to find git root
  local git_root = fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if git_root ~= "" and fn.isdirectory(git_root) == 1 then
    return git_root
  end

  -- Try to find project marker files by looking upward
  --- @diagnostic disable-next-line: missing-parameter
  local current_path = fn.expand("%:p:h")
  local markers = { ".git", "package.json", "Cargo.toml", "Makefile", ".svn", ".hg", "pyproject.toml" }

  -- Search in current directory and parents
  local path = current_path
  while path ~= "/" do
    for _, marker in ipairs(markers) do
      --- @diagnostic disable-next-line: missing-parameter
      if
        fn.filereadable(fn.glob(path .. "/" .. marker)) == 1
        --- @diagnostic disable-next-line: missing-parameter
        or fn.isdirectory(fn.glob(path .. "/" .. marker)) == 1
      then
        return path
      end
    end
    path = fn.fnamemodify(path, ":h")
  end

  -- Fallback to current working directory
  return fn.getcwd()
end

-- Find files function (uses ripgrep/fd if available)
function M.find_files(opts)
  opts = opts or {}
  opts.prompt = opts.prompt or "Files > "

  -- Get workspace root
  local root = M.find_workspace_root()

  -- Get all files using the best available command
  local cmd
  if fn.executable("fd") == 1 then
    cmd = "fd --type f --hidden --exclude .git --base-directory " .. fn.shellescape(root)
  elseif fn.executable("rg") == 1 then
    cmd = "cd " .. fn.shellescape(root) .. " && rg --files --hidden --glob '!.git'"
  else
    cmd = "find " .. fn.shellescape(root) .. " -type f -not -path '*/\\.git/*' -not -path '*/\\.*'"
  end

  local files = {}
  local handle = io.popen(cmd)
  if handle then
    for file in handle:lines() do
      -- Make paths relative to workspace root
      if file:sub(1, #root) == root then
        file = file:sub(#root + 2) -- +2 to remove leading slash
      end
      table.insert(files, file)
    end
    handle:close()
  end

  M.fuzzy_find(files, {
    prompt = opts.prompt,
    on_select = function(selected, action)
      -- Use a default action if none provided
      action = action or "edit"

      -- Explicitly use the action parameter
      vim.cmd(action .. " " .. fn.fnameescape(root .. "/" .. selected))
    end,
  })
end

-- Find buffers function
function M.find_buffers(opts)
  opts = opts or {}
  opts.prompt = opts.prompt or "Buffers > "

  local buffers = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = api.nvim_buf_get_name(buf)
      if name and name ~= "" then
        name = fn.fnamemodify(name, ":.")
        table.insert(buffers, { name = name, bufnr = buf })
      end
    end
  end

  local buffer_names = {}
  for _, buf in ipairs(buffers) do
    table.insert(buffer_names, buf.name)
  end

  M.fuzzy_find(buffer_names, {
    prompt = opts.prompt,
    on_select = function(selected, action)
      -- Use a default action if none provided
      action = action or "buffer"

      for _, buf in ipairs(buffers) do
        if buf.name == selected then
          if action == "edit" or action == "buffer" then
            vim.cmd("buffer " .. buf.bufnr)
          elseif action == "split" then
            vim.cmd("sbuffer " .. buf.bufnr)
          elseif action == "vsplit" then
            vim.cmd("vertical sbuffer " .. buf.bufnr)
          end
          break
        end
      end
    end,
  })
end

-- Setup function to create commands and keymaps
function M.setup(opts)
  opts = opts or {}

  -- Create commands
  api.nvim_create_user_command("FuzzyFiles", function()
    M.find_files()
  end, {})
  api.nvim_create_user_command("FuzzyBuffers", function()
    M.find_buffers()
  end, {})

  -- Create default keymaps (if not disabled)
  if opts.keymaps ~= false then
    vim.keymap.set("n", "<Leader>ff", M.find_files, { noremap = true, silent = true, desc = "Find Files" })
    vim.keymap.set("n", "<Leader>fb", M.find_buffers, { noremap = true, silent = true, desc = "Find Buffers" })
    vim.keymap.set("n", "<C-space>", M.find_files, { noremap = true, silent = true, desc = "Find Files" })
  end
end

return M
