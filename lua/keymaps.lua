---@diagnostic disable: missing-parameter
---- ┌─────────┐
---- │ keymaps │
---- └─────────┘
local M = {}

local global_keymap_opts = { noremap = true, silent = true }
-- local control_opts = { noremap = true, silent = true, expr = true }

--- early return if custom keymaps are disabled
if vim.g.enable_custom_keymaps == nil then
  vim.g.enable_custom_keymaps = true
end
if vim.g.enable_custom_keymaps == false then
  return M
end

--- begin using custom keymaps

--- leader key
vim.keymap.set("n", "<Space>", "", global_keymap_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- command mode keymaps
vim.keymap.set("c", "<C-a>", "<C-b>", { noremap = true })  -- ctrl-a moves to the beginning of the line
vim.keymap.set("c", "<C-y>", "<C-f>", { noremap = true })  -- ctrl-y opens command history
vim.keymap.set("c", "<C-v>", "<C-r>+", { noremap = true }) -- ctrl-y opens command history
-- Map <C-Space> to the default wildchar (usually <Tab>)
vim.keymap.set('c', '<C-Space>', function()
    return vim.api.nvim_replace_termcodes('<C-Z>', true, false, true)
end, { expr = true})
vim.keymap.set('c', '<C-j>', '<C-n>', { noremap = true })
vim.keymap.set('c', '<C-k>', '<C-p>', { noremap = true })
vim.cmd([[set wildmode=longest,full]])

-- map <C-c> to <esc>
vim.cmd([[
  map <C-c> <esc>
  nnoremap <C-c> <esc>
  xnoremap <C-c> <esc>
  inoremap <C-c> <esc>
  vnoremap <C-c> <esc>
  "cnoremap <C-c> <Esc>
]])

-- window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", global_keymap_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", global_keymap_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", global_keymap_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", global_keymap_opts)

-- resizing
vim.keymap.set("n", "<M-k>", "<cmd>horizontal resize +5<CR>", { desc = "Increase vertical buffer sizing" })
vim.keymap.set("n", "<M-j>", "<cmd>horizontal resize -5<CR>", { desc = "Decrease vertical buffer sizing" })
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -5<CR>", { desc = "Increase horizontal buffer sizing" })
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +5<CR>", { desc = "Decrease horizontal buffer sizing" })

-- open a term buffer
vim.keymap.set("n", "<leader><C-t>", require("term_buffer").open_terminal, { desc = "open a terminal in insert mode" })
vim.keymap.set(
  "n",
  "<leader><C-b>",
  require("term_buffer").open_bottom_terminal,
  { desc = "open a terminal at bottom of window in insert mode" }
)

-- jump to config paths
vim.keymap.set("n", "<leader><leader>ef", "<cmd>edit ~/.config/fish/config.fish<cr>", { silent = true })
vim.keymap.set("n", "<leader><leader>en", "<cmd>edit ~/.config/fish-lsp-language-clients<cr>", { silent = true })

-- split buffer keymaps
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", global_keymap_opts)
vim.keymap.set("n", "<leader>_", "<cmd>split<cr>", global_keymap_opts)

-- delete buffer
vim.keymap.set("n", "<leader>db", "<cmd>bdelete!<cr>", global_keymap_opts)

-- buffer movement
vim.keymap.set("n", "<C-n>", "<cmd>bn<cr>", { noremap = true })
vim.keymap.set("n", "<C-p>", "<cmd>bp<cr>", { noremap = true })

-- Close quickfix windows with <C-c>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", { noremap = true, buffer = true, silent = true, nowait = true })
  end,
})

-- Move to Beginning/End of Line
vim.keymap.set("n", "H", "^", global_keymap_opts)
vim.keymap.set("n", "L", "$", global_keymap_opts)
vim.keymap.set("v", "H", "^", global_keymap_opts) -- visual mode
vim.keymap.set("v", "L", "$", global_keymap_opts) -- visual mode

-- Turn off search highlights
vim.keymap.set("n", "<C-c><C-c>", "<cmd>noh<cr>", global_keymap_opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", global_keymap_opts) -- visual mode
vim.keymap.set("v", ">", ">gv", global_keymap_opts) -- visual mode

-- match
vim.keymap.set("n", "m", "%", global_keymap_opts)
vim.keymap.set("v", "m", "i%", global_keymap_opts)
vim.keymap.set("n", "M", "v%", global_keymap_opts)
vim.keymap.set("v", "M", "%", global_keymap_opts)

-- exit
vim.keymap.set("n", "qq", "<cmd>qa!<cr>", global_keymap_opts)

-- C-d and C-u scroll in floating windows
local hover_scroll = require("lsps.utils.hover_scroll")
vim.keymap.set("n", "<C-d>", function() hover_scroll.scroll_hover("<C-f>", "<C-d>") end,
  { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", function() hover_scroll.scroll_hover("<C-b>", "<C-u>") end,
  { noremap = true, silent = true })

-- Completion utils
local completion_utils = require("lsps.utils.completion_utils")
local completion_opts = completion_utils.default_opts
local completion_expr_opts = completion_utils.expr_opts

-- -- Map Ctrl+Space to trigger completion in insert mode
vim.keymap.set("i", "<C-Space>", completion_utils.completion_handler, completion_expr_opts)
vim.keymap.set("i", "<C-@>", completion_utils.completion_handler, completion_expr_opts)

-- Map <CR> to confirm completion
vim.keymap.set("i", "<CR>", completion_utils.enter_complete, completion_expr_opts)

-- Map <Tab> and <S-Tab> to navigate completion menu
vim.keymap.set("i", "<Tab>", completion_utils.tab_complete, completion_expr_opts)
vim.keymap.set("i", "<S-Tab>", completion_utils.tab_prev, completion_expr_opts)

-- Make C-d/C-u scroll down/up 10 items in the completion menu
vim.keymap.set("i", "<C-u>", completion_utils.c_u_insert_scroll, completion_expr_opts)
vim.keymap.set("i", "<C-d>", completion_utils.c_d_insert_scroll, completion_expr_opts)

-- c-j/c-k move up and down in completion menu
vim.keymap.set("i", "<C-j>", "<C-n>", completion_opts)
vim.keymap.set("i", "<C-k>", "<C-p>", completion_opts)

-- c-h/c-BS delete word in insert mode
vim.keymap.set("i", "<C-h>", "<C-w>", completion_opts)
vim.keymap.set("i", "<C-BS>", "<C-w>", completion_opts)

-- commenting
vim.keymap.set({'n', 'x', 'o'}, '<leader>cc', '<cmd>silent call feedkeys("gcc", "t")<cr>', { silent = true, noremap = true, desc = 'toggle a comment' })

-- Function to handle smart opening of netrw
function M.smart_netrw(path)
  -- Find all windows with netrw buffers
  local netrw_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      table.insert(netrw_windows, win)
    end
  end

  -- Close all netrw windows
  for _, win in ipairs(netrw_windows) do
    vim.api.nvim_win_close(win, false)
  end

  -- Find and delete any remaining netrw buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "netrw" then
      -- Try to delete the buffer, but don't force it if modified
      pcall(function()
        vim.api.nvim_buf_delete(buf, { force = false })
      end)
    end
  end

  -- Now open netrw with the specified path
  vim.defer_fn(function()
    if path then
      vim.cmd("Lexplore " .. path)
    else
      vim.cmd("Lexplore")
    end
  end, 10) -- Small delay to ensure previous operations are complete
end

-- vim.keymap.set('n', '<Leader><C-d>', '<cmd>Lexplore %:p:h<CR>', {noremap = true, silent = true, nowait = true, desc = 'open netrw in directory of current file' })
-- vim.keymap.set('n', '<leader><leader><C-d>', '<cmd>Lexplore<CR>', {noremap = true, silent = true, nowait = true, desc = 'open netrw in current working directory' })
vim.keymap.set("n", "<Leader><C-d>", function()
  M.smart_netrw(vim.fn.expand("%:p:h"))
end, { noremap = true, silent = true, nowait = true, desc = "open single netrw in directory of current file" })


--- helper to source nvim config files
M.source_nvim_config_file = function()
  vim.cmd(':silent update | w | so %')
  vim.notify(
    'write and source file:\n' .. vim.fn.expand('%:p') .. '/' .. vim.fn.expand('%:t'),
    vim.log.levels.INFO,
    {
      title = ' `:w | so %` - (' .. vim.fn.expand('%:t') .. ')',
    }
  )
end

return M
