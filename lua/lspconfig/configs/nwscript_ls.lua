local lspconfig = require("lspconfig")
local util = lspconfig.util

local lazyPath = function()
  if vim.uv.os_uname().sysname == "Linux" then
    return os.getenv("HOME") .. "/.local/share/nvim/lazy"
  end
  if vim.uv.os_uname().sysname == "Windows" then
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

local functions = require("nwscript.configs.functions")

local serverCommand = function()
  if functions.findExecutable("node") and functions.findFile(nwServerJSPath()) then
    return "node", nwServerJSPath(), unpack(nwLSPServerArgs)
  end
  return nil
end

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

local nwSettings = require("nwscript.configs.settings").nwSettings
local nwCodelens = require("nwscript.configs.settings").codelens

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
  codelens = nwCodelens,
  docs = {
    description = [[
      https://github.com/StefanoND/nwscript-ee-lsp.nvim

      LSP for NWScript
      ]],
  },
}
