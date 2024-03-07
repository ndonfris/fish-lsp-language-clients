#!/usr/bin/env fish

### SETTING UP BOB IS RECOMMENDED FOR MANAGING NEOVIM VERSIONS
### NOT NECCESSARY IF YOU HAVE A RECENT VERSION OF NVIM v0.10.0>
### COMMENTED OUT COMMANDS ARE AN EXAMPLE OF A WORKING BOB INSTALLATION
# if not type -q bob
#     cargo install bob-nvim
# end
# bob install nightly
# bob use nightly-b8rF4e6S

# set -l local_nvim_fish_lsp_path (dirname)

alias nvim-fish-lsp='NVIM_APPNAME=nvim-fish-lsp nvim'
nvim-fish-lsp -es 'PlugClean' -i NONE -c 'qa'
if not test -d ./autoload/plugged/
    curl -fLo ~/.config/nvim-fish-lsp/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
end

nvim-fish-lsp -es 'PlugInstall' -i NONE -c 'qa'
nvim-fish-lsp -es 'PlugInstall | source $MYVIMRC' -i NONE -c 'qa'
nvim-fish-lsp -es 'CocInstall coc-json coc-tsserver' -i NONE -c 'qa'
# nvim-fish-lsp -es 'CocInstall coc-json coc-tsserver' -i NONE -c 'qa'

#echo "alias nvim-fish-lsp='NVIM_APPNAME=nvim-fish-lsp nvim' >> ~/.config/fish/config.fish"

#alias -s nvim-fish-lsp='NVIM_APPNAME=nvim-fish-lsp nvim'

# echo ""
# echo "SCRIPT CREATED TEMPORARY ALIAS 'nvim-fish-lsp' FOR CURRENT SESSION. "
# set_color -o white;
# and echo "alias nvim-fish-lsp='NVIM_APPNAME=nvim-fish-lsp nvim'" && echo ""
# set_color normal
# echo "TO CREATE A PERMANENT ALIAS, ADD PREVIOUS COMMAND TO `config.fish`"
# echo "                       ~OR~ "
# echo "RUN THE FOLLOWING COMMAND IN YOUR TERMINAL"
# set_color -o white
# printf "\n%s\n" $(cat ./global_alias)
#
