# NVIM

The perfect blazingly fast Neovim configuration for myself, combining the aesthetics of NvChad with the LSP, formatter and lint configurations from LazyVim.

![](https://i.imgur.com/MrlK5Xg.jpg)

## Getting started

```sh
$ git clone git@github.com:wochap/nvim.git ~/.config/nvim
$ nvim
```

### Vue projects

Create a file `.volar` in the root of your project to disable typescript-tools and enable tsserver, only tsserver can use @vue/typescript-plugin for now...

## Troubleshooting

- Anything Eslint related

  Run in nvim

  ```
  :w
  :e
  ```

  If that didn't work, kill all eslint processes

## Requirements

Any requirement from [Mason](https://github.com/williamboman/mason.nvim#requirements), Mason will install [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [conform.nvim](https://github.com/stevearc/conform.nvim), [nvim-lint](https://github.com/mfussenegger/nvim-lint) and [nvim-dap](https://github.com/mfussenegger/nvim-dap) dependencies

- [neovim >= 0.9.4](https://github.com/neovim/neovim)
- [neovim-remote](https://github.com/mhinz/neovim-remote)
- [kitty](https://sw.kovidgoyal.net/kitty) (recommended)
- [tree-sitter](https://github.com/tree-sitter/tree-sitter)
- ripgrep (required by [telescope](https://github.com/nvim-telescope/telescope.nvim)
  )
- fd (required by [telescope](https://github.com/nvim-telescope/telescope.nvim))
- deno (required by [peek](https://github.com/toppair/peek.nvim))
- nixfmt (required by [conform.nvim](https://github.com/stevearc/conform.nvim))
- statix (required by [nvim-lint](https://github.com/mfussenegger/nvim-lint))
- [ts-node](https://www.npmjs.com/package/ts-node) (required by [nvim-dap](https://github.com/mfussenegger/nvim-dap))
- [typescript](https://www.npmjs.com/package/typescript) (required by [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig))
- [@vue/typescript-plugin](https://www.npmjs.com/package/@vue/typescript-plugin) (required by [typescript-tools.nvim](https://www.npmjs.com/package/@vue/typescript-plugin) and [tsserver](https://github.com/typescript-language-server/typescript-language-server))
