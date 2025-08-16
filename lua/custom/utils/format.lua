local M = {}

M.register = function(...)
  require("lazyvim.util.format").register(...)
end

M.resolve = function(...)
  return require("lazyvim.util.format").resolve(...)
end

---@param opts? {force?:boolean, buf?:number, format_opts?:table}
M.format = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not (opts and opts.force) then
    return
  end

  local done = false
  -- ASYNC FORMAT START
  local run_async_formatters = function(formatters)
    local function run_next(index)
      if index > #formatters then
        return
      end
      local formatter = formatters[index]
      if formatter.active then
        done = true
        local try_opts = { msg = "Formatter `" .. formatter.name .. "` failed" }
        local try_fn = function()
          local format_timer = vim.loop.new_timer()
          local cb = function(err)
            format_timer:stop()
            format_timer:close()
            if err then
              local error_msg = (err and err.message) and "\n " .. err.message or "\n no error message"
              LazyVim.error(try_opts.msg .. error_msg, { title = "conform.nvim" })
            end
            run_next(index + 1)
          end
          format_timer:start(
            1000,
            0,
            vim.schedule_wrap(function()
              cb(true)
            end)
          )
          return formatter.format(buf, opts.format_opts, cb)
        end
        LazyVim.try(try_fn, try_opts)
      else
        run_next(index + 1)
      end
    end
    run_next(1)
  end
  run_async_formatters(M.resolve(buf))
  -- ASYNC FORMAT END

  -- SYNC FORMAT START
  -- for _, formatter in ipairs(M.resolve(buf)) do
  --   if formatter.active then
  --     done = true
  --     LazyVim.try(function()
  --       return formatter.format(buf)
  --     end, { msg = "Formatter `" .. formatter.name .. "` failed" })
  --   end
  -- end
  -- SYNC FORMAT END

  if not done and opts and opts.force then
    LazyVim.warn("No formatter available", { title = "LazyVim" })
  end
end

M.info = function(...)
  require("lazyvim.util.format").info(...)
end

M.setup = function()
  -- NOTE: uncomment if you want Autoformat
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("LazyFormat", {}),
  --   callback = function(event)
  --     M.format({ buf = event.buf })
  --   end,
  -- })

  -- Manual format
  vim.api.nvim_create_user_command("LazyFormat", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    M.format {
      force = true,
      format_opts = { range = range },
    }
  end, { desc = "Format selection or buffer", range = true })

  -- Format info
  vim.api.nvim_create_user_command("LazyFormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

return M
