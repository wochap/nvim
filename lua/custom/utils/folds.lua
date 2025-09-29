local M = {}

-- source: https://github.com/mostafaqanbaryan/dotfiles/blob/91c46a858cfe97e711f0a7e483d7cb433e260e15/nvim/lua/fold.lua#L6
M.foldtext = function()
  local pos = vim.v.foldstart
  local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  local parser = vim.treesitter.get_parser(0, lang)

  if parser == nil then
    return vim.fn.foldtext()
  end

  local query = vim.treesitter.query.get(parser:lang(), "highlights")

  if query == nil then
    return vim.fn.foldtext()
  end

  -- NOTE: This re-parses the line on every call
  local tree = parser:parse({ pos - 1, pos })[1]
  local result = {}
  local line_pos = 0
  local prev_range = nil

  for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()
    if start_row == pos - 1 and end_row == pos - 1 then
      local range = { start_col, end_col }
      if start_col > line_pos then
        table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
      end
      line_pos = end_col
      local text = vim.treesitter.get_node_text(node, 0)
      if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
        result[#result] = { text, "@" .. name }
      else
        table.insert(result, { text, "@" .. name })
      end
      prev_range = range
    end
  end

  -- Add any remaining text after the last highlighted node
  if line_pos < #line then
    table.insert(result, { line:sub(line_pos + 1), "Folded" })
  end

  -- Calculate the line count and add it to the result table
  local line_count = vim.v.foldend - vim.v.foldstart
  table.insert(result, { " ", "Folded" })
  table.insert(result, { " 󰁂 " .. line_count .. " ", "LspInlayHint" })

  return result
end

return M
