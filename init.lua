---- ┌──────────┐
---- │ defaults │
---- └──────────┘

--- Load the general neovim configuration settings
--- I consider these sane defaults, but feel free to change anything you don't like
require('general')

--------------------------------------------------------------------------------

---- ┌────────────────────────────────┐
---- │ Custom configuration variables │
---- └────────────────────────────────┘

--- @type boolean use the custom keymaps this config defines
vim.g.enable_custom_keymaps = true

--- @type boolean use the tmux keymaps provided in the lua.tmux module
vim.g.enable_tmux_keymaps = true

--- @type boolean allow the tmux keymaps to send notifications
vim.g.enable_tmux_notifications = true

--------------------------------------------------------------------------------

---- ┌──────────────────┐
---- │ style hover docs │
---- └──────────────────┘

-- Enable concealing of markdown characters
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.o.conceallevel = 3
  end
})

-- Optional: Set some basic fish file detection if needed
vim.filetype.add({
  extension = {
    fish = 'fish',
  },
})

--------------------------------------------------------------------------------

--- HACK: Ensure that when Vim is opened, a filetype is assigned to buffers
--- (this makes sure lsps are started when vim is opened)
vim.cmd([[autocmd VimEnter * silent! doautocmd FileType]])

--------------------------------------------------------------------------------

---- ┌────────────────────────┐
---- │  load plugins/modules  │
---- └────────────────────────┘

-- the plugin configs and customizations
require('plugins')
require('keymaps')
require('theme')
require('treesitter')
require('commands')

-- load custom modules
require('bufferline').setup()
require('fuzzy').setup()
require('tmux').setup()

-- lsps
require('lsps').setup({
  -- set this to false if you only want to use the fish-lsp with this config
  setup_other_lsps = true, -- incase you want lua_ls & ts_ls to be installed for editting the config
})

-- ... anything else ...
