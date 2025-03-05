-- Add support for NWN:EE's LSP
-- Thanks to implicit-image and his repo: https://github.com/implicit-image/lsp-nwscript.el
-- Which I somehow manged to "convert" from emacs to neovim

-- NWN:EE's LSP
-- Original author: https://github.com/PhilippeChab/nwscript-ee-language-server
-- Current maintainer: https://github.com/implicit-image/nwscript-ee-language-server

-- Change these to the correct path
local nwnPaths = {
  docs = os.getenv("NWN_HOME"),
  -- docs = os.getenv("HOME") .. "/Documents/Neverwinter Nights",
  -- docs = "/home/USERNAME/Documents/Neverwinter Nights",
  -- docs = "~/Documents/Neverwinter Nights",
  -- docs = os.getenv("UserProfile") .. "/My Documents/Neverwinter Nights",
  -- docs = "C:/Users/USERNAME/My Documents/Neverwinter Nights",
  root = os.getenv("NWN_ROOT"),
  -- root = os.getenv("HOME") .. "/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "/home/USERNAME/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "~/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "C:/Program Files (x86)/Steam/steamapps/common/Neverwinter Nights",
}

-- Includes
-- Must be array, too lazy to make it work with tables
-- Seems that the root path of the project is enough. I'm using Nasher so it might be helping
local nwIncludes = {
  tostring(vim.fn.getcwd()),
  -- tostring(vim.fn.getcwd()) .. "/src",
  -- tostring(vim.fn.getcwd()) .. "/src/nss",
}

-- "List of base include dirs for Neverwinter Nights Enhanced Edition."
-- Must be array, too lazy to make it work with tables
local nwneeBaseIncludes = {}

-- "List of base include dirs for Neverwinter Nights Diamond."
-- Must be array, too lazy to make it work with tables
local nwnBaseIncludes = {}

-- "List of base include dirs for Neverwinter Nights 2"
-- Must be array, too lazy to make it work with tables
local nwn2BaseIncludes = {}

-- Ignore
-- Must be array, too lazy to make it work with tables
local nwIgnores = {
  -- "/path/to/ignore",
  -- "/file/to/ignore.nss",
  -- "/path/to/ignore/dir1/subdir1",
  -- "/path/to/ignore/dir1/subdir2",
  -- "/path/to/ignore/dir1/ignore1.nss",
  -- "/path/to/ignore/dir1/ignore2.nss",
}

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

local lsp = require("lsp-zero")
lsp.extend_lspconfig()

lsp.setup()

local lspconfig = require("lspconfig")
local util = lspconfig.util
local protocol = vim.lsp.protocol

-- vim.api.nvim_exec(
vim.cmd(
  [[
  autocmd FileType nwscript setlocal lsp
  ]],
  false
)

local nwSettings = {
  single_file_support = true,
  ["nwscript-ee-lsp"] = {
    completion = {
      addParamsToFunctions = true,
    },
    hovering = {
      addCommentsToFunctions = true,
    },
    formatter = {
      enabled = true,
      verbose = true,
      executable = "clang-format",
      ignoreGlobs = nwIgnores,
    },
    compiler = {
      enabled = true,
      os = vim.uv.os_uname().sysname,
      verbose = true,
      reportWarnings = true,
      nwnHome = nwnPaths.docs,
      nwnInstallation = nwnPaths.root,
      nwneeBaseIncludes = nwneeBaseIncludes,
      nwnBaseIncludes = nwnBaseIncludes,
      nwn2BaseIncludes = nwn2BaseIncludes,
      workspaceIncludes = nwIncludes,
    },
  },
}

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

local defaultCapabilities = util.default_config.capabilities
local cmpcapabilities = require("cmp_nvim_lsp").default_capabilities(protocol.make_client_capabilities())

local capabilities = vim.tbl_deep_extend(
  "force",
  -- protocol.make_client_capabilities(),
  defaultCapabilities,
  cmpcapabilities,
  {
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
    offsetEncoding = { "utf-8", "utf-16", "utf-32" },
    didChangeWatchedFiles = {
      -- TODO(lewis6991): do not advertise didChangeWatchedFiles on Linux
      -- or BSD since all the current backends are too limited.
      -- Ref: #27807, #28058, #23291, #26520
      relativePatternSupport = false,
    },
  }
)

return {
  lspconfig.nwscript_language_server.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      nwscriptfuncs(client, bufnr)
      nwscriptrefresh(bufnr)

      require("lsp_signature").on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
          border = "rounded",
        },
      }, bufnr)

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,
      })

      -- Enable snippet support (if your completion plugin supports snippets)
      -- vim.bo[bufnr].expandtab = false
      -- vim.bo[bufnr].shiftwidth = 4
    end,
    settings = nwSettings,
  }),
}
