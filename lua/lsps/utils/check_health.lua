-- @module check_health

local M = {}

--- Checks if current Neovim version meets specified requirements.
--- @param required_major number|nil Major version requirement (default: 0)
--- @param required_minor number|nil Minor version requirement (default: 11)
--- @param required_patch number|nil Patch version requirement (default: 1)
--- @return table Result containing:
---   - meets_requirement boolean: Whether version requirement is met
---   - current table: Current Neovim version information
---   - required table: Required version information
function M.check_version(required_major, required_minor, required_patch)
  -- Set defaults if not provided
  required_major = required_major or 0
  required_minor = required_minor or 11
  required_patch = required_patch or 1

  local v = vim.version()
  local meets_requirement = false

  if v.major > required_major then
    meets_requirement = true
  elseif v.major == required_major and v.minor > required_minor then
    meets_requirement = true
  elseif v.major == required_major and v.minor == required_minor and v.patch >= required_patch then
    meets_requirement = true
  end

  return {
    meets_requirement = meets_requirement,
    current = v,
    required = { major = required_major, minor = required_minor, patch = required_patch },
  }
end

--- Checks if current Neovim version meets the required v0.11.1.
--- Displays a warning notification if requirement is not met.
--- @return nil
function M.check_nvim_version()
  local result = M.check_version()
  local v = result.current

  if not result.meets_requirement then
    vim.notify(
      string.format("Warning: Current Neovim v%d.%d.%d doesn't meet the required v0.11.1", v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      {
        title = " Neovim version check",
      }
    )
  end
end

return M
