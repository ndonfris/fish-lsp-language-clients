-- A module to allow for easily opening terminal buffers from inside this configuration.
local M = {}

function M.open_terminal()
  vim.cmd("terminal")
  vim.cmd("startinsert")
end

function M.open_bottom_terminal()
  vim.cmd("belowright terminal")
  vim.cmd("startinsert")
end

-- Create a command
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- Disable line numbers in terminal
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.buflisted = false

    -- Start in insert mode
    vim.cmd("startinsert")

    if vim.g.enable_custom_keymaps then
      -- Add terminal-specific keymaps
      vim.keymap.set("t", "<C-c>", [[<C-\><C-n><C-\><C-n>]], { buffer = true })
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true })
      -- Horizontal resize in terminal mode
      vim.keymap.set('t', '<M-k>', '<C-\\><C-n>:horizontal resize +5<CR>i', {desc = "Increase terminal width"})
      vim.keymap.set('t', '<M-j>', '<C-\\><C-n>:horizontal resize -5<CR>i', {desc = "Decrease terminal width"})
      vim.keymap.set('t', '<M-h>', '<C-\\><C-n>:vertical resize +5<CR>i', {desc = "Increase terminal width"})
      vim.keymap.set('t', '<M-l>', '<C-\\><C-n>:vertical resize -5<CR>i', {desc = "Decrease terminal width"})

      vim.keymap.set("n", "<C-c>", '<cmd>bd!<CR>', { buffer = true, silent = true, noremap = true, desc = "close terminal buffer", nowait = true })
    end
  end,
})

return M
