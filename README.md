# NVIM

[NVChad](https://github.com/NvChad/NvChad) + [LazyVim](https://github.com/LazyVim/LazyVim) plus my custom config

![](https://i.imgur.com/jsCnGLI.jpg)

## Getting started

```sh
$ git clone git@github.com:wochap/nvim.git ~/.config/nvim
$ cd ~/.config/nvim
$ git remote add nvchad https://github.com/NvChad/NvChad.git
$ nvim
```

### Vue projects

Create a file `.volar` in the root of your project to enable volar and volar "Take over mode"

## Troubleshooting

- Theme looking weird

  Delete `~/.local/share/nvim/lazy/base46` and delete everything inside `~/.local/share/nvim/base46` except cmp, devicons nvcheatsheet tbline

- Anything Eslint related

  Run in nvim

  ```
  :w
  :e
  ```

## Changes made to nvchad core

- `init.lua`
  - import `custom/keymaps.lua`
  - prevent loading of cached defaults highlight groups
- `lua/core/init.lua`
  - fix ReloadNvChad autocmd to correctly reload modules
- `lua/plugins/configs/cmp.lua`
  - prevent loading of cached cmp highlight groups

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
- [@styled/typescript-styled-plugin](https://www.npmjs.com/package/@styled/typescript-styled-plugin) (required by [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim#-styled-components-support))
