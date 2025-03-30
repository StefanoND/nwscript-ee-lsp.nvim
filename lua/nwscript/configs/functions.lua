local M = {}

M.isInstalled = function(name)
  assert(type(name) == "string", "Expected a string value")
  return pcall(require, name)
end

M.isLoaded = function(name)
  assert(type(name) == "string", "Expected a string value")
  return package.loaded[name]
end

M.nwscriptrefresh = function(bufnr)
  local augroup = vim.api.nvim_create_augroup("NWScript", {})
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.cmd("LspRestart")
    end,
  })
end

M.isSymlink = function(path)
  if path == nil then
    return false
  end
  local handle = io.popen("test -L " .. path .. "; echo $?")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return tonumber(result:match("%d+")) == 0
  else
    return false
  end
end

M.findExecutable = function(executable)
  if vim.fn.executable(executable) == 0 then
    return false
  end
  return true
end

M.findFile = function(path)
  if path == nil then
    return false
  end
  if vim.fn.filereadable(path) == 0 and not M.isSymlink(path) then
    return false
  end
  return true
end

M.clfPath = function(path)
  if path ~= nil then
    if M.findFile(path) then
      return path
    end
    vim.notify("Did not find " .. tostring(path), vim.log.levels.ERROR)
  end
  if path == nil then
    if M.findFile(vim.fn.getcwd() .. "/.clang-format") then
      return vim.fn.getcwd() .. "/.clang-format"
    end
    if os.getenv("UserProfile") ~= nil and M.findFile(os.getenv("UserProfile") .. "/.clang-format") then
      return os.getenv("UserProfile") .. "/.clang-format" -- Must create this folder
    end -- I don't own/use a Mac, will update when/if I do
    if os.getenv("HOME") ~= nil and M.findFile(os.getenv("HOME") .. "/.clang-format") then
      return os.getenv("HOME") .. "/.clang-format" -- Must create this folder
    end
  end
  vim.notify("Did not find .clang-format", vim.log.levels.ERROR)
  return nil
end

-- Compile the script using Nasher
---@param all boolean: True compiles all files, false compiles only the current file
-- Default: false
---@param flags string: nasher's flags, NOT COMPILE FLAGS (compiler flags should be configured in nasher.cfg)
-- Example: "--clean -y"
-- Run "nasher compile -h" in your terminal for more info
M.nasherCompile = function(all, flags)
  all = all or false
  flags = flags or ""
  assert(type(all) == "boolean", "Expected a boolean value")
  assert(type(flags) == "string", "Expected a string value")
  if flags ~= "" then
    flags = " " .. flags
  end
  local compile = "!nasher compile"
  local command = compile .. flags
  if not all then
    command = command .. " -f '%:p'"
  else
    command = command .. " all"
  end
  vim.api.nvim_command(command)
end

-- Packs current project into a Module using Nasher
---@param target string: Name of the target defined under your nasher.cfg's "[target] name: NAME"
---@param flags string: nasher's flags, NOT COMPILE FLAGS (compiler flags should be configured in nasher.cfg)
-- Example: "--clean -y"
-- Run "nasher install -h" in your terminal for more info
M.nasherInstall = function(target, flags)
  target = target or ""
  flags = flags or ""
  assert(type(flags) == "string", "Expected a string value")
  assert(type(target) == "string", "Expected a string value")
  assert(target and #target > 0, "Expected a non-empty string")
  if flags ~= "" then
    flags = " " .. flags
  end
  if target ~= "" then
    target = " " .. target
  end
  local install = "!nasher install"
  local command = install .. flags .. target
  vim.api.nvim_command(command)
end

-- Unpacks the Module into the project using Nasher
---@param target string: Name of the target defined under your nasher.cfg's "[target] name: NAME"
---@param flags string: nasher's flags, NOT COMPILE FLAGS (compiler flags should be configured in nasher.cfg)
-- Example: "--clean -y"
-- Run "nasher unpack -h" in your terminal for more info
M.nasherUnpack = function(target, flags)
  target = target or ""
  flags = flags or ""
  assert(type(flags) == "string", "Expected a string value")
  assert(type(target) == "string", "Expected a string value")
  assert(target and #target > 0, "Expected a non-empty string")
  if flags ~= "" then
    flags = " " .. flags
  end
  if target ~= "" then
    target = " " .. target
  end
  local unpack = "!nasher unpack"
  local command = unpack .. flags .. target
  vim.api.nvim_command(command)
end

return M
