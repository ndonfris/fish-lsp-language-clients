---- TABLE OF CONTENTS
----   1.) defaults
----   2.) vim-plug & plugins
----   3.) coc.nvim
----   4.) keymaps
----   5.) other-stuff

---- ┌──────────┐
---- │ defaults │
---- └──────────┘
-- Enable syntax highlighting
vim.cmd('syntax on')
vim.cmd('syntax enable')

-- Enable filetype plugins and indenting
vim.cmd('filetype plugin indent on')

-- Additional syntax settings
vim.cmd('syntax spell notoplevel')

-- General settings
vim.o.hidden = true           -- Required to keep multiple buffers open
vim.o.wrap = false            -- Display long lines as just one line
vim.o.showmode = false
vim.o.swapfile = false

-- Mouse and clipboard settings
vim.o.mouse = 'a'             -- Enable mouse in all modes
vim.o.clipboard = 'unnamedplus'  -- Use the system clipboard

-- Window splitting behavior
vim.o.splitbelow = true       -- Horizontal splits below current window
vim.o.splitright = true       -- Vertical splits to the right of current window

-- Auto-indent settings
vim.o.cindent = true          -- Stricter C syntax
-- vim.o.cinwords = ''        -- Uncomment and adjust as needed
vim.o.expandtab = true        -- Use spaces instead of tabs
vim.o.tabstop = 8             -- Number of spaces tabs count for
vim.o.shiftwidth = 4          -- Number of spaces to use for autoindent
vim.o.softtabstop = 4
vim.o.smartindent = true      -- Enable smart indent
vim.o.autoindent = true       -- Enable automatic indentation

-- wrap off
vim.o.wrap = false

-- Spell checking
vim.o.spelllang = 'en_us'

-- Backspace behavior
vim.o.backspace = 'indent,eol,start'

-- Increment settings
vim.o.nrformats = 'alpha'

-- Line numbering
vim.o.number = true                 -- Enable line numbers
vim.o.relativenumber = true         -- Enable relative line numbers
vim.o.cursorline = true             -- Highlight the current line
vim.o.cursorlineopt = 'number'      -- Cursor line options
vim.o.background = 'dark'           -- Set background color to dark
vim.o.scrolloff = 5                 -- Minimum number of lines to keep above and below the cursor
vim.o.virtualedit = 'all'           -- Allow cursor to move anywhere

-- Python 3 host program
vim.g.python3_host_prog = '/usr/bin/python3'

vim.o.ignorecase = true             -- Case insensitive searching
vim.o.smartcase = true

-- Completion settings
vim.o.complete = vim.o.complete .. ',kspell'

-- Completeopt settings
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Memory, shell, and compatibility settings
vim.o.mmp = 2000
vim.o.compatible = false

-- Interface settings
vim.o.cmdheight = 1             -- Set command line height
-- vim.o.laststatus = 3            -- Set global status line
vim.o.signcolumn = 'yes'        -- Always show the sign column
vim.o.foldenable = false        -- Disable folding by default

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌──────────┐
---- │ vim-plug │
---- └──────────┘
---- 	 • https://github.com/junegunn/vim-plug?tab=readme-ov-file
vim.cmd[[
 source $HOME/.config/nvim-fish-lsp/vim-plug.vim
 source $HOME/.config/nvim-fish-lsp/theme.vim
]]
require('telescope').setup()
require('telescope').load_extension('coc')
require('user.treesitter')


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌──────────┐
---- │ coc.nvim │
---- └──────────┘
----      • https://github.com/neoclide/coc.nvim

require('user.default-coc')
vim.cmd('source $HOME/.config/nvim-fish-lsp/coc.vim')

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌─────────┐
---- │ keymaps │
---- └─────────┘
M = {}
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap


keymap("n", "<Space>", "", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- window movement
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Move to Beginning/End of Line
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)
keymap("v", "H", "^", opts) -- visual mode
keymap("v", "L", "$", opts) -- visual mode


-- map <C-c> to <esc>
vim.cmd [[
  map <C-c> <esc>
  nnoremap <C-c> <esc>
  xnoremap <C-c> <esc>
  inoremap <C-c> <esc>
  vnoremap <C-c> <esc>
  cnoremap <C-c> <esc>
]]

-- Turn off search highlights
keymap('n', '<C-c><C-c>', "<cmd>noh<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts) -- visual mode
keymap("v", ">", ">gv", opts) -- visual mode

-- telescope
keymap("n", "<C-space>", "<cmd>Telescope find_files<cr>", opts)

-- match
keymap("n", "m", "%", opts)
keymap("n", "M", "g%", opts)

-- inspect tree-sitter node
keymap("n", "<leader>i", "<cmd>Inspect<cr>", opts)
keymap("n", "<leader>ii", "<cmd>InspectTree<cr>", opts)

-- restart coc.nvim
keymap("n", "<leader><cr>", "<cmd>CocRestart<cr>", opts)

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

-- ... anything else ...
