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
    ["gs"] = "",
    ["gd"] = "",
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
    ["<leader>ma"] = "",

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

    -- tabufline
    ["<tab>"] = "",
    ["<S-tab>"] = "",
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
  plugin = true,

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

M.diagnostic = {
  n = {
    ["<leader>ld"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },
    -- TODO: add mappings for error and warning movements
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
  },
}

M.conform = {
  n = {
    ["<leader>lf"] = { "<cmd>LazyFormat<CR>", "format document" },
    ["<leader>lF"] = {
      function()
        require("conform").format { formatters = { "injected" } }
      end,
      "format injected langs in document",
    },
  },
  v = {
    ["<leader>lf"] = { "<cmd>LazyFormat<CR>", "format selection" },
    ["<leader>lF"] = {
      function()
        require("conform").format { formatters = { "injected" } }
      end,
      "format injected langs in selection",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    ["<leader>b"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    ["<leader>cf"] = { "<cmd>Telescope filetypes<cr>", "change filetype" },

    ["<leader>fs"] = { "<cmd>lua require('spectre').open()<CR>", "find word spectre" },
    ["<leader>fw"] = { "<cmd>lua require'custom.utils.telescope'.live_grep()<CR>", "find word" },
    ["<leader>fy"] = { "<cmd>lua require'custom.utils.telescope'.symbols()<CR>", "find symbols" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find old files" },
    ["<leader>fg"] = { "<cmd> Telescope git_status <CR>", "find changed files" },

    -- find
    ["<leader>fb"] = { "<cmd> Telescope buffers sort_mru=true sort_lastused=true <CR>", "find buffers" },
    ["<leader>ff"] = {
      "<cmd> Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true <CR>",
      "find files",
    },
    ["<leader>fa"] = {
      "<cmd> Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true no_ignore=true <CR>",
      "find files!",
    },
    ["<leader>fx"] = {
      "<cmd> Telescope marks <CR>",
      "find marks",
    },
  },
}

M.close_buffers = {
  n = {
    ["<leader>w"] = {
      function()
        local bd = require("close_buffers").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd { type = "this" }
          elseif choice == 2 then -- No
            bd { type = "this", force = true }
          end
        else
          bd { type = "this" }
        end
      end,
      "close buffer",
    },
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

M.terminal = {
  n = {
    -- new
    ["<leader>T_"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "new horizontal term",
    },
    ["<leader>T|"] = {
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
    ["<leader>ql"] = {
      "<cmd>lua require('persistence').load();require('base46').load_all_highlights()<CR>",
      "load last session",
    },
    ["<leader>qs"] = {
      "<cmd>lua require('persistence').save()<CR>",
      "save session",
    },
  },
}

M.maximizer_toggle = {
  n = {
    ["<leader>m"] = { "<cmd>MaximizerToggle!<CR>", "max window" },
  },
}

M.trouble = {
  n = {
    ["<leader>xx"] = { "<cmd>TroubleToggle<cr>", "show last list" },
    ["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "show project diagnostics" },
    ["<leader>xf"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "show file diagnostic" },
    ["<leader>xl"] = { "<cmd>TroubleToggle loclist<cr>", "toggle loclist" },
    ["<leader>xq"] = { "<cmd>TroubleToggle quickfix<cr>", "toggle quicklist" },
    ["gr"] = { "<cmd>TroubleToggle lsp_references<cr>", "toggle references" },
    ["[x"] = {
      "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>",
      "go to prev troublelist item",
    },
    ["]x"] = {
      "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>",
      "go to next troublelist item",
    },
  },
}

M.todo = {
  n = {
    ["<leader>tl"] = { "<cmd>TodoQuickFix<cr>", "toggle loclist" },
    ["<leader>tq"] = { "<cmd>TodoLocList<cr>", "toggle quicklist" },
    ["[t"] = {
      "<cmd>lua require('todo-comments').jump_prev({keywords = { 'TODO', 'HACK', 'FIX' }})<CR>",
      "go to prev todo|hack|fix comment",
    },
    ["]t"] = {
      "<cmd>lua require('todo-comments').jump_next({keywords = { 'TODO', 'HACK', 'FIX' }})<CR>",
      "go to next todo|hack|fix comment",
    },
  },
}

M.harpon = {
  n = {
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
    ["]h"] = {
      function()
        require("goto-breakpoints").next()
      end,
      "next breakpoint",
    },
    ["[h"] = {
      function()
        require("goto-breakpoints").prev()
      end,
      "prev breakpoint",
    },
    ["<leader>d<Up>"] = { "<cmd>lua require'dap'.step_out()<CR>", "step out" },
    ["<leader>d<Right>"] = { "<cmd>lua require'dap'.step_into()<CR>", "step into" },
    ["<leader>d<Down>"] = { "<cmd>lua require'dap'.step_over()<CR>", "step over" },
    ["<leader>d<Left>"] = { "<cmd>lua require'dap'.continue()<CR>", "continue" },
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
    ["<leader>du"] = { "<cmd>lua require'dapui'.toggle({ reset = true })<CR>", "open dapui" },
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
    ["<leader>gS"] = { "<cmd>lua require('gitsigns').stage_buffer()<cr>", "stage buffer" },
    ["<leader>gs"] = { "<cmd>lua require('gitsigns').stage_hunk()<cr>", "stage hunk" },
    ["<leader>gR"] = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "reset buffer" },
    ["<leader>gr"] = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", "reset hunk" },
    ["<leader>gp"] = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "preview hunk" },
    ["<leader>gb"] = { "<cmd>lua require('gitsigns').blame_line({ full = true })<cr>", "blame line" },
    ["<leader>gd"] = { "<cmd>lua require('gitsigns').toggle_deleted()<cr>", "toggle deleted" },
  },
}

M.peek = {
  plugin = true,

  n = {
    ["<leader>fm"] = { "<cmd>lua require('peek').open()<CR>", "Open markdown previewer" },
    ["<leader>fM"] = { "<cmd>lua require('peek').close()<CR>", "Close markdown previewer" },
  },
}

M.zenmode = {
  n = {
    ["<leader>z"] = { "<cmd>ZenMode<CR>", "toggle ZenMode" },
  },
}

M.ufo = {
  n = {
    ["zR"] = {
      function()
        require("ufo").openAllFolds()
      end,
      "ufo open all folds",
    },
    ["zM"] = {
      function()
        require("ufo").closeAllFolds()
      end,
      "ufo open all folds",
    },
    ["zm"] = {
      function()
        require("ufo").closeFoldsWith()
      end,
      "ufo close folds with",
    },
  },
}

M.leetcode = {
  plugin = true,

  n = {
    ["<leader>e"] = { "<cmd>Leet menu<cr>", "opens menu dashboard" },
    ["<leader>b"] = { "<cmd>Leet desc<cr>", "toggle question description" },
    ["<leader>Ld"] = { "<cmd>Leet daily<cr>", "opens the question of today" },
    ["<leader>Lc"] = { "<cmd>Leet console<cr>", "opens console pop-up for currently opened question" },
    ["<leader>Li"] = {
      "<cmd>Leet info<cr>",
      "opens a pop-up containing information about the currently opened question",
    },
    ["<leader>fb"] = {
      "<cmd>Leet tabs<cr>",
      "opens a picker with all currently opened question tabs",
    },
    ["<leader>Ll"] = {
      "<cmd>Leet lang<cr>",
      "opens a picker to change the language of the current question",
    },
    ["<leader>Lr"] = {
      "<cmd>Leet run<cr>",
      "run currently opened question",
    },
    ["<leader>Ls"] = {
      "<cmd>Leet submit<cr>",
      "submit currently opened question",
    },
    ["<leader>ff"] = {
      "<cmd>Leet list<cr>",
      "opens a problemlist picker",
    },
  },
}

return M
