local utils = require "custom.utils"
local lazyCoreUtils = require "lazy.core.util"
local lazyUtils = require "custom.utils.lazy"
local formatUtils = require "custom.utils.format"

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>lf",
        "<cmd>CustomFormat<CR>",
        desc = "format document/selection",
        mode = { "n", "v" },
      },
      {
        "<leader>lF",
        function()
          require("conform").format { formatters = { "injected" } }
        end,
        desc = "format injected langs in document/selection",
        mode = { "n", "v" },
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
          format = function(buf)
            local plugin = require("lazy.core.config").plugins["conform.nvim"]
            local Plugin = require "lazy.core.plugin"
            local opts = Plugin.values(plugin, "opts", false)
            require("conform").format(lazyCoreUtils.merge(opts.format, { bufnr = buf }))
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
      -- Nvim will use these options when formatting with the conform.nvim formatter
      format = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
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
