-- the tmux keymappings incase you are using tmux
local M = {}

--- @diagnostic disable: undefined-field

local function execute_tmux_command(command)
  if vim.g.enable_tmux_notifications == true then
    vim.notify("tmux " .. command, vim.log.levels.INFO, {
      title = " tmux command",
      timeout = 500
    })
  end
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

 -- Function to check if running inside tmux
local function is_in_tmux()
  local tmux_env = os.getenv("TMUX")
  return tmux_env ~= nil and tmux_env ~= ""
end

--- setup function to call in `init.lua`
-- @param opts (optional) configuration options
--   opts.leader_key: custom leader key to use instead of <leader>
function M.setup(opts)
  if vim.g.enable_tmux_keymaps == nil then
    return
  end

  if vim.g.enable_tmux_keymaps == false then
    return
  end

  if not is_in_tmux() then
    return
  end

  -- Set default options
  opts = opts or {}
  local leader_key = opts.leader_key or "<leader>"

  -- Define keymaps with descriptions
  local keymaps = {
    { key = "tt",    func = "choose_tree", desc = "tmux choose tree" },
    { key = "<C-w>", func = "last_window", desc = "tmux last window" },
    { key = "<C-h>", func = "pane_left",   desc = "tmux select-pane left" },
    { key = "<C-l>", func = "pane_right",  desc = "tmux select-pane right" },
    { key = "<C-j>", func = "pane_down",   desc = "tmux select-pane down" },
    { key = "<C-k>", func = "pane_up",     desc = "tmux select-pane up" },
  }

  -- Set up keymaps
  for _, keymap in ipairs(keymaps) do
    local full_key = leader_key .. keymap.key
    local cmd = string.format(':lua require("tmux").%s()<CR>', keymap.func)

    vim.keymap.set("n", full_key, cmd, {
      noremap = true,
      silent = true,
      desc = keymap.desc
    })
  end
end

return M
