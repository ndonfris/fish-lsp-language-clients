---- ┌──────────┐
---- │ defaults │
---- └──────────┘
--- The default settings for nvim

-- Enable syntax highlighting
vim.cmd('syntax on')
vim.cmd('syntax enable')

-- Enable filetype plugins and indenting
vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')

-- Additional syntax settings
vim.cmd('syntax spell notoplevel')

-- General settings
vim.o.hidden = true -- Required to keep multiple buffers open
vim.o.wrap = false  -- Display long lines as just one line
vim.o.showmode = false
vim.o.swapfile = false

-- Mouse and clipboard settings
vim.o.mouse = 'a'                       -- Enable mouse in all modes
vim.cmd('set clipboard+=unnamedplus')

vim.o.autochdir = true                  -- auto switch editor directory when buffer is changed

-- Window splitting behavior
vim.o.splitbelow = true -- Horizontal splits below current window
vim.o.splitright = true -- Vertical splits to the right of current window

-- Auto-indent settings
vim.o.cindent = true     -- Stricter C syntax
vim.o.expandtab = true   -- Use spaces instead of tabs
vim.o.tabstop = 4        -- Number of spaces tabs count for
vim.o.shiftwidth = 4     -- Number of spaces to use for autoindent
vim.o.softtabstop = 4
vim.o.smartindent = true -- Enable smart indent
vim.o.autoindent = true  -- Enable automatic indentation

-- wrap off
vim.o.wrap = false

-- Spell checking
vim.o.spelllang = 'en_us'

-- Backspace behavior
vim.o.backspace = 'indent,eol,start'

-- Increment settings
vim.o.nrformats = 'alpha'

-- Line numbering
vim.o.number = true            -- Enable line numbers
vim.o.relativenumber = true    -- Enable relative line numbers
vim.o.cursorline = true        -- Highlight the current line
vim.o.cursorlineopt = 'number' -- Cursor line options
vim.o.background = 'dark'      -- Set background color to dark
vim.o.scrolloff = 5            -- Minimum number of lines to keep above and below the cursor
vim.o.virtualedit = 'all'      -- Allow cursor to move anywhere

-- Python 3 host program
vim.g.python3_host_prog = '/usr/bin/python3'

vim.o.ignorecase = true -- Case insensitive searching
vim.o.smartcase = true

-- Completeopt settings
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Memory, shell, and compatibility settings
vim.o.mmp = 2000
vim.o.compatible = false

-- Interface settings
vim.o.cmdheight = 1      -- Set command line height
vim.o.signcolumn = 'yes' -- Always show the sign column
vim.o.foldenable = false
vim.o.updatetime = 500   -- Set update time for CursorHold

--------------------------------------------------------------------------------
-- folding
vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.undofile = true

vim.o.termguicolors = true

-- Enable fuzzy matching in command-line completion
vim.opt.wildoptions:append('fuzzy')
vim.opt.wildmode = 'list:full'
vim.opt.wildmenu = true
