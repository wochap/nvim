local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

ts_config.setup {
   ensure_installed = {
      "bash",
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
   },
}