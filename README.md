<!-- markdownlint-disable-file -->
# fish-lsp-language-clients

A collection of lsp-clients for the [fish language server](https://github.com/ndonfris/fish-lsp.git).

Currently, there are 5 different client implementations:

- [x] [helix](https://github.com/ndonfris/fish-lsp-language-clients/tree/helix)
   - setup for [helix](https://helix-editor.com/)
   - uses [languages.toml](https://github.com/ndonfris/fish-lsp-language-clients/tree/helix/langauges.toml) example
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

> [!NOTE]
> Don't forget to make sure your [fish-lsp](https://github.com/ndonfris/fish-lsp/) command is working
>
> ```fish
> fish-lsp start
> ```

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
> client can be `kickstart`, `native-nvim`, `coc-example`, `coc-minimal` or
> `helix`

3. Setup the client if necessary _(varies across each setup)_

| Client | Setup |
| --- | --- |
| kickstart | `:Lazy` |
| native-nvim | `N/A` |
| coc-example | `:PlugInstall` |
| coc-minimal | `:PlugInstall` |
| helix | `N/A` | 

4. __(NEOVIM ONLY)__ Open the client (take advantage of the `NVIM_APPNAME` environment variable)
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
