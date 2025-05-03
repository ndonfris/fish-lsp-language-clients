<!-- markdownlint-disable-file -->
# fish-lsp-language-clients

This should allow you to test the language server by creating a standalone [`neovim`](https://neovim.io/) configuration, as long as you have a `nvim` version >= 0.8.0. 

![](./packer-nvim.png)

It uses [packer.nvim](https://github.com/wbthomason/packer.nvim) with some [plug-ins](./lua/plugins.lua) to help provide QOL features for interacting with the [fish-lsp](https://github.com/ndonfris/fish-lsp). The current configuration is only using a couple of plug-ins, and tries to take advantage of using the native-lsp api. 

## Usage

This branch comes with most features enabled through relatively normal [keybindings](#Keymaps) and a few custom ones. 

It also comes with an [`alias.fish`](./alias.fish) file that allows for quickly testing the language server. 

If you want to continue using this branch to test the language server, see the __persistent autoloading__ [option on the `alias.fish` script](#custom-usage)

#### Default usage (like other branches)

<!-- NVIM_APPNAME=fish-lsp-language-clients nvim ~/.config/fish/config.fish -->
```fish
alias flc-conf="NVIM_APPNAME=fish-lsp-language-clients nvim ~/.config/fish/config.fish"
```

#### Custom Usage

Use the [`alias.fish`](./alias.fish) file, to quickly access the working client configuration for the language server.

```fish
# single session autoloading 
source ./alias.fish -q --persistent-autoload | source

# persistent autoloading across all future sessions
source ./alias.fish -q --persistent-autoload > $__fish_config_dir/conf.d/__check_lsp_dir.fish
echo '__check_lsp_dir' >> $__fish_config_dir/conf.d/__check_lsp_dir.fish
```

## Keymaps

> [!NOTE]
> Which key is included in this config, so you can interactively see a keymapping

<div align="center">

| Keymap | Mode | Description |
|--------|-------------|-------------|
| `C-space` | insert  | Trigger completion |
| `C-j` | insert  | move down completion menu |
| `C-k` | insert  | move up completion menu |
| `C-d` | insert  | scroll down completion menu |
| `C-u` | insert  | scroll up completion menu |
| `C-d` | normal  | scroll down hover doc or normal scroll |
| `C-u` | normal  | scroll up hover doc or normal scroll |
| `gs` | normal  | show hover doc |
| `K` | normal  | show hover doc |
| `gd` | normal  | go to definition |
| `gi` | normal  | go to implementation |
| `gr` | normal  | get references |
| `<leader>rn` | normal  | rename symbol |
| `<leader>f` | normal  | format document |
| `<leader>ca` | normal  | code action |
| `gca` | normal  | code action |
| `<C-s>` | insert | show signature help |
| `<leader>e` | normal | show diagnostics |
| `gen` | normal | go to next diagnostic error |
| `gep` | normal | go to next diagnostic error |
| `<leader>qf` | normal | quickfix list |
| `<leader>i` | normal | show tree-sitter tree |
| `<leader><C-t>` | normal | open terminal buffer |
| `<leader><C-b>` | normal | open bottom split terminal buffer |
| `<leader>gc` | normal | toggle comment |
| `g?` | normal | show man page for word under cursor |
| `gfo` | normal | enable folds for buffer |

</div>
