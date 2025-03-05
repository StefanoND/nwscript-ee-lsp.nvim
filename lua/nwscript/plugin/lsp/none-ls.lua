local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting -- to setup formatters

local clfPath = function()
  if vim.uv.os_uname().sysname == "Windows_NT" then
    return os.getenv("UserProfile") .. "/.clang-format" -- Must create this file
  elseif vim.uv.os_uname().sysname == "Darwin" then
    return os.getenv("HOME") .. "/.clang-format" -- Must create this file
  else -- I don't own/use a Mac, will update when/if I do
    return os.getenv("HOME") .. "/.clang-format" -- Must create this file
  end
end

local sources = {
  formatting.clang_format.with({
    filetypes = { "nss", "nwscript" },
    disabled_filetypes = { "cs", "csharp" }, -- Don't want it messing with C#
    extra_args = {
      "-style=file:" .. vim.fn.expand(clfPath()),
    },
  }),

  formatting.clang_format,
}
