---- TABLE OF CONTENTS
----   1.) defaults
----   2.) keymaps
----   3.) setting up fish-lsp
----   4.) anything else

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
vim.o.tabstop = 4             -- Number of spaces tabs count for
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
vim.o.foldenable = false
vim.o.updatetime = 300          -- Set update time for CursorHold

--------------------------------------------------------------------------------
vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌─────────┐
---- │ keymaps │
---- └─────────┘
M = {}
local global_keymap_opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Space>", "", global_keymap_opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map <C-c> to <esc>
vim.cmd [[
  map <C-c> <esc>
  nnoremap <C-c> <esc>
  xnoremap <C-c> <esc>
  inoremap <C-c> <esc>
  vnoremap <C-c> <esc>
  cnoremap <C-c> <esc>
]]

-- window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", global_keymap_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", global_keymap_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", global_keymap_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", global_keymap_opts)

-- split buffer keymaps
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<cr>', global_keymap_opts)
vim.keymap.set('n', '<leader>_', '<cmd>split<cr>', global_keymap_opts)

-- buffer movement
vim.keymap.set('n', '<C-n>', '<cmd>bn<cr>', { noremap = true })
vim.keymap.set('n', '<C-p>', '<cmd>bp<cr>', { noremap = true })

-- Close quickfix windows with <C-c>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set('n', '<C-c>', '<cmd>close<cr>', { noremap = true, buffer = true, silent = true, nowait = true })
  end
})


-- Move to Beginning/End of Line
vim.keymap.set("n", "H", "^", global_keymap_opts)
vim.keymap.set("n", "L", "$", global_keymap_opts)
vim.keymap.set("v", "H", "^", global_keymap_opts) -- visual mode
vim.keymap.set("v", "L", "$", global_keymap_opts) -- visual mode

-- Turn off search highlights
vim.keymap.set('n', '<C-c><C-c>', "<cmd>noh<cr>", global_keymap_opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", global_keymap_opts) -- visual mode
vim.keymap.set("v", ">", ">gv", global_keymap_opts) -- visual mode

-- match
vim.keymap.set("n", "m", "%", global_keymap_opts)
vim.keymap.set("n", "M", "g%", global_keymap_opts)

-- exit
vim.keymap.set('n', 'qq', '<cmd>qa!<cr>', global_keymap_opts)

-- C-d and C-u scroll in floating windows
vim.keymap.set('n', '<C-d>', function()
  require('hover_scroll').scroll_hover('<C-f>', '<C-d>')
end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', function()
  require('hover_scroll').scroll_hover('<C-b>', '<C-u>')
end, { noremap = true, silent = true })

local completion_handler = require('completion_utils').completion_handler
local completion_expr_opts = require('completion_utils').expr_opts

-- -- Map Ctrl+Space to trigger completion in insert mode
vim.keymap.set('i', '<C-Space>', completion_handler, completion_expr_opts)
vim.keymap.set('i', '<C-@>', completion_handler, completion_expr_opts)
--vim.cmd[[set completeopt+=menuone,noselect,popup]]
--vim.keymap.set('i', '<C-space>', function()
--  vim.lsp.completion.get()
--end)

-- Make C-d/C-u scroll down/up 10 items in the completion menu
vim.keymap.set('i', '<C-u>', require('completion_utils').c_u_insert_scroll, completion_expr_opts)
vim.keymap.set('i', '<C-d>', require('completion_utils').c_d_insert_scroll, completion_expr_opts)

-- c-j/c-k move up and down in completion menu
vim.keymap.set('i', '<C-j>', '<C-n>', global_keymap_opts)
vim.keymap.set('i', '<C-k>', '<C-p>', global_keymap_opts)

-- c-h/c-BS delete word in insert mode
vim.keymap.set('i', '<C-h>', '<C-w>', { noremap = true })
vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true })

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌──────────────────┐
---- │ style hover docs │
---- └──────────────────┘
-- Enable concealing of markdown characters

-- Set conceal specifically for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.o.conceallevel = 3
    -- vim.cmd()
    -- vim.opt_local.conceallevel = 2
  end
})


-- Configure LSP hover documentation with markdown concealing
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  (vim.lsp.handlers.hover), {
    border = "rounded",
    -- result = vim.lsp.util.convert_input_to_markdown_lines,

    -- Set markdown rendering options
    -- stylize_markdown = false,
    markdown = {
      -- Use treesitter for syntax highlighting in hover docs
      highlight = {
	enable = true,
	--     additional_vim_regex_highlighting = true,
      },
      --   -- Configure concealing for the hover window
      -- conceallevel = 2,
      --   conceal = 'all'
    }
  }
)


vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  }
)

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- ┌──────────┐
---- │ fish-lsp │
---- └──────────┘

-- Function to set up document highlight
local function setup_document_highlight(client, bufnr)
  -- Check if client supports documentHighlight
  if client.server_capabilities.documentHighlightProvider then
    -- Create a highlight group for document highlights
    vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3c3836" })

    -- Create autocommands for highlight on cursor hold
    local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = highlight_group,
      buffer = bufnr,
      callback = function()
	vim.lsp.buf.document_highlight()
      end
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = highlight_group,
      buffer = bufnr,
      callback = function()
	vim.lsp.buf.clear_references()
      end
    })
  end
end
-- Minimal Neovim config for Fish LSP support (Neovim v0.10.4)

-- Set up lsp for fish files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fish',
  callback = function()
    -- Configure fish-language-server
    local client = vim.lsp.start({
      name = 'fish',
      cmd = { 'fish-lsp', 'start' },
      filetypes = { 'fish' },
      root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'fish' }, { upward = true })[1]),
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = function(client, bufnr)
	-- Set up document highlight
	setup_document_highlight(client, bufnr)
      end,
    })

    -- Attach client to current buffer
    if client then
      vim.lsp.buf_attach_client(0, client)
      --- ┌─────────────┐
      --- │ lsp keymaps │
      --- └─────────────┘
      -- Local keybindings for LSP features
      local fish_keymap_opts = { buffer = true, noremap = true, silent = true }

      --  inlay hint
      vim.lsp.inlay_hint.enable(true)

      -- hold color highlighting
      vim.cmd([[
	autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      ]])

      --  go-to definition
      if vim.lsp.buf.definition then
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, fish_keymap_opts)
      end
      -- go-to implementation
      if vim.lsp.buf.implementation then
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, fish_keymap_opts)
      end
      -- hover
      if vim.lsp.buf.hover then
	vim.keymap.set('n', 'gs', vim.lsp.buf.hover, fish_keymap_opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, fish_keymap_opts)
	-- Make Ctrl+d and Ctrl+u scroll hover documentation if visible in normal mode

      end
      -- go-to reference
      if vim.lsp.buf.references then
	vim.keymap.set("n", "gr", vim.lsp.buf.references, fish_keymap_opts)
      end
      -- rename
      if vim.lsp.buf.rename then
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, fish_keymap_opts)
      end
      -- code actions
      if vim.lsp.buf.code_action then
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, fish_keymap_opts)
	vim.keymap.set('n', 'gca', vim.lsp.buf.code_action, fish_keymap_opts)
      end
      -- format
      if vim.lsp.buf.format then
	vim.keymap.set('n', '<leader>f', function()
	  vim.lsp.buf.format({ async = true })
	end, fish_keymap_opts)
      end
      -- signature help
      if vim.lsp.buf.signature_help then
	vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, fish_keymap_opts)
	vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, fish_keymap_opts)
      end
      -- inspecting tree-sitter nodes
      -- note: you might have to install the tree-sitter-fish language file for this to work
      --       @see https://github.com/nvim-treesitter/nvim-treesitter
      vim.keymap.set("n", "<leader>i", "<cmd>Inspect<cr>", fish_keymap_opts)
      vim.keymap.set("n", "<leader>ii", "<cmd>InspectTree<cr>", fish_keymap_opts)

      if vim.lsp.buf.documentHighlight then
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.document_highlight, fish_keymap_opts)
      end

      -- folding
      vim.b.foldexpr = 'v:lua.vim.lsp.foldexpr()'
      vim.keymap.set('n', "gfo", function()
	vim.o.foldenable = not vim.o.foldenable
	if (vim.o.foldenable) then
	  vim.b.foldexpr = 'v:lua.vim.lsp.foldexpr()'
	end
      end, fish_keymap_opts)
    end
  end
})

-- Optional: Set some basic fish file detection if needed
vim.filetype.add({
  extension = {
    fish = 'fish',
  },
})
--
-- Add this to your Neovim configuration (e.g., init.lua or a plugin file)
-- ... anything else ...
require('plugins')
require('theme')
require('treesitter')
require('commands')
