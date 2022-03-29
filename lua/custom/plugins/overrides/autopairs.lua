local present1, autopairs = pcall(require, "nvim-autopairs")

if present1 then
   local default = {
      disable_in_macro = true,
      enable_moveright = true,
      enable_check_bracket_line = true,
      map_bs = false,
      check_ts = true,
      ts_config = {
         lua = { "string", "source" },
         javascript = { "string", "template_string" },
         java = false,
      },
   }
   autopairs.setup(default)

   local cmp_autopairs = require "nvim-autopairs.completion.cmp"
   local cmp = require "cmp"
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end
