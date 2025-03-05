local lspconfig = require("lspconfig")
local util = lspconfig.util

vim.cmd(
  [[
  autocmd FileType nwscript setlocal lsp
  ]],
  false
)

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

local nwscriptfuncs = function(client, bufnr)
  local lopts = { buffer = bufnr, noremap = true, remap = false }
  local kmn = function(key, func, opt)
    vim.keymap.set("n", key, func, opt)
  end
  local ext = function(desc)
    vim.tbl_deep_extend("force", lopts, { desc = desc })
  end
  local compile = ":terminal nasher compile "
  local install = ":terminal nasher install "
  local unpack = ":terminal nasher unpack "

  -- Will keep using nwnsc since nwn_script_comp doesn't compile includes
  -- And doesn't support external pragma directives
  kmn("<leader>nb", compile .. "-f '%:p'<CR>", ext("Compile current script"))
  kmn("<leader>ncb", compile .. "--clean -f '%:p'<CR>", ext("Clear cache and compile current script"))
  kmn("<leader>nB", "all<CR>", ext("Compile all scripts"))
  kmn("<leader>ncB", compile .. "--clean all<CR>", ext("Clear cache and Compile all scripts"))
  kmn("<leader>ni", install .. "-y main<CR>", ext("Pack project into module"))
  kmn("<leader>nci", install .. "--clean -y main<CR>", ext("Clear cache and Pack project into module"))
  kmn("<leader>nu", ":terminal nasher unpack -y main<CR>", ext("Unpack module to project folder"))
  kmn("<leader>ncu", unpack .. "--clean -y main<CR>", ext("Unpack module to project folder"))
  kmn("<leader>tg", ":NWScriptTagGen<CR>", ext("Generate ctags for current project"))

  -- Check plugins/lsp/nwscript.lua for more information.
  kmn("<leader>tG", ":NWScriptTagGenAll<CR>", ext("Generate ctags for project inc. external dirs."))
end

local augroup = vim.api.nvim_create_augroup("NWScript", {})
local nwscriptrefresh = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.cmd("LspRestart")
    end,
  })
end

local protocol = vim.lsp.protocol
local cmpcapabilities = require("cmp_nvim_lsp").default_capabilities(protocol.make_client_capabilities())

local capabilities = vim.tbl_deep_extend("force", util.default_config.capabilities, cmpcapabilities, {
  textDocument = {
    foldingRange = {
      dynamicRegistration = true,
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

local nwscript = require("nwscript")

return {
  default_config = {
    name = "nwscript_ls",
    cmd = { serverCommand() },
    filetypes = { "nss", "nwscript" },
    root_dir = util.root_pattern(".git", "nasher.cfg", ".vscode"),
    single_file_support = true,
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      nwscriptfuncs(client, bufnr)
      nwscriptrefresh(bufnr)

      if require("lsp_signature") ~= nil then
        require("lsp_signature").on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = "rounded",
          },
        }, bufnr)
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,
      })
    end,
    settings = nwscript.nwSettings,
  },
  docs = {
    description = [[
      https://github.com/StefanoND/nwscript-ee-lsp.nvim

      LSP for NWScript
      ]],
  },
}
