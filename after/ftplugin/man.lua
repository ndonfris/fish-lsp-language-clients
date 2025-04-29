
-- 
-- If manpages are not being displayed in neovim, you may need to set the MANPATH environment variable:
-- ```fish
-- set -agx MANPATH $__fish_data_dir/man
-- ```
vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", { noremap = true, buffer = true, silent = true, desc = "Close current manpage" })
vim.keymap.set("n", "g?", "<cmd>Man<cr>", { noremap = true, buffer = true, silent = true, desc = "Open manpage for current word" })

