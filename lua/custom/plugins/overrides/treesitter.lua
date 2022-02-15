local plugin_settings = require("core.utils").load_config().plugins
local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg = {
   install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
   },
}

parser_configs.norg_meta = {
   install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
      files = { "src/parser.c" },
      branch = "main",
   },
}

parser_configs.norg_table = {
   install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
      files = { "src/parser.c" },
      branch = "main",
   },
}

local default = {
   textsubjects = {
      enable = true,
      keymaps = {
         ["g."] = "textsubjects-smart",
         ["g,"] = "textsubjects-container-inner",
         ["g;"] = "textsubjects-container-outer",
      },
   },
   indent = {
      enable = true,
   },
   matchup = {
      enable = true,
   },
   autopairs = {
      enable = true,
   },
   autotag = {
      enable = plugin_settings.status.autotag,
   },
   context_commentstring = {
      enable = true,
      enable_autocmd = false,
   },
   ensure_installed = {
      "norg",
      "norg_meta",
      "norg_table",
      "c",
      "css",
      "graphql",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "nix",
      "python",
      "svelte",
      "toml",
      "typescript",
      "vim",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = {},
      -- Disable in large buffers
      disable = function(lang, bufnr)
         return vim.api.nvim_buf_line_count(bufnr) > 10000
      end,
   },
   incremental_selection = {
      enable = true,
   },
}

ts_config.setup(default)
