-- lua/lsps/fish-lsp.lua
--- @type vim.lsp.ClientConfig
return {
  name = "fish-lsp",
  cmd = { 'fish-lsp', 'start' },
  filetypes = { 'fish' },
  root_markers = {
    '.git',
    'config.fish',
  }
}
