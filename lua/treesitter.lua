
require('nvim-treesitter.configs').setup {
  ensure_installed = { "markdown", "markdown_inline", "fish" },
  highlight = {
    enable = true,
  },
  conceal = {
    enable = true,

    -- Enable concealing for markdown
    markdown_fenced_languages = {
      "ts=typescript",
      "js=javascript",
      "python",
      "lua",
      "fish",
      "markdown",
      "markdown_inline",
      -- "man=markdown_inline"
      -- Add any other languages you commonly use in code blocks
    },
  }
}
