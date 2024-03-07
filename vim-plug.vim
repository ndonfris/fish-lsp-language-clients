if empty(glob('~/.config/nvim-fish-lsp/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim-fish-lsp/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC 
endif

call plug#begin('~/.config/nvim-fish-lsp/autoload/plugged')
  " Use release branch (recommended)
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-treesitter/nvim-treesitter'

  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'fannheyward/telescope-coc.nvim'

  " fish helper 
  Plug 'dag/vim-fish'

  " surround
  Plug 'kylechui/nvim-surround'

  " colorscheme
  " Plug 'mofiqul/dracula.nvim'
  " Plug 'folke/tokyonight.nvim'
  " Plug 'liuchengxu/space-vim-theme'
  " Plug 'liuchengxu/space-vim-dark'
call plug#end()
