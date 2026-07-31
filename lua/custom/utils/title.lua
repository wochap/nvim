local fn = vim.fn
local api = vim.api

local M = {}

-- NOTE: no file icon here on purpose. bufferline/neo-tree/statusline all resolve
-- icons through the mini.icons nvim-web-devicons shim, and although that yields
-- the same glyph codepoint, foot renders the OSC-title glyph differently from
-- nvim's grid, so the icon never visually matched. Title stays text-only.
local function title_string()
  -- mirror statusline filename(): empty buffer -> "[No Name]"
  if fn.expand "%" == "" then
    return "  - [No Name]"
  end

  return "  - " .. (fn.expand "%:t")
end

M.update = function()
  vim.o.titlestring = title_string()
end

M.setup = function()
  M.update()

  api.nvim_create_autocmd({ "VimEnter", "BufEnter", "BufFilePost" }, {
    group = api.nvim_create_augroup("CustomTitle", { clear = true }),
    callback = M.update,
  })

  vim.o.title = true
end

return M
