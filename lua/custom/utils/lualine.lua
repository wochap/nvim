local colorschemeUtils = require "custom.utils.colorscheme"

local fg = function(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  local _fg = hl and (hl.fg or hl.foreground)
  return _fg and { fg = string.format("#%06x", _fg) } or nil
end

local M = {}

M.separators = {
  l = "",
  l_b = "",
  r = "",
  r_b = "",
}

M.empty = {
  function()
    return ""
  end,
  padding = { left = 0, right = 0 },
  separator = { left = "", right = "" },
  color = "",
  draw_empty = true,
}

M.filetypeIcon = {
  function()
    local icon, _ = require("nvim-web-devicons").get_icon(vim.fn.expand "%:t", nil, {
      default = true,
    })
    return icon
  end,
  color = function()
    local _, hl = require("nvim-web-devicons").get_icon(vim.fn.expand "%:t", nil, {
      default = true,
    })
    return fg(hl)
  end,
  padding = { left = 1, right = 1 },
  separator = { left = M.separators.l_b },
  draw_empty = true,
}

M.relativePath = {
  function()
    local filename_str = vim.fn.expand "%:t"
    if string.len(filename_str) == 0 then
      return ""
    end
    local filename = vim.api.nvim_buf_get_name(0)
    local relative_path = vim.fn.fnamemodify(filename, ":~:.")
    relative_path = string.sub(relative_path, 1, -1 + string.len(filename_str) * -1)
    return relative_path
  end,
  color = function()
    local C = require("catppuccin.palettes").get_palette "mocha"
    return { fg = colorschemeUtils.darken(C.text, 0.667, C.surface0) }
  end,
  padding = { left = 0 },
}

local function fileType()
  if not vim.tbl_contains({ "", "nowrite" }, vim.bo.bt) and not vim.fn.bufname():match "^Scratch %d+$" then
    return ""
  end
  if vim.bo.ft ~= "" then
    return "  " .. vim.bo.ft
  end
  return ""
end

M.lspOrFiletype = {
  function()
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
        return "󰄭 " .. #client_names .. " LSP"
      end
      return "󰄭  " .. client_names[1]
    end
    return fileType()
  end,
}

M.indent = {
  function()
    if vim.bo.expandtab then
      return "spaces:" .. vim.bo.shiftwidth
    else
      return "tabs:" .. vim.bo.tabstop
    end
  end,
  padding = { left = 1, right = 2 },
}

M.dirname = {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  icon = "󰉖",
  separator = { left = M.separators.r_b, right = M.separators.r },
}

return M
