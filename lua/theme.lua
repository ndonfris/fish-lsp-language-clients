-- Theme configuration
vim.cmd[[
  colorscheme dracula
  set termguicolors
  set background=dark
  set norelativenumber
  set cmdheight=0
  hi! Normal guibg=NONE ctermbg=NONE

  hi! FidgetTitle ctermbg=NONE guibg=NONE guifg=#000000
  hi! FidgetTask ctermbg=NONE guibg=NONE guifg=#ffffff
  hi! NormalFloat ctermbg=235 guifg=#8be9fd guibg=#21222c
  hi! FloatBorder ctermbg=235 guifg=#8be9fd guibg=#21222c 

  hi! CursorLineNr guibg=NONE guifg=#ffffff gui=bold

  hi! link NotifyBackground NormalFloat
]]
