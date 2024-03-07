# fish-lsp-language-clients

1. show all clients
```fish
git clone https://github.com/ndonfris/fish-lsp-language-clients.git ~/.config/fish-lsp-language-client/
git branch -a | string match -re "remotes/*" | string match -ve "remotes/origin/master"
```

2. choose a client
```fish
git checkout -b <client>
```

3. setup your configuration
- varies from client to client 
- _(potentially)_ optional


4. open the client [take advantage of the `NVIM_APPNAME` environment variable]
```fish
alias fish-lsp-client='NVIM_APPNAME=fish-lsp-language-client nvim'
alias flc-conf="fish-lsp-client ~/.config/fish/config.fish"
```
