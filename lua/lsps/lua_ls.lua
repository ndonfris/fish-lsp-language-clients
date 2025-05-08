-- lua/lsps/lua_ls.lua
--- @type vim.lsp.ClientConfig
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git'
  },
  -- Note: on_attach will be set in init.lua
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = {'vim'} },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath('config'),
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
          "${VIMRUNTIME}/lua",
          "${VIMRUNTIME}/lua/vim/lsp"
        }
      },
    }
  }
}
