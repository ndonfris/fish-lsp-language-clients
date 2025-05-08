-- fix lua/config tab size
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.b.shiftwidth = 2

if vim.g.enable_custom_keymaps then
  -- Add keymaps for navigating between buffers
  vim.keymap.set("n", "gd", "K", { noremap = true, silent = true, buffer = true })

  -- add autosave alias keymap
  local keymaps = require('keymaps')
  vim.keymap.set('n', '<leader>w', keymaps.source_nvim_config_file, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "write and source *.{lua,vim} config files",
    buffer = true,
  })

  vim.keymap.set({ "x", "v" }, "<leader><cr>", function()
      -- Save selection to register x without moving cursor
      vim.cmd('normal! gv"xy')

      -- Get text from register x
      local code = vim.fn.getreg('x')

      -- Load the code
      local func, err = load(code, "selected code", "t", _G)

      local notify_opts = { title = 'exected lua source code' }

      if not func then
        vim.notify("Error compiling Lua: " .. tostring(err), vim.log.levels.ERROR, notify_opts)
        return
      end

      -- Execute the function
      local success, result = pcall(func)

      if success then
        vim.notify("Lua code executed successfully", vim.log.levels.INFO, notify_opts)
        if result ~= nil then
          vim.notify("Result: " .. vim.inspect(result), vim.log.levels.INFO, notify_opts)
        end
      else
        vim.notify("Error executing Lua: " .. tostring(result), vim.log.levels.ERROR, notify_opts)
      end
    end,
    { buffer = true, desc = "Evaluate selected Lua code", noremap = true }
  )
end

vim.cmd([[
  autocmd BufEnter,VimEnter,BufNew *.lua setlocal sw=2
]])
