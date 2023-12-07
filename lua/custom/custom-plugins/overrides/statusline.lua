local modes = {
  ["n"] = { "NORMAL", "St_NormalMode" },
  ["no"] = { "NORMAL (no)", "St_NormalMode" },
  ["nov"] = { "NORMAL (nov)", "St_NormalMode" },
  ["noV"] = { "NORMAL (noV)", "St_NormalMode" },
  ["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
  ["niI"] = { "NORMAL i", "St_NormalMode" },
  ["niR"] = { "NORMAL r", "St_NormalMode" },
  ["niV"] = { "NORMAL v", "St_NormalMode" },
  ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
  ["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

  ["v"] = { "VISUAL", "St_VisualMode" },
  ["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
  ["V"] = { "V-LINE", "St_VisualMode" },
  ["Vs"] = { "V-LINE", "St_VisualMode" },
  [""] = { "V-BLOCK", "St_VisualMode" },

  ["i"] = { "INSERT", "St_InsertMode" },
  ["ic"] = { "INSERT (completion)", "St_InsertMode" },
  ["ix"] = { "INSERT completion", "St_InsertMode" },

  ["t"] = { "TERMINAL", "St_TerminalMode" },

  ["R"] = { "REPLACE", "St_ReplaceMode" },
  ["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
  ["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

  ["s"] = { "SELECT", "St_SelectMode" },
  ["S"] = { "S-LINE", "St_SelectMode" },
  [""] = { "S-BLOCK", "St_SelectMode" },
  ["c"] = { "COMMAND", "St_CommandMode" },
  ["cv"] = { "COMMAND", "St_CommandMode" },
  ["ce"] = { "COMMAND", "St_CommandMode" },
  ["r"] = { "PROMPT", "St_ConfirmMode" },
  ["rm"] = { "MORE", "St_ConfirmMode" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode" },
  ["x"] = { "CONFIRM", "St_ConfirmMode" },
  ["!"] = { "SHELL", "St_TerminalMode" },
}

local function get_relative_path()
  local filename_str = vim.fn.expand "%:t"

  if string.len(filename_str) == 0 then
    return ""
  end

  local filename = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(filename, ":~:.")

  relative_path = string.sub(relative_path, 1, -1 + string.len(filename_str) * -1)

  return relative_path
end

return {
  overriden_modules = function(modules)
    local fn = vim.fn
    local api = vim.api
    local sep_l = ""
    local sep_l_b = ""
    local sep_r = ""
    local sep_r_b = ""

    local function new_hl(group1, group2)
      local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
      local bg = fn.synIDattr(fn.synIDtrans(fn.hlID(group2)), "bg#")
      api.nvim_set_hl(0, "St_module" .. group1 .. group2, { fg = fg, bg = bg })
      return "%#" .. "St_module" .. group1 .. group2 .. "#"
    end

    local function mode()
      local m = vim.api.nvim_get_mode().mode
      local current_mode = "%#" .. modes[m][2] .. "#" .. " " .. modes[m][1]
      local mode_sep1 = "%#" .. modes[m][2] .. "Sep" .. "#" .. sep_l

      return current_mode .. " " .. mode_sep1
    end

    local function fileInfo()
      local icon = " 󰈚 "
      local icon_hl = "DevIconDefault"
      local filename = (fn.expand "%" == "" and "No Name ") or fn.expand "%:t"
      local relative_path = ""

      if filename ~= "No Name " then
        relative_path = get_relative_path()
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
          local ft_icon, ft_icon_hl = devicons.get_icon(filename)
          icon = (ft_icon ~= nil and " " .. ft_icon .. " ") or icon
          icon_hl = (ft_icon_hl ~= nil and ft_icon_hl) or icon_hl
        end

        filename = filename .. " "
      end

      return "%#ST_sep#"
        .. sep_l_b
        .. new_hl(icon_hl, "St_module")
        .. icon
        .. "%#St_relative_path#"
        .. relative_path
        .. "%#St_module#"
        .. filename
        .. "%#ST_sep#"
        .. sep_l
    end

    local function gitchanges()
      if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns < 120 then
        return ""
      end

      local git_status = vim.b.gitsigns_status_dict

      local added = (git_status.added and git_status.added ~= 0) and ("%#St_gitAdd#  " .. git_status.added) or ""
      local changed = (git_status.changed and git_status.changed ~= 0)
          and ("%#St_gitChange#  " .. git_status.changed)
        or ""
      local removed = (git_status.removed and git_status.removed ~= 0)
          and ("%#St_gitDelete#  " .. git_status.removed)
        or ""

      return added .. changed .. removed
    end

    local function git()
      if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
        return ""
      end

      local git_status = vim.b.gitsigns_status_dict
      local branch_name = " " .. git_status.head

      return "%#St_gitIcons#  " .. branch_name .. " " .. gitchanges()
    end

    local function LSP_Diagnostics()
      if not rawget(vim, "lsp") then
        return ""
      end

      local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

      errors = (errors and errors > 0) and ("%#St_lspError#" .. "󰅚 " .. errors .. " ") or ""
      warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. " " .. warnings .. " ") or ""
      hints = (hints and hints > 0) and ("%#St_lspHints#" .. "󰛩 " .. hints .. " ") or ""
      info = (info and info > 0) and ("%#St_lspInfo#" .. " " .. info .. " ") or ""

      return errors .. warnings .. hints .. info
    end

    local function cwd()
      local dir_icon = "%#St_module#" .. " 󰉖 "
      local dir_name = fn.fnamemodify(fn.getcwd(), ":t") .. " "

      if vim.o.columns > 85 then
        return "%#St_sep#" .. sep_r_b .. dir_icon .. dir_name .. "%#St_sep#" .. sep_r
      end

      return ""
    end

    local function fileType()
      if not vim.tbl_contains({ "", "nowrite" }, vim.bo.bt) and not vim.fn.bufname():match "^Scratch %d+$" then
        return ""
      end

      if vim.bo.ft ~= "" then
        return "%#St_fileType#  " .. vim.bo.ft .. "  "
      end

      return ""
    end

    function LSP_status()
      if rawget(vim, "lsp") then
        local client_names = {}
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          if client.attached_buffers[vim.api.nvim_get_current_buf()] then
            table.insert(client_names, client.name)
          end
        end
        if next(client_names) == nil then
          return fileType()
        end
        if #client_names > 1 then
          return "%#St_LspStatus# 󰄭 " .. #client_names .. " LSP  "
        end
        return "%#St_LspStatus# 󰄭  " .. client_names[1] .. "  "
      end

      return fileType()
    end

    local function location()
      local line = vim.fn.line "."
      local col = vim.fn.virtcol "."
      return string.format("%3d,%-2d", line, col)
    end

    local function cursor_position()
      local left_sep = "%#St_sep#" .. sep_r_b .. "%#St_module#"

      local current_line = fn.line "."
      local total_line = fn.line "$"
      local text = math.modf((current_line / total_line) * 100) .. tostring "%%"
      text = string.format("%4s", text)

      text = (current_line == 1 and "Top") or text
      text = (current_line == total_line and "Bot") or text
      text = (vim.o.columns > 140 and (location() .. " ") or "") .. text

      return left_sep .. " " .. text .. " "
    end

    local function indentInfo()
      if vim.bo.expandtab then
        return "%#St_IndentInfo#spaces:" .. vim.bo.shiftwidth .. "  "
      else
        return "%#St_IndentInfo#tabs:" .. vim.bo.tabstop .. "  "
      end
    end

    modules[1] = mode()
    modules[2] = fileInfo()
    modules[3] = git()
    modules[4] = "%="
    modules[5] = ""
    modules[6] = LSP_Diagnostics()
    modules[7] = LSP_status() or ""
    modules[8] = indentInfo()
    modules[9] = cwd()
    modules[10] = cursor_position()
  end,
}
