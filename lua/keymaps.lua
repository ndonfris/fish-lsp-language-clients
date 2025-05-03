---- ┌─────────┐
---- │ keymaps │
---- └─────────┘
local M = {}

local global_keymap_opts = { noremap = true, silent = true }
local control_opts = { noremap = true, silent = true, expr = true }

if vim.g.enable_custom_keymaps == nil then
  vim.g.enable_custom_keymaps = true
end

if vim.g.enable_custom_keymaps == false then
  return
end

vim.keymap.set("n", "<Space>", "", global_keymap_opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- command mode keymaps
vim.keymap.set("c", "<C-a>", "<C-b>", control_opts) -- ctrl-a moves to the beginning of the line
vim.keymap.set("c", "<C-y>", "<C-f>", control_opts) -- ctrl-y opens command history
vim.keymap.set("c", "<C-v>", "<C-r>+", control_opts) -- ctrl-y opens command history

-- map <C-c> to <esc>
vim.cmd([[
  map <C-c> <esc>
  nnoremap <C-c> <esc>
  xnoremap <C-c> <esc>
  inoremap <C-c> <esc>
  vnoremap <C-c> <esc>
  cnoremap <C-c> <esc>
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
vim.keymap.set("n", "<C-d>", function()
  require("hover_scroll").scroll_hover("<C-f>", "<C-d>")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", function()
  require("hover_scroll").scroll_hover("<C-b>", "<C-u>")
end, { noremap = true, silent = true })

local completion_utils = require("completion_utils")
local completion_opts = require("completion_utils").default_opts
local completion_expr_opts = require("completion_utils").expr_opts

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
vim.keymap.set({ "n", "x", "o" }, "<Leader>c", "gc", { remap = true })

return M
