return {
  'ndonfris/fish-lsp',
  config = function() 
    vim.cmd([[
	autocmd BufWritePre,BufEnter *.fish lua vim.lsp.start({name='fish-lsp', cmd = {'fish-lsp', 'start'}, filetypes = {'fish'}})
	autocmd CursorHold  <silent><buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorHoldI <silent><buffer> lua vim.lsp.buf.document_highlight()
	autocmd CursorMoved <silent><buffer> lua vim.lsp.buf.clear_references()
    ]])
  end,
}


-- local lspconfig = require 'lspconfig'
--
-- local configs = require 'lspconfig.configs'
--
-- if not configs.fish_lsp then
--   configs.fish_lsp_lsp = {
--     default_config = {
--       cmd = { 'fish-lsp', 'start' },
--       filetypes = { 'fish' },
--       root_dir = function(fname)
--         return lspconfig.util.find_git_ancestor(fname)
--       end,
--       settings = {},
--     },
--   }
-- end
-- lspconfig.fish_lsp.setup {}

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'fish',
--   callback = function(args)
--     -- local match = vim.fs.find(root_markers, { path = args.file, upward = true })[1]
--     -- local root_dir = match and vim.fn.fnamemodify(match, ':p:h') or nil
--     vim.lsp.start {
--       cmd = { 'fish-lsp', 'start' },
--       settings = {},
--     }
--   end,
-- })
--
