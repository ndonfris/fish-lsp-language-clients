-- fix lua/config tab size
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.keymap.set('n', 'gd', 'K', { noremap = true, silent = true, buffer = true })
