# NVIM

[NVChad](https://github.com/NvChad/NvChad) plus custom config

![](https://i.imgur.com/crVtEOp.jpg)
![](https://i.imgur.com/QYfnIJz.jpg)
![](https://i.imgur.com/C6Gr0u6.jpg)

## Getting started

```sh
$ git clone git@github.com:wochap/nvim.git ~/.config/nvim
$ cd ~/.config/nvim
$ git remote add nvchad https://github.com/NvChad/NvChad.git
$ nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"
$ nvim
```

## Updating NvChad

```
$ git remote add nvchad git@github.com:NvChad/NvChad.git
$ git fetch nvchad
$ git rebase --rebase-merges nvchad/v2.0
```

## Troubleshooting

-  Anything Eslint related

   Run in nvim

   ```
   :w
   :e
   ```

## Dependencies

-  [neovim nightly](https://github.com/neovim/neovim)
-  tree-sitter

Required by [Telescope](https://github.com/nvim-telescope/telescope.nvim)

-  ripgrep
-  fd

Required by [NullLS](https://github.com/jose-elias-alvarez/null-ls.nvim)

-  localPkgs.customNodePackages."@fsouza/prettierd"
-  localPkgs.customNodePackages.markdownlint
-  localPkgs.customNodePackages.stylelint
-  lua51Packages.luacheck
-  nixfmt
-  nodePackages.eslint_d
-  python39Packages.pylint
-  shellcheck
-  shfmt
-  statix
-  stylua

Required by [lspconfig](https://github.com/neovim/nvim-lspconfig)

-  clang-tools
-  rnix-lsp
-  flow
-  sumneko-lua-language-server

-  @tailwindcss/language-server
-  cssmodules-language-server
-  emmet-ls
-  bash-language-server
-  svelte-language-server
-  vscode-langservers-extracted
-  typescript
-  typescript-language-server

Required by [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)

-  [vscode-node-debug2](https://github.com/microsoft/vscode-node-debug2) on `~/dev/microsoft/vscode-node-debug2`
-  [vscode-chrome-debug](https://github.com/Microsoft/vscode-chrome-debug) on `~/dev/microsoft/vscode-chrome-debug`
-  ts-node
