local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local formatUtils = require "custom.utils.format"
local langUtils = require "custom.utils.lang"

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    cmd = { "ConformInfo", "LazyFormat", "LazyFormatInfo" },
    event = "VeryLazy",
    keys = {
      {
        "<leader>lf",
        function()
          require("custom.utils.format").format { force = true }
        end,
        desc = "Format Buffer",
        mode = "n",
      },
      {
        "<leader>lf",
        function()
          require("custom.utils.format").format { force = true }
        end,
        desc = "Format Selection",
        mode = "v",
      },
      {
        "<leader>lF",
        function()
          require("conform").format { formatters = { "injected" } }
        end,
        desc = "Format Buffer (Injected Langs)",
        mode = "n",
      },
      {
        "<leader>lF",
        function()
          require("conform").format { formatters = { "injected" } }
        end,
        desc = "Format Selection (Injected Langs)",
        mode = "v",
      },
    },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

      utils.autocmd("User", {
        group = utils.augroup "install_formatter_cmds",
        pattern = "VeryLazy",
        callback = function()
          formatUtils.setup()
        end,
      })

      -- Install the conform formatter on VeryLazy
      lazyUtils.on_very_lazy(function()
        formatUtils.register {
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf, format_opts, cb)
            local opts = langUtils.tbl_merge({}, format_opts, { bufnr = buf })
            require("conform").format(opts, cb)
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        }
      end)
    end,
    opts = {
      default_format_opts = {
        async = true,
        quiet = false,
        -- timeout_ms = 1000, -- doesn't have effect if async is true
        lsp_format = "fallback",
      },
      formatters_by_ft = {},
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
    },
  },
}
