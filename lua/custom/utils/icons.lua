local M = {}

M.folder = {
  default = "",
  open = "",
  empty = "",
  empty_open = "",
  symlink = "",
  symlink_open = "",
}

M.file = {
  default = "󰈚",
  symlink = "",
}

M.git = {
  Add = "",
  Change = "",
  Delete = "",
  Conflict = "",
}

M.diagnostic = {
  Error = "󰅚",
  Warn = "",
  Info = "",
  Hint = "󰛩",
}

M.lspkind = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Codeium = "󰘦",
  Color = "",
  Control = "",
  Collapsed = "",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "󰊕",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "󰆼",
  TabNine = "󰏚",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
}

return M
