return {
  overriden_modules = function(modules)
    local fn = vim.fn
    local api = vim.api
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")
    local isBufValid = function(bufnr)
      return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
    end
    local buffer_width = 24

    local function new_hl(group1, group2)
      local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
      local bg = fn.synIDattr(fn.synIDtrans(fn.hlID(group2)), "bg#")
      api.nvim_set_hl(0, "Tbline" .. group1 .. group2, { fg = fg, bg = bg })
      return "%#" .. "Tbline" .. group1 .. group2 .. "#"
    end

    local function getBtnsWidth()
      local width = 0
      if fn.tabpagenr "$" ~= 1 then
        -- 1 = space between buffers and tabs
        width = width + 1 + (3 * fn.tabpagenr "$")
      end
      return width
    end

    local function add_fileInfo(name, bufnr)
      if not devicons_present then
        return ""
      end

      local icon, icon_hl = devicons.get_icon(name, string.match(name, "%a+$"))

      if not icon then
        icon = "󰈚 "
        icon_hl = "DevIconDefault"
      end

      icon = (
        api.nvim_get_current_buf() == bufnr and new_hl(icon_hl, "TbLineBufOn") .. icon
        or "%#TbLineBufOff#" .. icon
      )

      -- check for same buffer names under different dirs
      for _, value in ipairs(vim.t.bufs) do
        if isBufValid(value) then
          if name == fn.fnamemodify(api.nvim_buf_get_name(value), ":t") and value ~= bufnr then
            local other = {}
            for match in (vim.fs.normalize(api.nvim_buf_get_name(value)) .. "/"):gmatch("(.-)" .. "/") do
              table.insert(other, match)
            end

            local current = {}
            for match in (vim.fs.normalize(api.nvim_buf_get_name(bufnr)) .. "/"):gmatch("(.-)" .. "/") do
              table.insert(current, match)
            end

            name = current[#current]

            for i = #current - 1, 1, -1 do
              local value_current = current[i]
              local other_current = other[i]

              if value_current ~= other_current then
                if (#current - i) < 2 then
                  name = value_current .. "/" .. name
                else
                  name = value_current .. "/../" .. name
                end
                break
              end
            end
            break
          end
        end
      end

      -- resize name
      local maxname_len = buffer_width - 8
      name = (#name > maxname_len and string.sub(name, 1, 14) .. "..") or name

      -- padding around bufname = ( buffer_width - #name - #icon ) / 2
      local padding = math.floor((buffer_width - #name - 2) / 2)
      local strPadding = string.rep(" ", padding)

      local nameHl = (api.nvim_get_current_buf() == bufnr and "%#TbLineBufOn#") or "%#TbLineBufOff#"
      name = strPadding .. icon .. nameHl .. " " .. name

      -- add modified indicator
      local modifiedIndicator = "  "
      if bufnr == api.nvim_get_current_buf() then
        if vim.bo[0].modified then
          modifiedIndicator = "%%#TbLineBufOnModified# "
        end
      else
        if vim.bo[bufnr].modified then
          modifiedIndicator = "%%#TbLineBufOffModified# "
        end
      end
      return nameHl .. name .. strPadding:gsub("  ", modifiedIndicator, 1)
    end

    local function styleBufferTab(nr)
      local name = (#api.nvim_buf_get_name(nr) ~= 0) and fn.fnamemodify(api.nvim_buf_get_name(nr), ":t") or "No Name"
      name = "%" .. nr .. "@TbGoToBuf@" .. add_fileInfo(name, nr) .. "%X"

      return name
    end

    local function bufferlist()
      local buffers = {} -- buffersults
      local available_space = vim.o.columns - getBtnsWidth()
      local current_buf = api.nvim_get_current_buf()
      local has_current = false -- have we seen current buffer yet?

      for _, bufnr in ipairs(vim.t.bufs) do
        if isBufValid(bufnr) then
          -- HACK: change 0 to 1 if dont want overflow
          if ((#buffers + 0) * buffer_width) > available_space then
            if has_current then
              break
            end

            table.remove(buffers, 1)
          end

          has_current = (bufnr == current_buf and true) or has_current
          table.insert(buffers, styleBufferTab(bufnr))
        end
      end

      vim.g.visibuffers = buffers
      local spacing = getBtnsWidth() and ("%#TblineFill#" .. "%=") or ""
      return table.concat(buffers) .. spacing -- buffers + empty space
    end

    local function tablist()
      local result, number_of_tabs = "", fn.tabpagenr "$"

      if number_of_tabs > 1 then
        for i = 1, number_of_tabs, 1 do
          local tab_hl = ((i == fn.tabpagenr()) and "%#TbLineTabOn# ") or "%#TbLineTabOff# "
          result = result .. ("%" .. i .. "@TbGotoTab@" .. tab_hl .. i .. " ")
        end
        return result
      end

      return ""
    end

    modules[1] = ""
    modules[2] = bufferlist()
    modules[3] = tablist()
    modules[4] = ""
  end,
}
