----
---- below snippet is DEPRECATED after v0.10.0 
----    use `:Inspect` && `:InspectTree` instead
----
-- if vim.g.loaded_nvim_treesitter then 
--   local ts_utils = require 'nvim-treesitter.ts_utils'
--   --keymap('n', '<leader>n', '<cmd>lua P(' .. ts_utils.get_node_at_pos(0) ..')<cr>', opts)
--   --keymap('n', '<leader>nc', '<cmd>lua P(' .. ts_utils.get_named_children(0) ..')<cr>', opts)
-- end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader><cr><cr>', "<cmd>call CocAction('refreshSource', 'fishlsp')<cr>", opts)

keymap('n', 'gm', '<cmd>vertical Man<cr>', opts)

vim.lsp.start({
  name ="fish-lsp",
  cmd = {'fish-lsp', 'start'},
  filetypes = {'fish'}
})


local keymap = vim.api.nvim_set_keymap

-- ┌──────────────┐
-- │ mode options │
-- └──────────────┘

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local control_opts = {}

-- ┌────────┐
-- │ LEADER │
-- └────────┘
keymap("n", "<Space>", "", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.treesitter.language.add({'fish'})
local args = vim.buf.args;
keymap('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
keymap('n', 'gs', vim.lsp.buf.hover, { buffer = args.buf })
keymap('n', '<leader>F', '<cmd>'.. vim.lsp.buf.foramt({async = true}) .. '<cr>', { buffer = args.buf })
keymap('n', '<leader>f', '<cmd>' .. vim.lsp.buf.foramt({async = true}) .. '<cr>', { buffer = args.buf })
keymap('n', 'gr', '<cmd>' .. vim.lsp.buf.references() .. '<cr>', { buffer = args.buf })
keymap('n', 'gd', '<cmd>' .. vim.lsp.buf.definition() .. '<cr>', { buffer = args.buf })
keymap('n', 'ca', '<cmd>' ..vim.lsp.buf.code_action() .. '<cr>', { buffer = args.buf })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.hoverProvider then
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.server_capabilities.completionProvider then
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.definitionProvider then
	vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
      end
    end
    vim.keymap.set('n', 'gH', ':lua vim.print(vim.tbl_keys(vim.lsp.handlers))<cr>', { buffer = args.buf })
  end
})





