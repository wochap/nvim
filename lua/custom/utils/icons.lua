local M = {}

M.fold = {
  open = "",
  closed = "",
}

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

M.diagnostic_by_index = {
  M.diagnostic.Error,
  M.diagnostic.Warn,
  M.diagnostic.Info,
  M.diagnostic.Hint,
}

M.lsp_kind = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Color = "",
  Constant = "󰏿",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Keyword = "",
  Method = "󰊕",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "",
  Property = "󰖷",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "󰆼",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "󰦨",
  Variable = "󰀫",

  Collapsed = "",
  Control = "",
  Key = "",
  Tag = "",

  Avante = "󰯫",
  Codeium = "󰘦",
  Copilot = "",
  Dap = "",
  History = "",
  Package = "",
  RenderMarkdown = "",
  Spell = "暈",
  TabNine = "󰏚",
}

M.other = {
  ellipsis = "…",
  color = "󱓻",
}

return M
