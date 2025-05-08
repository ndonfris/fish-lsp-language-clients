--- @type vim.lsp.ClientConfig
return {
  cmd = { 'fish-lsp', 'start' },
  filetypes = { 'fish' },
  root_markers = {
    '.git',
    'config.fish',
  }
}
