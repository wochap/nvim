# NVIM

[NVChad](https://github.com/NvChad/NvChad) plus [LazyVim](https://github.com/LazyVim/LazyVim) plus my custom config

![](https://i.imgur.com/jsCnGLI.jpg)

## Getting started

```sh
$ git clone git@github.com:wochap/nvim.git ~/.config/nvim
$ cd ~/.config/nvim
$ git remote add nvchad https://github.com/NvChad/NvChad.git
$ nvim
```

## Troubleshooting

- Anything Eslint related

  Run in nvim

  ```
  :w
  :e
  ```

## Dependencies

Any requirement from [Mason](https://github.com/williamboman/mason.nvim#requirements), Mason will install [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [null-ls](https://github.com/nvimtools/none-ls.nvim) and [nvim-dap](https://github.com/mfussenegger/nvim-dap) dependencies

- [neovim >= 0.9.1](https://github.com/neovim/neovim)
- [neovim-remote](https://github.com/mhinz/neovim-remote)
- [tree-sitter](https://github.com/tree-sitter/tree-sitter)
- ripgrep (required by [Telescope](https://github.com/nvim-telescope/telescope.nvim)
  )
- fd (required by [Telescope](https://github.com/nvim-telescope/telescope.nvim))
- deno (required by [peek](https://github.com/toppair/peek.nvim))
- deadnix (required by [NullLS](https://github.com/nvimtools/none-ls.nvim))
- nixfmt (required by [NullLS](https://github.com/nvimtools/none-ls.nvim))
- statix (required by [NullLS](https://github.com/nvimtools/none-ls.nvim))
- [ts-node](https://www.npmjs.com/package/ts-node) (required by [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap))
