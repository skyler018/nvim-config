local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Regex Files" })
end

local function picker_available()
  return package.loaded["snacks"] ~= nil or package.loaded["snacks.picker"] ~= nil
end

local function to_file_items(paths, cwd)
  local items = {}
  for _, path in ipairs(paths) do
    if path ~= "" then
      items[#items + 1] = {
        text = path,
        file = vim.fs.normalize(cwd .. "/" .. path),
      }
    end
  end
  return items
end

local function system(cmd, opts)
  local result = vim.system(cmd, vim.tbl_extend("force", { text = true }, opts or {})):wait()
  return result.code, result.stdout or "", result.stderr or ""
end

local function list_files(cwd)
  return system({ "rg", "--files" }, { cwd = cwd })
end

local function filter_files(paths_text, pattern, cwd)
  return system({ "rg", "--color=never", "--no-line-number", "--regexp", pattern }, {
    cwd = cwd,
    stdin = paths_text,
  })
end

local function finder(opts, ctx)
  local pattern = vim.trim(ctx.filter.search)
  if pattern == "" then
    return to_file_items(vim.split(opts.paths_text, "\n", { trimempty = true }), opts.cwd)
  end

  local code, stdout, stderr = filter_files(opts.paths_text, pattern, opts.cwd)
  if code ~= 0 and code ~= 1 then
    if opts.last_error ~= stderr then
      opts.last_error = stderr
      vim.schedule(function()
        notify(stderr ~= "" and vim.trim(stderr) or ("Invalid regex: " .. pattern), vim.log.levels.ERROR)
      end)
    end
    return {}
  end

  opts.last_error = nil
  return to_file_items(vim.split(stdout, "\n", { trimempty = true }), opts.cwd)
end

function M.open(opts)
  opts = opts or {}
  local cwd = vim.fs.normalize(opts.cwd or LazyVim.root())

  local files_code, files_stdout, files_stderr = list_files(cwd)
  if files_code ~= 0 then
    notify(files_stderr ~= "" and files_stderr or "Failed to list files with rg --files", vim.log.levels.ERROR)
    return
  end

  if not picker_available() then
    notify("Snacks picker is not available", vim.log.levels.ERROR)
    return
  end

  local state = {
    cwd = cwd,
    paths_text = files_stdout,
    last_error = nil,
  }

  Snacks.picker({
    title = "Regex Files",
    live = true,
    supports_live = true,
    search = opts.default or "",
    pattern = "",
    finder = function(_, ctx)
      return finder(state, ctx)
    end,
    filter = {
      transform = function(_, filter)
        filter.pattern = ""
      end,
    },
    format = "file",
    preview = "file",
    show_empty = true,
    matcher = {
      sort = false,
    },
    layout = { preset = "default" },
  })
end

return M
