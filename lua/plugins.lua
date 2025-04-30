local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- icons
  use("nvim-tree/nvim-web-devicons")

  -- fidget.nvim for lsp progress
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- You can alias plugin names
  use({ "dracula/vim", as = "dracula" })
  use({ "folke/tokyonight.nvim", as = "tokyonight" })

  -- Post-install/update hook with neovim command
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  -- conceal markdown in hover docs
  use({
    "MeanderingProgrammer/render-markdown.nvim",
    after = { "nvim-treesitter" },
    -- requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
    -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
    requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup({
        overrides = {
          buftype = {
            nofile = {
              code = {
                style = "normal",
                lang = "",
                border = "hide",
              },
            },
          },
        },
      })
    end,
  })

  use({
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
        aliases = {
          ["a"] = ">",
          ["b"] = ")",
          ["B"] = "}",
          ["r"] = "]",
          ["q"] = { '"', "'", "`" },
          ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
        },
      })
    end,
  })

  -- Which-key for discovering keybindings
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
