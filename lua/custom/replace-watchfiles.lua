-- current _watchfiles implementation gives stutters
-- source: https://github.com/neovim/neovim/pull/23500#issuecomment-1554206149

require("vim.lsp._watchfiles")._watchfunc = require("vim._watch").watch
