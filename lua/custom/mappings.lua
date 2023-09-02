local M = {}

M.disabled = {
  n = {
    -- switch between windows
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",

    -- Copy all
    ["<C-c>"] = "",

    -- line numbers
    ["<leader>n"] = "",
    ["<leader>rn"] = "",

    -- update nvchad
    ["<leader>uu"] = "",

    ["<leader>tt"] = "",

    -- cycle through buffers
    ["<TAB>"] = "",
    ["<S-Tab>"] = "",

    -- close buffer + hide terminal buffer
    ["<leader>x"] = "",

    -- lsp
    ["K"] = "",
    ["gi"] = "",
    ["<leader>ls"] = "",
    ["<leader>D"] = "",
    ["<leader>ra"] = "",
    ["<leader>ca"] = "",
    ["gr"] = "",
    ["<leader>q"] = "",
    ["<leader>fm"] = "",
    ["<leader>wa"] = "",
    ["<leader>wr"] = "",
    ["<leader>wl"] = "",
    ["d]"] = "",

    -- toggle nvimtree
    ["<C-n>"] = "",

    -- find
    ["<leader>ff"] = "",
    ["<leader>fa"] = "",

    -- git
    ["<leader>cm"] = "",
    ["<leader>gt"] = "",

    -- pick a hidden term
    ["<leader>pt"] = "",

    -- theme switcher
    ["<leader>th"] = "",
    ["<leader>tk"] = "",

    -- exit terminal mode
    ["<C-x>"] = "",

    -- new terminal
    ["<leader>h"] = "",
    ["<leader>v"] = "",

    -- whichkey
    ["<leader>wK"] = "",
    ["<leader>wk"] = "",

    ["<leader>cc"] = "",

    -- gitsigns
    ["]c"] = "",
    ["[c"] = "",
    ["<leader>rh"] = "",
    ["<leader>ph"] = "",
    ["<leader>td"] = "",
  },
  i = {
    -- go to  beginning and end
    ["<C-b>"] = "",
    ["<C-e>"] = "",

    -- navigate within insert mode
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },
}

M.tabufline = {
  n = {
    ["<Leader>fn"] = { "<cmd> enew <CR>", "new buffer" },

    -- cycle through buffers
    ["<S-Right>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },
    ["<S-Left>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },

    -- cycle through tabs
    ["<S-Up>"] = { "<cmd> tabprevious <CR>", "goto next tab" },
    ["<S-Down>"] = { "<cmd> tabnext <CR> ", "goto prev tab" },
  },
}

M.general = {
  n = {
    ["<C-Left>"] = { "<C-w>h", "window left" },
    ["<C-Right>"] = { "<C-w>l", "window right" },
    ["<C-Down>"] = { "<C-w>j", "window down" },
    ["<C-Up>"] = { "<C-w>k", "window up" },

    ["<C-y>"] = { "<cmd> %y+ <CR>", "copy whole file" },
  },
}

M.lspconfig = {
  n = {
    ["gh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },
    ["gI"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },
    ["gs"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },
    ["gt"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },
    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "lsp rename",
    },
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },
    ["gr"] = {
      "<cmd>TroubleToggle lsp_references<cr>",
      "lsp references",
    },
    ["<leader>ld"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "prev diagnostic",
    },
    ["]d"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "next diagnostic",
    },

    ["<leader>lf"] = {
      function()
        vim.lsp.buf.format {
          async = false,
          bufnr = bufnr,
          filter = function(client)
            return client.name == "null-ls"
          end,
        }
      end,
      "lsp formatting",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader>b"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd>lua require('spectre').open()<CR>", "find word spectre" },
    ["<leader>fw"] = { "<cmd>lua require'custom.utils.telescope'.live_grep()<CR>", "find word" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find old files" },

    -- find
    ["<leader>ff"] = {
      "<cmd> Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true <CR>",
      "find files",
    },
    ["<leader>fa"] = {
      "<cmd> Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true no_ignore=true <CR>",
      "find files!",
    },
  },
}

M.blankline = {
  n = {
    ["gC"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "jump to current_context",
    },
  },
}

M.utils = {
  n = {
    ["<C-e>"] = { "<cmd>lua require'custom.utils.window'.closeAllFloating()<CR>", "close floating windows" },
  },
  i = {
    ["<C-e>"] = { "<cmd>lua require'custom.utils.window'.closeAllFloating()<CR>", "close floating windows" },
    ["<C-k>"] = { "<cmd>lua require'custom.utils.others'.expandSnippet()<CR>", "expand snippet" },
  },
}

M.close_buffers = {
  n = {
    ["<leader>w"] = { "<cmd>lua require('close_buffers').delete({ type = 'this' })<CR>", "close buffer" },
    ["<leader>W"] = {
      "<cmd>lua require('close_buffers').delete({ type = 'this', force = true })<CR>",
      "close buffer!",
    },
    ["<leader>fk"] = {
      "<cmd>lua require('close_buffers').delete({ type = 'other' })<CR>",
      "close other buffers",
    },
    ["<leader>fK"] = {
      "<cmd>lua require('close_buffers').delete({ type = 'other', force = true })<CR>",
      "close other buffers!",
    },
    ["<leader>ft"] = {
      "<cmd>lua require('nvchad.tabufline').closeAllBufs('closeTab') <CR>",
      "close tab",
    },
  },
}

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local exitTerminalMode = termcodes "<C-\\><C-N>"

M.terminal = {
  t = {
    ["<C-x>"] = { exitTerminalMode, "hide terminal" },
    ["<C-S-x>"] = { exitTerminalMode .. "<C-w>q", "hide terminal" },
  },

  n = {
    -- pick a hidden term
    ["<leader>tt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    -- new
    ["<leader>th"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "new horizontal term",
    },
    ["<leader>tv"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "new vertical term",
    },
  },
}

M.git = {
  n = {
    ["<leader>gl"] = { "<cmd>LazyGit<CR>", "open lazygit" },
    ["<leader>gf"] = { "<cmd>DiffviewFileHistory %<CR>", "open current file history" },
  },
}

M.persistence = {
  n = {
    ["<leader>nl"] = { "<cmd>lua require('persistence').load()<CR>", "load last session" },
  },
}

M.custom_general = {
  n = {
    ["<C-S-s>"] = { "<Esc>:w! <CR>", "save buffer!" },
    ["<C-S-d>"] = { "zL", "scroll half screen to the right" },
    ["<C-S-u>"] = { "zH", "scroll half screen to the left" },
    ["<leader>qa"] = { "<cmd>qa <CR>", "exit" },
    ["<leader>q!"] = { "<cmd>qa! <CR>", "exit!" },
    ["<A-Down>"] = { ":m .+1<CR>==", "move line down" },
    ["<A-Up>"] = { ":m .-2<CR>==", "move line up" },
    ["<C-S-A-Down>"] = { '"zyy"zp', "clone line down" },
    ["<C-S-A-Up>"] = { '"zyy"zP', "clone line up" },
    ["gV"] = { "`[v`]", "select last yanked/changed text" },
    ["[<Space>"] = { ":set paste<CR>m`O<Esc>``:set nopaste<CR>", "add empty line up" },
    ["]<Space>"] = { ":set paste<CR>m`o<Esc>``:set nopaste<CR>", "add empty line down" },
    ["[<Del>"] = { "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line up" },
    ["]<Del>"] = { "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line down" },
    ["[q"] = { ":cprevious<CR>", "go to prev quicklist item" },
    ["]q"] = { ":cnext<CR>", "go to next quicklist item" },
    ["[l"] = { ":lprevious<CR>", "go to prev loclist item" },
    ["]l"] = { ":lnext<CR>", "go to next loclist item" },
  },
  i = {
    ["<C-s>"] = { "<Esc>:w <CR>", "save buffer" },
    ["<C-S-s>"] = { "<Esc>:w! <CR>", "save buffer!" },
    ["<A-Down>"] = { "<Esc>:m .+1<CR>==gi", "move line down" },
    ["<A-Up>"] = { "<Esc>:m .-2<CR>==gi", "move line up" },
  },
  x = {
    ["<A-Down>"] = { ":m '>+1<CR>gv-gv", "move lines down" },
    ["<A-Up>"] = { ":m '<-2<CR>gv-gv", "move lines up" },
  },
  v = {
    ["<C-S-d>"] = { "zL", "scroll half screen to the right" },
    ["<C-S-u>"] = { "zH", "scroll half screen to the left" },
    ["<C-s>"] = { "<Esc>:w <CR>", "save buffer" },
    ["<C-S-s>"] = { "<Esc>:w! <CR>", "save buffer!" },
    ["<C-S-A-Down>"] = { '"zy`]"zp', "clone line down" },
    ["<C-S-A-Up>"] = { '"zy`["zP', "clone line down" },
    ["<F9>"] = { ":'<,'>sort<CR>", "sort lines" },
    ["<"] = { "<gv", "indent left" },
    [">"] = { ">gv", "indent right" },
  },
  s = {
    ["c"] = { '<C-o>"_c', "change selected text" },
  },
}

M.maximizer_toggle = {
  n = {
    ["<leader>m"] = { "<cmd>MaximizerToggle!<CR>", "max window" },
  },
}

M.packer = {
  n = {
    ["<leader>pc"] = { "<cmd>Lazy restore<cr>", "restore" },
    ["<leader>pi"] = { "<cmd>Lazy install<cr>", "install" },
    ["<leader>ps"] = { "<cmd>Lazy sync<cr>", "sync" },
    ["<leader>pS"] = { "<cmd>Lazy check<cr>", "check" },
    ["<leader>pu"] = { "<cmd>Lazy update<cr>", "update" },
  },
}

M.trouble = {
  n = {
    ["<leader>xx"] = { "<cmd>TroubleToggle<cr>", "show last list" },
    ["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "show project diagnostics" },
    ["<leader>xd"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "show file diagnostic" },
    ["<leader>xt"] = { "<cmd>TodoTrouble<cr>", "open TODOs" },
    ["<leader>xT"] = { "<cmd>TodoTelescope<cr>", "search TODOs" },
    ["<leader>xl"] = { "<cmd>TroubleToggle loclist<cr>", "toggle loclist" },
    ["<leader>xq"] = { "<cmd>TroubleToggle quickfix<cr>", "toggle quicklist" },
    ["gr"] = { "<cmd>TroubleToggle lsp_references<cr>", "toggle references" },
    ["[t"] = {
      "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>",
      "go to prev troublelist item",
    },
    ["]t"] = {
      "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>",
      "go to next troublelist item",
    },
  },
}

M.harpon = {
  n = {
    -- ["<leader>ht"] = { "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", "toggle quick menu terminals" },
    -- ["<leader>hl"] = { "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>", "go to terminal 1" },
    -- ["<leader>hu"] = { "<cmd>lua require('harpoon.term').gotoTerminal(2)<CR>", "go to terminal 2" },
    -- ["<leader>hy"] = { "<cmd>lua require('harpoon.term').gotoTerminal(3)<CR>", "go to terminal 3" },
    -- ["<leader>h;"] = { "<cmd>lua require('harpoon.term').gotoTerminal(4)<CR>", "go to terminal 4" },
    ["<leader>hs"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "toggle quick menu files" },
    ["<leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "add file" },
    ["<leader>hp"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "go to file 1" },
    ["<leader>hf"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "go to file 2" },
    ["<leader>hw"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "go to file 3" },
    ["<leader>hq"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", "go to file 4" },
  },
}

M.dap = {
  n = {
    ["<leader>d<Up>"] = { "<cmd>lua require'dap'.step_out()<CR>", "step out" },
    ["<leader>d<Right>"] = { "<cmd>lua require'dap'.step_into()<CR>", "step into" },
    ["<leader>d<Down>"] = { "<cmd>lua require'dap'.step_over()<CR>", "step over" },
    ["<leader>d<Left>"] = { "<cmd>lua require'dap'.continue()<CR>", "continue" },
    ["<leader>da"] = { "<cmd>lua require'custom.utils.debugHelper'.attach()<CR>", "attach" },
    ["<leader>dH"] = {
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      "set breakpoint condition",
    },
    ["<leader>dh"] = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "set breakpoint" },
    ["<leader>dc"] = { "<cmd>lua require'dap'.terminate()<CR>", "terminate" },
    ["<leader>de"] = {
      "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<CR>",
      "set exception breakpoints ALL",
    },
    ["<leader>di"] = { "<cmd>lua require'dap.ui.widgets'.hover()<CR>", "hover" },
    ["<leader>dr"] = { "<cmd>lua require'dap'.repl.toggle({}, 'vsplit')<CR><C-w>l", "toggle repl" },
    ["<leader>dn"] = { "<cmd>lua require'dap'.run_to_cursor()<CR>", "run to cursor" },
    ["<leader>du"] = { "<cmd>lua require'dapui'.toggle()<CR>", "open dapui" },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]g"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "jump to next hunk",
      opts = { expr = true },
    },

    ["[g"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>gS"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "stage buffer",
    },
    ["<leader>gs"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "stage hunk",
    },

    ["<leader>gR"] = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "reset buffer",
    },
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "reset hunk",
    },

    ["<leader>gp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line { full = true }
      end,
      "blame line",
    },

    ["<leader>gd"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "toggle deleted",
    },
  },
  v = {
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "reset hunk",
    },
  },
}

M.peek = {
  n = {
    ["<leader>fm"] = { "<cmd>lua require('peek').open()<CR>", "Open markdown previewer" },
    ["<leader>fM"] = { "<cmd>lua require('peek').close()<CR>", "Close markdown previewer" },
  },
}

return M
