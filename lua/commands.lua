---@diagnostic disable: lowercase-global
--
function get_lsp_position()
   local cursor_pos = vim.api.nvim_win_get_cursor(0)
  
  -- Convert cursor position to LSP Position (0-indexed for both line and character)
  local position = {
    line = cursor_pos[1] - 1,  -- Convert from 1-indexed to 0-indexed
    character = cursor_pos[2]  -- Already 0-indexed
  }
  return position
end
  

-- function show_fish_lsp_workspace()
--   vim.lsp.buf.execute_command({
--     command = "fish-lsp.showWorkspaceMessage",
--     arguments = {}
--   })
-- end
--
-- -- Optional: Map it to a key
-- vim.keymap.set('n', '<leader>fw', show_fish_lsp_workspace, { desc = "Show Fish Workspace" })
--
-- function update_fish_lsp_workspace()
--   vim.lsp.buf.execute_command({
--     command = "fish-lsp.updateWorkspace",
--     arguments = {
--       vim.fn.expand('%:p:h'),
--     }
--   })
-- end
-- Function to execute the showWorkspaceMessage command
function fish_show_workspace_message()
  vim.lsp.buf.execute_command({
    command = "fish-lsp.showWorkspaceMessage",
    arguments = {}
  })
end

-- Function to update workspace
function fish_update_workspace(buffer_path)
  local path = buffer_path or vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.updateWorkspace",
    arguments = {path}
  })
end

-- Function to update configuration
function fish_update_config()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.updateConfig",
    arguments = {buffer_path}
  })
end

function fish_lsp_show_references()
  local buffer_path = vim.api.nvim_buf_get_name(0)

  local position = get_lsp_position()

  vim.lsp.buf.execute_command({
    command = "fish-lsp.showReferences",
    arguments = {
      buffer_path,
      position,
      {},
    }
  })
end

-- Function to update workspace to current buffer's directory
function fish_update_workspace_current()
  -- Get the path of the current buffer
  local buffer_path = vim.api.nvim_buf_get_name(0)

  -- Extract the directory from the full path
  local buffer_dir = vim.fn.fnamemodify(buffer_path, ":p:h")

  -- If it's a fish file, go up to the fish config directory when appropriate
  if vim.fn.fnamemodify(buffer_path, ":e") == "fish" then
    -- Check if we're in one of the standard fish directories
    local fish_dirs = {"functions", "conf.d", "completions"}
    local dir_name = vim.fn.fnamemodify(buffer_dir, ":t")

    if vim.tbl_contains(fish_dirs, dir_name) then
      -- Go up one directory to get the fish config root
      buffer_dir = vim.fn.fnamemodify(buffer_dir, ":h")
    end
  end

  -- Execute the command with the buffer directory
  vim.lsp.buf.execute_command({
    command = "fish-lsp.updateWorkspace",
    arguments = {buffer_dir}
  })

  -- Optional: Provide feedback to the user
  vim.notify("Fish workspace updated to: " .. buffer_dir, vim.log.levels.INFO)
end

function fish_execute_buffer()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.executeBuffer",
    arguments = {buffer_path}
  })
end

function fish_execute_line()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local buffer_path = vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.executeLine",
    arguments = {buffer_path, line_number}
  })
end

function fish_create_theme()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.createTheme",
    arguments = {buffer_path}
  })
end

function fish_fix_all()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  vim.lsp.buf.execute_command({
    command = "fish-lsp.fixAll",
    arguments = {buffer_path}
  })
end

function fish_toggle_single_workspace_support()
  vim.lsp.buf.execute_command({
    command = "fish-lsp.toggleSingleWorkspaceSupport",
    arguments = {}
  })
end

function fish_create_env_variables()
  local buffer_path = vim.api.nvim_buf_get_name(0)

  vim.lsp.buf.execute_command({
    command = "fish-lsp.generateEnvVariables",
    arguments = {buffer_path}
  })
end

-- Create Neovim commands
vim.api.nvim_create_user_command("FishExecute", fish_execute_buffer, {})
vim.api.nvim_create_user_command("FishExecuteLine", fish_execute_line, {})
vim.api.nvim_create_user_command("FishExecuteTheme", fish_execute_line, {})
vim.api.nvim_create_user_command("FishShowWorkspace", fish_show_workspace_message, {})
vim.api.nvim_create_user_command("FishUpdateWorkspaceCurrent", fish_update_workspace_current, {})
vim.api.nvim_create_user_command("FishUpdateConfig", fish_update_config, {})
vim.api.nvim_create_user_command("FishUpdateWorkspace", function(opts)
  fish_update_workspace(opts.args)
end, {nargs = 1})
vim.api.nvim_create_user_command("FishCreateTheme", fish_create_theme, {})
vim.api.nvim_create_user_command("FishFixAll", fish_fix_all, {})
vim.api.nvim_create_user_command("FishToggleSingleWorkspaceSupport", fish_toggle_single_workspace_support, {})
vim.api.nvim_create_user_command("FishCreateEnvVariables", fish_create_env_variables, {})


-- Optional: Add keymappings
vim.keymap.set('n', '<leader>fw', fish_show_workspace_message, { desc = "Show Fish Workspace" })
vim.keymap.set('n', '<leader>fwc', fish_update_workspace_current, { desc = "Update Fish Workspace to Current Buffer" })
vim.keymap.set('n', '<leader>fc', fish_update_config, { desc = "Update Fish Config" })
vim.keymap.set('n', '<leader>feb', fish_execute_buffer, { desc = "Execute Fish Buffer" })
vim.keymap.set('n', '<leader>fel', fish_execute_line, { desc = "Execute Fish Line" })
vim.keymap.set('n', '<leader>fct', fish_create_theme, { desc = "Create Fish Theme" })
vim.keymap.set('n', '<leader>ff', fish_fix_all, { desc = "Fix All Fish" })
vim.keymap.set('n', '<leader>fev', fish_create_env_variables, { desc = "Create Fish Env Variables" })

--
-- Optional: Add keymapping
