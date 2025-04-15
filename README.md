# fish-lsp-language-clients

This should allow you to test the language server without having to install any
plugins or anything besides using a `neovim` version >= 0.8.0.

## Usage

```fish
NVIM_APPNAME=fish-lsp-language-client nvim ~/.config/fish/config.fish
alias fllc="NVIM_APPNAME=fish-lsp-language-client nvim ~/.config/fish/config.fish"
```

## Keymaps

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
