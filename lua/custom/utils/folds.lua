local iconsUtils = require "custom.utils.icons"
local constants = require "custom.utils.constants"

local M = {}

-- optimized treesitter foldexpr for Neovim >= 0.10.0
M.ts_foldexpr = function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    -- as long as we don't have a filetype, don't bother
    -- checking if treesitter is available (it won't)
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.tbl_contains(constants.exclude_filetypes, vim.bo[buf].filetype) then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

M.foldtext = function()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  -- local end_str = vim.fn.getline(vim.v.foldend)
  -- local end_ = vim.trim(end_str)
  local result = {}
  local line_count = vim.v.foldend - vim.v.foldstart
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " " })
  table.insert(result, { " 󰁂 " .. line_count .. " ", "LspInlayHint" })
  -- fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match "^(%s+)" or ""))
  return result
end

return M
