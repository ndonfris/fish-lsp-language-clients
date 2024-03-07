----
---- below snippet is DEPRECATED after v0.10.0 
----    use `:Inspect` && `:InspectTree` instead
----
-- if vim.g.loaded_nvim_treesitter then 
--   local ts_utils = require 'nvim-treesitter.ts_utils'
--   --keymap('n', '<leader>n', '<cmd>lua P(' .. ts_utils.get_node_at_pos(0) ..')<cr>', opts)
--   --keymap('n', '<leader>nc', '<cmd>lua P(' .. ts_utils.get_named_children(0) ..')<cr>', opts)
-- end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader><cr><cr>', "<cmd>call CocAction('refreshSource', 'fishls')<cr>", opts)

keymap('n', 'gm', '<cmd>vertical Man<cr>', opts)

