local M = {}

M.options = {
  enhanced_diff_hl = false,
  show_help_hints = false,
  file_panel = {
    listing_style = "list",
  },
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          diff_merges = "first-parent",
        },
      },
    },
  },
  hooks = {
    diff_buf_read = function()
      vim.opt_local.wrap = false
    end,
    diff_buf_win_enter = function(bufnr, winid, ctx)
      if ctx.layout_name:match "^diff2" then
        if ctx.symbol == "a" then
          vim.opt_local.winhl = table.concat({
            "DiffAdd:DiffviewDiffAddAsDelete",
            "DiffDelete:DiffviewDiffDeleteSign",
            "DiffChange:DiffviewDiffDelete",
            "DiffText:DiffviewDiffDeleteText",
          }, ",")
        elseif ctx.symbol == "b" then
          vim.opt_local.winhl = table.concat({
            "DiffDelete:DiffviewDiffDeleteSign",
            "DiffChange:DiffviewDiffAdd",
            "DiffText:DiffviewDiffAddText",
          }, ",")
        end
      end
    end,
  },
}

return M
