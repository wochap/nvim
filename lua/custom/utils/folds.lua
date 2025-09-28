local M = {}

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
  local result = {}
  local line_count = vim.v.foldend - vim.v.foldstart
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " " })
  table.insert(result, { " 󰁂 " .. line_count .. " ", "LspInlayHint" })
  return result
end

return M
