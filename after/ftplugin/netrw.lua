--- mappings
if vim.g.enable_custom_keymaps then
  vim.cmd([[
    nmap <buffer> H u
    nmap <buffer> h -^
    nmap <buffer> l <CR>

    nmap <buffer> . gh
    nmap <buffer> P <C-w>z

    nmap <buffer> L <CR>
    nmap <buffer> <Leader>dd :Lexplore<CR>

    nmap <buffer><nowait><C-c> <cmd>close<CR>

    nmap <buffer><C-h> <C-w>h
    nmap <buffer><C-j> <C-w>j
    nmap <buffer><C-k> <C-w>k
    nmap <buffer><C-l> <C-w>l
  ]])
end

vim.b.did_ftplugin = 1

-- Netrw default settings
vim.g.netrw_banner = 0       -- Hide the banner
vim.g.netrw_liststyle = 3    -- Tree view
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_winsize = 25     -- Set width to 25% of the window
