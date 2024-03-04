local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local constants = require "custom.utils.constants"
local in_neorg = require("custom.utils.constants").in_neorg
local in_leetcode = require("custom.utils.constants").in_leetcode
local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
    },
  },

  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        filetypes = constants.exclude_filetypes,
      },
      hide = {
        focused_win = true,
        only_win = true,
      },
      window = {
        margin = {
          horizontal = 0,
          vertical = 1,
        },
      },
      render = function(props)
        local bufnr = props.buf
        local icon = "󰈚 "
        local modified_indicator = "  "
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "No Name"

        if filename ~= "No Name" then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon, _ = devicons.get_icon(filename)
            icon = (ft_icon ~= nil and ft_icon .. " ") or icon
          end
        end

        if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          modified_indicator = " "
        end

        return { { icon }, { filename }, { modified_indicator } }
      end,
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    enabled = not in_kittyscrollback and not in_leetcode and not in_neorg,
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "ufo open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "ufo open all folds",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "ufo close folds with",
      },
    },
    init = function()
      vim.opt.foldcolumn = "1" -- '0' is not bad
      vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- HACK: don't setup this autocmd until lazy.nvim is installed
      -- otherwise it will throw a bunch of errors
      if constants.lazyPathExists then
        utils.autocmd("FileType", {
          group = utils.augroup "hide_ufo_folds",
          pattern = constants.exclude_filetypes,
          callback = function()
            utils.disable_ufo()
          end,
        })
      end
    end,
    opts = {
      open_fold_hl_timeout = 400,
      close_fold_kinds = {},
      enable_get_fold_virt_text = false,
      preview = {
        win_config = {
          border = "single",
          winblend = 0,
          winhighlight = "Normal:UfoPreviewNormal",
        },
        mappings = {
          scrollE = "",
          scrollY = "",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          close = "<C-e>",
        },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
        return newVirtText
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- nvim-ufo capabilities
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    enabled = not in_kittyscrollback and not in_leetcode and not in_neorg,
    lazy = false,
    init = function()
      -- HACK: statuscol doesn't reset signcolumn
      utils.autocmd("FileType", {
        group = utils.augroup "reset_signcolumn_on_statuscol_excluded_filetypes",
        pattern = constants.exclude_filetypes,
        callback = function()
          vim.opt_local.signcolumn = "yes"
        end,
      })

      utils.autocmd({ "CmdlineLeave", "CmdlineEnter" }, {
        group = utils.augroup "turn_off_flash_search",
        callback = function()
          local has_flash, flash = pcall(require, "flash")
          if not has_flash then
            return
          end
          pcall(flash.toggle, false)
        end,
      })
    end,
    opts = function()
      local builtin = require "statuscol.builtin"
      return {
        ft_ignore = constants.exclude_filetypes,
        bt_ignore = constants.exclude_buftypes,
        segments = {
          -- {
          --   text = { "%s" },
          --   condition = { true },
          --   click = "v:lua.ScSa",
          -- },
          {
            text = { " " },
            condition = { true },
          },
          {
            sign = { name = { "Dap*" }, namespace = { "bulb*" } },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { namespace = { "gitsign*" }, colwidth = 1 },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.foldfunc, "  " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>fK",
        "<Cmd>BufferLineCloseOthers<CR>",
        desc = "close other buffers!",
      },
      {
        "<S-Right>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "goto next buffer",
      },
      {
        "<S-Left>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "goto prev buffer",
      },
    },
    init = function()
      vim.opt.termguicolors = true

      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    config = function(_, opts)
      lazyUtils.on_load("catppuccin", function()
        local bufferline = require "bufferline"
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        bufferline.setup(vim.tbl_deep_extend("force", {}, opts, {
          options = {
            themable = true,
            numbers = function(_opts)
              return string.format("%s", _opts.raise(_opts.ordinal))
            end,
            close_command = function(n)
              require("mini.bufremove").delete(n, false)
            end,
            right_mouse_command = function(n)
              require("mini.bufremove").delete(n, false)
            end,
            indicator = {
              style = "none",
            },
            show_buffer_close_icons = false,
            show_close_icon = false,
            get_element_icon = function(element)
              local icon, hl = require("nvim-web-devicons").get_icon(element.path)
              if vim.api.nvim_get_current_buf() == vim.fn.bufnr(element.path) then
                print(element.path)
                return icon, hl
              end
              return icon, "DevIconDimmed"
            end,
            separator_style = { "", "" },
            always_show_bufferline = true,
            hover = { enabled = false },
          },
          highlights = require("catppuccin.groups.integrations.bufferline").get {
            styles = {},
            custom = {
              mocha = {
                background = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                fill = {
                  bg = mocha.base,
                },
                tab = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                tab_selected = {
                  bg = mocha.base,
                  fg = mocha.lavender,
                },
                tab_separator = {
                  bg = mocha.base,
                },
                tab_separator_selected = {
                  bg = mocha.base,
                },
                buffer_visible = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                buffer_selected = {
                  fg = mocha.lavender,
                },
                numbers = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                numbers_visible = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                numbers_selected = {
                  bg = mocha.base,
                  fg = mocha.lavender,
                },
                modified = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                modified_visible = {
                  bg = mocha.base,
                  fg = mocha.surface1,
                },
                modified_selected = {
                  fg = mocha.green,
                },
                indicator_visible = {
                  bg = mocha.base,
                },
              },
            },
          },
        }))
      end)
    end,
  },

  {
    "fladson/vim-kitty",
    event = { "LazyFile", "VeryLazy" },
    ft = "kitty",
  },
}
