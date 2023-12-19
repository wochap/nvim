return {
  {
    "NvChad/base46",
    lazy = false,
    branch = false,
    url = "https://github.com/wochap/base46.git",
    commit = "e557b6ecd12520d23207e30cbd6a6f3bc9cedb5f",
    config = function()
      if not vim.loop.fs_stat(vim.g.base46_cache) then
        return
      end
      -- Force nvchad theme load
      for _, file in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
        dofile(vim.g.base46_cache .. file)
      end
    end,
  },
  {
    -- NOTE: it causes flickering when indenting lines
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    version = false,
    event = "LazyFile",
    init = function() end,
    opts = function()
      return require("custom.custom-plugins.overrides.blankline").options
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      require("ibl").setup(opts)
    end,
    main = "ibl",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function() end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("custom.custom-plugins.configs.treesitter-textobjects").setup()
        end,
      },
      "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.treesitter").options)
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "LazyFile" },
    init = function() end,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.gitsigns").options)
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    dependencies = {
      {
        "nicoache1/vscode-es7-javascript-react-snippets",
        build = "yarn install --frozen-lockfile && yarn compile",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "CmdlineEnter", "InsertEnter" },
    version = false, -- last release is way too old
    dependencies = {
      -- cmp sources plugins
      {
        "hrsh7th/cmp-cmdline",
        "rcarriga/cmp-dap",
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.cmp").options)
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.cmp").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      -- Don't add pairs if it already has a close pair in the same line
      enable_check_bracket_line = true,
      -- Don't add pairs if the next char is alphanumeric
      ignored_next_char = "[%w%.]",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    opts = {
      -- Show snippets related to the language
      -- in the current cursor position
      ft_func = function()
        return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
      end,
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.nvim-tree").options)
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    url = "https://github.com/wochap/telescope.nvim.git",
    commit = "726dfed63e65131c60d10a3ac3f83b35b771aa83",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
        config = function()
          local Util = require "lazyvim.util"
          Util.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
          end)
        end,
      },
      "LiadOz/nvim-dap-repl-highlights",
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
      },
      pickers = {
        oldfiles = {
          cwd_only = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = false,
    init = false,
    cmd = false,
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup(opts)
      require("custom.custom-plugins.overrides.whichkey").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "LazyFile",
    init = function() end,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.colorizer").options)
    end,
  },
}
