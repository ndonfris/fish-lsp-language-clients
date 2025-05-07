
-- Fish shell configuration
-- This file contains settings and key mappings for the Fish shell in Neovim.
-- 

-- Key mappings:

-- Open the current word in a split manpage.
-- If manpages are not being displayed in neovim, you may need to set the MANPATH environment variable: 
-- ```fish                                                                                              
-- set -agx MANPATH $__fish_data_dir/man                                                                
-- ```                                                                                                  
if vim.g.enable_custom_keymaps then
  vim.keymap.set('n', 'g?', '<cmd>silent vertical Man<cr>', { noremap = true, buffer = true, silent = true, desc = "Open manpage for current word" })
end

-- vim.o.compiler = 'fish'

vim.b.current_compiler = 'fish'

