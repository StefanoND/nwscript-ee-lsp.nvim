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
    neogen.configuration = {
      languages = {
        nwscript = require("nwscript.configs.neogen.nwscript"),
      },
    }
  end
end

M.configNoneLS = function()
  if require("null-ls") ~= nil then
    local clfPath = function()
      if vim.uv.os_uname().sysname == "Windows_NT" then
        return vim.fn.expand(os.getenv("UserProfile") .. "/.clang-format") -- Must create this folder
      else -- I don't own/use a Mac, will update when/if I do
        return vim.fn.expand(os.getenv("HOME") .. "/.clang-format") -- Must create this folder
      end
    end

    local null_ls = require("null-ls")

    local formatting = null_ls.builtins.formatting -- to setup formatters

    local sources = {
      formatting.clang_format.with({
        filetypes = { "nss", "nwscript" },
        extra_args = {
          "-style=file:" .. clfPath(),
        },
      }),

      formatting.clang_format,
    }

    null_ls.register({ sources })
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

  vim.g.UltiSnipsSnippetDirectories = { path, "UltiSnips" }
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
