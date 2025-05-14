--- ./lua/lsp/ts_ls.lua
--- @type vim.lsp.ClientConfig
return {
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript" },
  settings = { },
}
