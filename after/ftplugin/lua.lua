-- fix lua/config tab size
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

if vim.g.enable_custom_keymaps then
  -- Add keymaps for navigating between buffers
  vim.keymap.set("n", "gd", "K", { noremap = true, silent = true, buffer = true })
end
