local M = {}

M.configComment = function()
  if require("Comment.ft") ~= nil then
    local ft = require("Comment.ft")
    ft.set("nwscript", { "//%s", "/*%s*/" })
  end
end

M.configTreesitter = function()
  -- Create NWScript grammar
  if require("nvim-treesitter.parsers") ~= nil and require("nvim-treesitter.configs") ~= nil then
    local parser = require("nvim-treesitter.parsers").get_parser_configs()
    parser.nwscript = {
      install_info = {
        url = "https://github.com/tinygiant98/tree-sitter-nwscript",
        files = { "src/parser.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filestype = "nwscript",
    }

    local configs = require("nvim-treesitter.configs")
    configs.config = {
      ensure_installed = {
        "nwscript",
      },
    }
  end
end

M.configNeogen = function()
  if require("neogen") ~= nil then
    local neogen = require("neogen")
    neogen.setup({
      snippet_engine = "luasnip",
      languages = {
        nwscript = require("nwscript.configs.neogen.nwscript"),
      },
    })
  end
end

M.configFormatter = function()
  if require("null-ls") ~= nil then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")

    local format = function(bufnr)
      vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end

    local on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            format(bufnr)
          end,
        })
      end
    end

    local formatting = null_ls.builtins.formatting -- to setup formatters

    local clfPath = function()
      if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1 then
        return os.getenv("UserProfile") .. "/.clang-format" -- Must create this folder
      else -- I don't own/use a Mac, will update when/if I do
        return os.getenv("HOME") .. "/.clang-format" -- Must create this folder
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

    local rootdir = function(fname)
      return null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "nasher.cfg")(fname)
    end

    null_ls.register(sources)

    local clients = vim.lsp.get_clients({ bufnr = 0 })

    for _, client in ipairs(clients) do
      if client.name == "null-ls" then
        on_attach(client, 0)
      end
    end
  end
end

M.configLuasnip = function()
  if require("luasnip") ~= nil then
    local loaders = require("luasnip.loaders.from_lua")

    local path = function()
      if vim.uv.os_uname().sysname == "Windows_NT" then
        return os.getenv("UserProfile") .. "/AppData/Local/nvim/lazy/nwscript-ee-lsp.nvim/snippets"
      end
      return os.getenv("HOME") .. "/.local/share/nvim/lazy/nwscript-ee-lsp.nvim/snippets"
    end

    loaders.load({ paths = path() })
  end
end

M.configVimNWScript = function() end

M.configUltiSnips = function()
  local path = function()
    if vim.uv.os_uname().sysname == "Windows_NT" then
      return os.getenv("UserProfile") .. "/AppData/Local/nvim/lazy/vim-nwscript/UltiSnips"
    end
    return os.getenv("HOME") .. "/.local/share/nvim/lazy/vim-nwscript/UltiSnips"
  end

  vim.g.UltiSnipsSnippetDirectories = { path(), "UltiSnips" }
end

-- {
--   "squattingmonk/vim-nwscript",
--   config = function()
--     -- Luascript doesn't work, let's use vim.cmd([[]]) to run Vimscript inside it
--     vim.cmd([[
--       let g:nwscript#modules#enabled = ['ctags', 'format']
--       let g:nwscript#modules#disabled = ['fold']
--       let g:nwscript#format#textwidth = 105
--       let g:nwscript#format#options = 'croqwa2lj'
--       let g:nwscript#format#whitespace = 1
--     ]])
--   end,
-- },

return M
