local lspconfig = require("lspconfig")
local util = lspconfig.util

local lazyPath = function()
  return vim.fn.stdpath("data") .. "/lazy"
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

return {
  default_config = {
    name = "nwscript_ls",
    cmd = { serverCommand() },
    filetypes = { "nss", "nwscript" },
    root_dir = util.root_pattern(".git", "nasher.cfg", "Makefile"),
  },
  docs = {
    description = [[
      https://github.com/StefanoND/nwscript-ee-lsp.nvim

      LSP for NWScript
      ]],
  },
}
