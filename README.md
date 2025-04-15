<!-- markdownlint-disable-file -->
# fish-lsp-language-clients

A collection of lsp-clients for the [fish language server](https://github.com/ndonfris/fish-lsp.git).

Currently, there are 7 different client implementations included on [branches](https://github.com/ndonfris/fish-lsp-language-clients/branches) here:

- [x] [native-nvim](https://github.com/ndonfris/fish-lsp-language-clients/tree/native-nvim)
    - uses the built-in LSP client
    - no package manager or external dependencies (except for neovim v0.8+)
- [x] [helix](https://github.com/ndonfris/fish-lsp-language-clients/tree/helix)
   - setup for [helix](https://helix-editor.com/)
   - uses [languages.toml](https://github.com/ndonfris/fish-lsp-language-clients/blob/helix/languages.toml) example
- [x] [kickstart](https://github.com/ndonfris/fish-lsp-language-clients/tree/kickstart)
    - uses [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) as starting point
    - uses [lazy](https://github.com/folke/lazy.nvim) for lazy loading plugins
- [x] [coc-example](https://github.com/ndonfris/fish-lsp-language-clients/tree/coc_example)
    - a semi configured coc.nvim setup
    - includes telescope, telescope coc, noice, vim-plug, and a few other plugins
- [x] [coc-minimal](https://github.com/ndonfris/fish-lsp-language-clients/tree/coc-minimal)
    - includes the default coc.nvim setup
    - coc-settings.json includes fish-lsp
- [x] [vscode](https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp)
    - setup for [vscode](https://code.visualstudio.com/)
    - uses [vscode-fish-lsp](https://github.com/ndonfris/vscode-fish-lsp) repo for vscode extension
- [x] [BBEdit](https://github.com/ndonfris/fish-lsp-language-clients/tree/bbedit)
    - includes [language modules/fish.plist] for fish language support
    - includes documentation for hooking up the language server to BBEdit


## Usage

> [!NOTE]
> Don't forget to make sure your [fish-lsp](https://github.com/ndonfris/fish-lsp/) command is working
>
> ```fish
> fish-lsp --help-all
> fish-lsp start --dump
> fish-lsp info --time-startup
> ```

### Neovim

1. clone the repository into the `~/.config` directory
```fish
git clone https://github.com/ndonfris/fish-lsp-language-clients.git \
~/.config/fish-lsp-language-clients/
```
2. choose a client
```fish
# git branch -a
git checkout <CLIENT>
```
> client can be `kickstart`, `native-nvim`, `coc-example`, `coc-minimal`

3. Write an alias to use the client you've checked out, inside neovim

```fish
alias flc-conf='NVIM_APPNAME=fish-lsp-language-clients nvim ~/.config/fish/config.fish'
```

4. Run installation commands for the client you chose

| Client | Setup |
| --- | --- |
| native-nvim | `N/A` |
| kickstart | `:Lazy` |
| coc-example | `:PlugInstall` |
| coc-minimal | `:PlugInstall` |

5. Open the client
```fish
flc-conf
```

### Helix

Use the `languages.toml` file in the `helix` directory to add fish-lsp support to helix.

1. clone the repository
```fish
git clone https://github.com/ndonfris/fish-lsp-language-clients.git
cd fish-lsp-language-clients
```

2. Switch to the `helix` branch
```fish
git switch helix
```

2. copy the `languages.toml` file to your helix config directory
```fish
cat languages.toml >> ~/.config/helix/languages.toml
```

3. Open helix
```fish
hx ~/.config/fish/config.fish
```

### VSCode

use the [vscode plugin](https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp) to add fish-lsp support to vscode.

### BBEdit

1. clone the repository
```fish
git clone https://github.com/ndonfris/fish-lsp-language-clients.git 
cd fish-lsp-language-clients
```

2. Switch to the `bbedit` branch
```fish
git switch bbedit
```

3. use the [BBEdit](https://github.com/ndonfris/fish-lsp-language-clients/tree/bbedit) docs

## Contributing
If you would like to contribute, please open an issue or a pull request.
Non neovim client implementations are done by accessing the LSP server directly
through either command:
```fish
fish-lsp start
```
or
```fish
~/path/to/fish-lsp/out/cli.js start
```
