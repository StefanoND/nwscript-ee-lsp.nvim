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
    local functions = require("nwscript.configs.functions")

    local clangPath = function(path)
      if path ~= nil then
        if functions.clfPath(path) ~= nil then
          return "-style=file:" .. vim.fn.expand(functions.clfPath(path))
        end
      end
      if functions.clfPath() ~= nil then
        return "-style=file:" .. vim.fn.expand(functions.clfPath())
      end
    end

    local sources = {
      formatting.clang_format.with({
        filetypes = { "nss", "nwscript" },
        disabled_filetypes = { "cs", "csharp" }, -- Don't want it messing with C#
        extra_args = { clangPath() },
      }),

      formatting.clang_format,
    }

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
    local luasnip = require("luasnip")
    local loaders = require("luasnip.loaders.from_lua")

    luasnip.filetype_extend("nwscript", { "nwdocs" })

    local path = function()
      if vim.uv.os_uname().sysname == "Windows" then
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
    if vim.uv.os_uname().sysname == "Windows" then
      return os.getenv("UserProfile") .. "/AppData/Local/nvim/lazy/nwscript-ee-lsp.nvim/UltiSnips"
    end
    return os.getenv("HOME") .. "/.local/share/nvim/lazy/nwscript-ee-lsp.nvim/UltiSnips"
  end

  vim.g.UltiSnipsSnippetDirectories = { path(), "UltiSnips" }
end

M.configDevIcons = function()
  if require("nvim-web-devicons") ~= nil then
    local devicons = require("nvim-web-devicons")

    devicons.set_icon_by_filetype({
      nwscript = "nwscript",
    })

    devicons.set_icon({
      nwscript = {
        icon = " ",
        color = "#b4befe",
        cterm_color = "153",
        name = "NWScript",
      },
    })

    devicons.setup()
  end
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
