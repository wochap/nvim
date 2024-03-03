local M = {}

M.options = {
  default_mappings = {
    ours = "<leader>gco",
    theirs = "<leader>gct",
    none = "<leader>gc0",
    both = "<leader>gcb",
    next = "]c",
    prev = "[c",
  },
}

M.setup = function(opts)
  vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function(event)
      local has_wk, wk = pcall(require, "which-key")
      if not has_wk then
        return
      end

      wk.register({
        ["<leader>gc"] = { name = "git conflict" },
      }, { buffer = event.buf })
    end,
  })

  require("git-conflict").setup(opts)
end

return M
