# NVIM

The perfect blazingly fast Neovim configuration for myself, combining the aesthetics of [NvChad](https://github.com/NvChad/NvChad) with the LSP, formatter and lint configurations from [LazyVim](https://github.com/LazyVim/LazyVim).

![](https://i.imgur.com/cz9UoNW.jpg)
![](https://i.imgur.com/i9nau76.jpg)

## Installation

```sh
$ git clone git@github.com:wochap/nvim.git ~/.config/nvim
$ nvim
# Wait for lazy.nvim to finish and restart nvim
# NOTE: errors on the first time opening nvim with this config are expected
```

**IMPORTANT:** I disabled nvim builtin syntax which caused severe lag on my system, re enable it commenting out the line `lua/custom/init.lua:6`. Alternatively, you can install the Treesitter parser for the specified language or enable syntax for that specified filetype in the current buffer with `:set syntax=<filetype>`.

### Vue projects

Create a file `.volar` in the root of your project to disable typescript-tools and enable tsserver, only tsserver can use @vue/typescript-plugin for now...

## Troubleshooting

- Lag

  Try disabling `statuscol.nvim` plugin

- Anything Eslint related

  Run in nvim

  ```
  :w
  :e
  ```

  If that didn't work, kill all eslint processes

- Python LSP/Linters installed by Mason stopped working

  Uninstall them and install them again

## Requirements

Any requirement from [Mason](https://github.com/williamboman/mason.nvim#requirements), Mason will install [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [conform.nvim](https://github.com/stevearc/conform.nvim), [nvim-lint](https://github.com/mfussenegger/nvim-lint) and [nvim-dap](https://github.com/mfussenegger/nvim-dap) dependencies

- [neovim >= 0.10.0](https://github.com/neovim/neovim)
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

## Tips to learn to use this nvim config

- Learn [https://github.com/folke/lazy.nvim](https://github.com/folke/lazy.nvim), then remove all lazy.nvim plugin specs that you are not going to use in `lua/custom/plugins/*`. For example, if you don't use neorg remove `neorg.lua`, if you don't code zig, remove `lang-zig.lua`. If you don't use Kitty, remove `mikesmithgh/kitty-scrollback.nvim` and `mrjones2014/smart-splits.nvim`.
- Keymaps are located in `lua/custom/keymaps.lua` (global), `lua/custom/plugins/lsp/keymaps.lua` (active when an LSP server is running), and within each plugin spec.
- If you need autoformatting on save, create an autocmd that calls `conform.nvim`.
- Formatting, linting, and LSP config are the same as in Lazyvim, so feel free to import extras from Lazyvim, and add LSP servers in the same manner you did in Lazyvim.
- If you use a different theme than catppuccino, replace the plugin spec in `lua/custom/plugins/colorscheme/init.lua`. Also, update the configurations for lualine, bufferline, and lazy.nvim.

Lastly read all lua files 😅, starting from `lua/custom/init.lua`
