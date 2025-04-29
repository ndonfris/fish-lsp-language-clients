local M = {}

function M.open_terminal()
  vim.cmd('terminal')
  vim.cmd('startinsert')
end

-- Create a command
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- Disable line numbers in terminal
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    
    -- Start in insert mode
    vim.cmd('startinsert')
    
    -- Add terminal-specific keymaps
    vim.keymap.set('t', '<C-c>', [[<C-\><C-n><C-\><C-n>]], {buffer = true})
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], {buffer = true})
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-W>h]], {buffer = true})
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>j]], {buffer = true})
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>k]], {buffer = true})
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-W>l]], {buffer = true})
  end
})

return M

