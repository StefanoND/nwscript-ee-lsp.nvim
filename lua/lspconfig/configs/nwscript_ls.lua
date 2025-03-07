local lspconfig = require("lspconfig")
local util = lspconfig.util

local lazyPath = function()
  if vim.uv.os_uname().sysname == "Linux" then
    return os.getenv("HOME") .. "/.local/share/nvim/lazy"
  end
  if vim.uv.os_uname().sysname == "Windows_NT" then
    return os.getenv("UserProfile") .. "/AppData/Local/nvim/lazy"
  end
end

local nwServerJSPath = function()
  if os.getenv("NWN_LSP") then
    return os.getenv("NWN_LSP")
  end
  return lazyPath() .. "/nwscript-ee-language-server/server/out/server.js"
end

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
  if vim.fn.filereadable(nwServerJSPath()) == 0 and not isSymlink(nwServerJSPath()) then
    vim.notify("Did not find server.js file", vim.log.levels.ERROR)
    return false
  end
  return true
end

local serverCommand = function()
  if findExecutable() then
    return "node", nwServerJSPath(), unpack(nwLSPServerArgs)
  end
  return nil
end

local nwSettings = require("nwscript.configs.settings").nwSettings

local protocol = vim.lsp.protocol
local cmpcapabilities = require("cmp_nvim_lsp").default_capabilities(protocol.make_client_capabilities())

local capabilities = vim.tbl_deep_extend("force", util.default_config.capabilities, cmpcapabilities, {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
  },
  workspace = {
    configuration = true,
    didChangeConfiguration = { dynamicRegistration = true },
  },
  offsetEncoding = { "utf-8" },
  didChangeWatchedFiles = {
    -- TODO(lewis6991): do not advertise didChangeWatchedFiles on Linux
    -- or BSD since all the current backends are too limited.
    -- Ref: #27807, #28058, #23291, #26520
    relativePatternSupport = false,
  },
})

return {
  default_config = {
    name = "nwscript_ls",
    capabilities = capabilities,
    cmd = { serverCommand() },
    filetypes = { "nss", "nwscript" },
    root_dir = util.root_pattern(".git", "nasher.cfg", "Makefile"),
    single_file_support = true,
    settings = nwSettings,
  },
  docs = {
    description = [[
      https://github.com/StefanoND/nwscript-ee-lsp.nvim

      LSP for NWScript
      ]],
  },
}
