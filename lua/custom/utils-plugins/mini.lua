local M = {}

M.mini_pairs = function(...)
  return require("lazyvim.util.mini").pairs(...)
end

M.mini_ai_whichkey = function(...)
  return require("lazyvim.util.mini").ai_whichkey(...)
end

M.mini_ai_buffer = function(...)
  return require("lazyvim.util.mini").ai_buffer(...)
end

return M
