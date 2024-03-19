# fish-lsp-language-clients
A collection of neovim clients for the [fish language server](https://github.com/ndonfris/fish-lsp.git).
While all examples are shown with neovim, the clients should work with any LSP
compatible editor. __REQUIRES neovim v.0.10.0__ 

Currently there is 4 different client implementations:
- [x] [kickstart](https://github.com/ndonfris/fish-lsp-language-clients/tree/kickstart)
    - uses [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) as starting point
    - uses [lazy](https://github.com/folke/lazy.nvim) for lazy loading plugins
- [x] [native-nvim](https://github.com/ndonfris/fish-lsp-language-clients/tree/native-nvim)
    - uses the built-in LSP client
    - no package manager
    - extremely minimal implementation, only includes `hover`
- [x] [coc-example](https://github.com/ndonfris/fish-lsp-language-clients/tree/coc_example)
    - a semi configured coc.nvim setup
    - includes telescope, telescope coc, noice, vim-plug, and a few other plugins
- [x] [coc-minimal](https://github.com/ndonfris/fish-lsp-language-clients/tree/coc-minimal)
    - includes the default coc.nvim setup
    - coc-settings.json includes fish-lsp

## Usage

1. clone the repository into the `~/.config` directory
```fish
git clone https://github.com/ndonfris/fish-lsp-language-clients.git \
~/.config/nvim-fish-lsp-language-client/
```
2. choose a client
```fish
# git branch -a
git checkout <CLIENT>
```
> client can be `kickstart`, `native-nvim`, `coc-example`, or `coc-minimal`

3. Setup the client if necessary _(varies across each setup)_

| Client | Setup |
| --- | --- |
| kickstart | `:Lazy` |
| native-nvim | `N/A` |
| coc-example | `:PlugInstall` |
| coc-minimal | `:PlugInstall` |

4. open the client [take advantage of the `NVIM_APPNAME` environment variable]
```fish
alias fish-lsp-client='NVIM_APPNAME=nvim-fish-lsp-language-client nvim'
alias flc-conf="fish-lsp-client ~/.config/fish/config.fish"
```

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
