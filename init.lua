--- URL: https://github.com/ndonfris/fish-lsp-language-clients/tree/packer
---
--- DESCRIPTION:
---
---    Neovim v0.11.1 config using packer.nvim test the fish-lsp. Uses up-to-date native nvim lsp API.
---    Generally, features aim to be written from scratch instead of using an external plugin.
---    This config aims to be heavily documented, so that fish-lsp support is a friendly experience to neovim users.
---
--- USAGE:
---
---    You can create an alias for running this standalone config inside nvim, using the `$NVIM_APPNAME` env variable.
---
---    To make the alias temporally available in your current session:
---    >_ alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'
---
---    To make the alias always included in your shell:
---    >_ echo "alias flc 'NVIM_APPNAME=fish-lsp-language-clients nvim'" >> ~/.config/fish/config.fish
---
---    To only load the alias when inside this directory or fish-lsp git repo:
---    >_ ./alias.fish --persistent-autoload > $fish_config_dir/conf.d/fish-lsp-language-clients.fish
---

--------------------------------------------------------------------------------

---- ┌──────────┐
---- │ defaults │
---- └──────────┘

--- Load the general neovim configuration settings
--- I consider these sane defaults, but feel free to change anything you don't like
require('general')

--------------------------------------------------------------------------------

--- HACK: Ensure that when Vim is opened, a filetype is assigned to buffers
--- (this makes sure lsps are started when vim is opened)
vim.cmd([[autocmd VimEnter * silent! doautocmd FileType]])

--------------------------------------------------------------------------------

---- ┌────────────────────────────────┐
---- │ Custom configuration variables │
---- └────────────────────────────────┘

--- @type boolean use the custom keymaps this config defines. Setting to false, means all keymappings will be excluded
vim.g.enable_custom_keymaps = true

--- @type boolean use the tmux keymaps provided in the lua.tmux module
vim.g.enable_tmux_keymaps = true

--- @type boolean allow the tmux keymaps to send notifications
vim.g.enable_tmux_notifications = false

--------------------------------------------------------------------------------

---- ┌────────────────────────┐
---- │  load plugins/modules  │
---- └────────────────────────┘

-- the plugin configs and customizations
require('plugins') -- packer plugins and their configs
require('theme')   -- minor changes to colorscheme
require('keymaps') -- general keymappings

-- load custom modules
require('bufferline').setup() -- the bufferline (at the top of the window)
require('fuzzy').setup()      -- the fuzzy file finder, instead of using telescope (`nnoremap <C-space> <cmd>FuzzyFiles<cr>`)
require('tmux').setup()       -- tmux keymappings 

-- setup the lsps (which are configured in `./lua/lsps/*.lua`)
require('lsps').setup({
  -- Incase you want (or dont want) `lua_ls` and `ts_ls` while using this config
  -- These are included incase anyone needs to edit this repo, or fish-lsp
  setup_other_lsps = true,
})

-- ... anything else ...
