local M = {}

local funcs = require("nwscript.configs.functions")

M.configComment = function()
  if funcs.isLoaded("Comment.ft") then
    local ft = require("Comment.ft")
    ft.set("nwscript", { "//%s", "/*%s*/" })
  end
end

M.configTreesitter = function()
  if funcs.isLoaded("nvim-treesitter.parsers") and funcs.isLoaded("nvim-treesitter.configs") then
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
  if funcs.isLoaded("neogen") then
    local neogen = require("neogen")
    neogen.setup({
      languages = {
        nwscript = require("nwscript.configs.neogen.nwscript"),
      },
    })
  end
end

M.configFormatter = function()
  if funcs.isLoaded("conform") then
    local conform = require("conform")
    conform.opts = {
      formatters_by_ft = {
        nwscript = { "clang-format" },
      },
    }
  end
  if funcs.isLoaded("null-ls") then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require("null-ls")

    local format = function(bufnr)
      vim.lsp.buf.format({
        async = false,
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
  if funcs.isLoaded("luasnip") then
    local luasnip = require("luasnip")
    local loaders = require("luasnip.loaders.from_lua")

    luasnip.filetype_extend("nwscript", { "nwdocs" })

    local path = function()
      return vim.fn.stdpath("data") .. "/lazy/nwscript-ee-lsp.nvim/snippets"
    end

    loaders.load({ paths = path() })
  end
end

M.configUltiSnips = function()
  local path = function()
    return vim.fn.stdpath("data") .. "/lazy/nwscript-ee-lsp.nvim/UltiSnips"
  end

  vim.g.UltiSnipsSnippetDirectories = { path(), "UltiSnips" }
end

M.configDevIcons = function()
  if funcs.isLoaded("nvim-web-devicons") then
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

M.configFolds = function()
  if funcs.isLoaded("ufo") then
    require("ufo").config = function(_, opts)
      local ftmap = {
        nwscript = { "treesitter", "indent" },
      }

      return vim.tbl_extend("force", opts, {
        provider_selector = function(_, filetype, _)
          return ftmap[filetype] or { "treesitter", "indent" }
        end,
        close_fold_kinds_for_ft = { default = { "imports" } },
      })
    end
  end
end

return M
