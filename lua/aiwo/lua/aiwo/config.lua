local M = {}

---@class aiwo.Config
---@field copy boolean copy whole prompt to clipboard after writing
---@field show boolean open the prompt split after writing
---@field focus boolean move cursor to the prompt split (needs show = true)
---@field input boolean ask for free text before writing
---@field width number split width (fraction of the current window)
---@field dir? string base directory for prompt files (default: $XDG_RUNTIME_DIR/aiwo)
M.defaults = {
  copy = false,
  show = true,
  focus = true,
  input = false,
  width = 0.5,
  dir = nil,
}

---@type aiwo.Config
M.options = vim.deepcopy(M.defaults)

---@param opts? table
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

---@param opts? table per-call opts merged over defaults
---@return aiwo.Config
function M.get(opts)
  return vim.tbl_deep_extend("force", vim.deepcopy(M.options), opts or {})
end

return M
