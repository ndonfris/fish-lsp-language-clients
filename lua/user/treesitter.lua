require('nvim-treesitter.configs').setup({
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "fish", "lua", "vim", "vimdoc", "query" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  modules = {},
  ignore_install = {},
  event_loop = "glib", -- either "libuv" or "glib"
  compilers = { "clang" },

  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["of"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["oc"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["ip"] = "@parameter.inner",
      ["ap"] = "@parameter.inner"
    },
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise]
    },
    include_surrounding_whitespace = true,
  },
  endwise = {
    enable = true,
  }
})
