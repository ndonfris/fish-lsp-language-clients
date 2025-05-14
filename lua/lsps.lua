-- lua/lsps.lua
local M = {}

-- Import the on_attach utility functions
local utils = require('lsps.utils.on_attach')

-- Core servers that are always enabled
local core_servers = {
  'fish-lsp',
}

-- Additional servers that are conditionally enabled
-- These configurations are loaded only if setup_other_lsps is true
-- There configurations are in the matching filenames in the lsps directory
local optional_servers = {
  'lua_ls',
  'ts_ls',
}

-- Function to initialize servers with options
--- @class opts
--- @property setup_other_lsps boolean include non fish-lsp lsp configs
function M.setup(opts)
  -- Default options
  opts = opts or {}
  opts.setup_other_lsps = opts.setup_other_lsps ~= false -- Default to true if not specified

  -- First check if Neovim version meets requirements
  require('lsps.utils.check_health').check_nvim_version()

  -- style hover docs, by adding concealment and making sure the fish filetype is recognized
  require('lsps.utils.hover').setup()

  -- Determine which servers to enable
  local servers_to_enable = vim.deepcopy(core_servers)

  -- Add optional servers if setup_other_lsps is true
  if opts.setup_other_lsps then
    for _, server in ipairs(optional_servers) do
      table.insert(servers_to_enable, server)
    end
  end

  -- Load and configure each server
  for _, server_name in ipairs(servers_to_enable) do
    -- Try to load the server's config file
    local ok, server_config = pcall(require, 'lsps.' .. server_name)

    if ok then
      -- Set the on_attach function
      server_config.on_attach = server_config.on_attach or utils.on_attach

      -- Apply the config
      vim.lsp.config[server_name] = server_config

      -- Enable the server
      vim.lsp.enable(server_name)
    else
      -- Schedule the error notification to avoid blocking
      vim.schedule(function()
        vim.notify(
          "Failed to load LSP: " .. server_name,
          vim.log.levels.ERROR,
          { title = "LSP Error" }
        )
      end)
    end
  end
end

return M
