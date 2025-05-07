local M = {}

local function execute_tmux_command(command)
  vim.notify("tmux " .. command, vim.log.levels.INFO, {
    title = " tmux command",
  })
  vim.cmd("silent !tmux " .. command)
end

--- choose window
M.choose_tree = function()
  execute_tmux_command("choose-tree")
end

--- choose last window
M.last_window = function()
  execute_tmux_command("last-window")
end

-- directional tmux commands
M.pane_right = function()
  execute_tmux_command("select-pane -R")
end
M.pane_left = function()
  execute_tmux_command("select-pane -L")
end
M.pane_down = function()
  execute_tmux_command("select-pane -D")
end
M.pane_up = function()
  execute_tmux_command("select-pane -U")
end

--- setup function to call in `init.lua`
function M.setup()
  if vim.g.enable_tmux_keymaps == nil then
    return
  end

  if vim.g.enable_tmux_keymaps == false then
    return
  end
  vim.keymap.set( "n", "<leader>tt"   , ':lua require("tmux").choose_tree()<CR>', { noremap = true, silent = true, desc = "tmux choose tree" }      )
  vim.keymap.set( "n", "<leader><C-w>", ':lua require("tmux").last_window()<CR>', { noremap = true, silent = true, desc = "tmux last window" }      )
  vim.keymap.set( "n", "<leader><C-r>", ':lua require("tmux").pane_right()<CR>' , { noremap = true, silent = true, desc = "tmux select-pane right" })
  vim.keymap.set( "n", "<leader><C-l>", ':lua require("tmux").pane_left()<CR>'  , { noremap = true, silent = true, desc = "tmux select-pane left" } )
  vim.keymap.set( "n", "<leader><C-d>", ':lua require("tmux").pane_down()<CR>'  , { noremap = true, silent = true, desc = "tmux select-pane down" } )
  vim.keymap.set( "n", "<leader><C-u>", ':lua require("tmux").pane_up()<CR>'    , { noremap = true, silent = true, desc = "tmux select-pane up" }   )

  -- vim.keymap.set('n', '<leader><C-b>',  ':lua require("term_buffer").open_bottom_terminal()<CR>', { noremap = true, silent = true, desc = "open a terminal at bottom of window in insert mode" })
end

return M
