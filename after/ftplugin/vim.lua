
if vim.g.enable_custom_keymaps then
  -- Add keymaps for navigating between buffers
  vim.keymap.set("n", "gd", "K", { noremap = true, silent = true, buffer = true })

  local keymaps = require('keymaps')
  vim.keymap.set('n', '<leader>w', keymaps.source_nvim_config_file, { 
    noremap = true,
    silent = true,
    nowait = true,
    desc = "write and source *.{lua,vim} config files",
    buffer = true,
  })
end
