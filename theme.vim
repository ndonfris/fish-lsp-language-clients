set termguicolors
set background=dark
colorscheme wildcharm
set laststatus=2


hi! Normal guibg=NONE ctermbg=NONE
hi! SignColumn guibg=NONE ctermbg=NONE
hi! CursorLineNr guibg=#000 guifg=#4547ad gui=NONE,bold ctermbg=black ctermfg=4 cterm=bold
hi! StatusLine guibg=#2b2f54 ctermbg=NONE

lua << EOF
local status_line = function()
  return [[
    %<%f%h%m%r%=%-14.(%l,%c%V%)
  ]]
end
-- local buf = "#" ..  vim.api.nvim_win_get_buf(vim.g.statusline_winid)
-- local filename = (fn.expand(buf) == "" and "Empty") or fn.expand(buf .. ":t")
vim.opt.statusline = status_line()
EOF
