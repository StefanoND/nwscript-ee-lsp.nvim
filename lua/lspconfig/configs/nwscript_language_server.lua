local util = require("lspconfig.util")

local lazyPath = function()
  if vim.uv.os_uname().sysname == "Linux" then
    return os.getenv("HOME") .. "/.local/share/nvim/lazy"
  end
  if vim.uv.os_uname().sysname == "Windows_NT" then
    return os.getenv("UserProfile") .. "/AppData/Local/nvim/lazy"
  end
end

local nwServerJSPath = lazyPath() .. "/nwscript-ee-language-server/server/out/server.js"
local nwLSPServerArgs = { "--stdio" } -- Required

local isSymlink = function(path)
  local handle = io.popen("test -L " .. path .. "; echo $?")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return tonumber(result:match("%d+")) == 0
  else
    return false
  end
end

local findExecutable = function()
  if vim.fn.executable("node") == 0 then
    vim.notify("Did not find 'node' executable", vim.log.levels.ERROR)
    return false
  end
  if vim.fn.filereadable(nwServerJSPath) == 0 and not isSymlink(nwServerJSPath) then
    vim.notify("Did not find LSP server path", vim.log.levels.ERROR)
    return false
  end
  return true
end

local serverCommand = function()
  if findExecutable() then
    return "node", nwServerJSPath, unpack(nwLSPServerArgs)
  end
  return nil
end

return {
  nwscript_language_server = {
    default_config = {
      name = "nwscript_language_server",
      cmd = { serverCommand() },
      filetypes = { "nss", "nwscript" },
      root_dir = util.root_pattern(".git", "nasher.cfg"),
      single_file_support = true,
    },
    docs = {
      description = [[
      https://github.com/StefanoND/nwscript.nvim

      LSP for NWScript
      ]],
    },
  },
}
