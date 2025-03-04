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

local nwServerJSPath = lazyPath() .. "/nwscript-ee-language-server/server/out/server.js"
local nwLSPServerArgs = { "--stdio" } -- Required

return {
  default_config = {
    name = "nwscript_language_server",
    cmd = { "node", nwServerJSPath, unpack(nwLSPServerArgs) },
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
}
