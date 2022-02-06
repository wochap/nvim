local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

if present1 and present2 then
   local default = {
      fast_wrap = {},
      enable_moveright = true,
      map_bs = false,
      check_ts = true,
      ts_config = {
         lua = { "string", "source" },
         javascript = { "string", "template_string" },
         java = false,
      },
   }
   autopairs.setup(default)

   local cmp = require "cmp"
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end
