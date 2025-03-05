return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    -- "PhilippeChab/nwscript-ee-language-server", -- Abandoned(?)
    "implicit-image/nwscript-ee-language-server", -- Current maintainer
    dependencies = {
      "ray-x/lsp_signature.nvim",
    },
  },
  {
    "squattingmonk/vim-nwscript",
    config = function()
      -- Luascript doesn't work, let's use vim.cmd([[]]) to run Vimscript inside it
      vim.cmd([[
        let g:nwscript#modules#enabled = ['ctags', 'format']
        let g:nwscript#modules#disabled = ['fold']
        let g:nwscript#format#textwidth = 105
        let g:nwscript#format#options = 'croqwa2lj'
        let g:nwscript#format#whitespace = 1
      ]])
    end,
  },
  { -- Add comment keymaps support for nwscript
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- import comment plugin safely
      local comment = require("Comment")

      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      local ft = require("Comment.ft")
      ft.set("nwscript", { "//%s", "/*%s*/" })

      -- enable comment
      comment.setup({
        -- for commenting tsx and jsx files
        padding = true,
        sticky = true,
        ignore = "nil",
        toggler = { line = "gcc", block = "gbc" },
        opleader = { line = "gc", block = "gb" },
        extra = { above = "gcO", below = "gco", eol = "gcA" },
        mappings = { basic = true, extra = true },
        pre_hook = ts_context_commentstring.create_pre_hook(),
        post_hook = nil,
      })
    end,
  },
  { -- parser
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- Windows: https://code.visualstudio.com/docs/cpp/config-mingw
      -- Follow the steps 1-7 of "Installing the MingGW-w64 toolchain"
      -- Before running "pacman -S --needed ...." run "pacman -Syu" first
      -- Choose the "mingw-w64-ucrt-x86_64-gcc" as of this writting, it is number 3 (Three)

      local config = function(_)
        -- Create NWScript grammar
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.nwscript = {
          install_info = {
            url = "https://github.com/tinygiant98/tree-sitter-nwscript",
            files = { "src/parser.c" },
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          filestype = "nwscript",
        }

        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "nwscript",
          },
        })
      end

      config()
    end,
  },
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    config = function()
      local neogen = require("neogen")

      neogen.setup({
        languages = {
          nwscript = require("plugins.neogen.nwscript"),
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    event = "VeryLazy",
    config = function()
      local null_ls = require("null-ls")

      local formatting = null_ls.builtins.formatting -- to setup formatters

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

      null_ls.setup({
        sources = sources,
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = function()
      if vim.uv.os_uname().sysname ~= "Windows_NT" then
        return "make install_jsregexp"
      end
    end,
    config = function()
      local luasnip = require("luasnip")

      local path = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets"

      require("luasnip.loaders.from_lua").lazy_load({ paths = path })
    end,
  },
  {
    "SirVer/ultisnips",
    init = function()
      local nwSnippets = vim.fn.expand("$HOME/.local/share/nvim/lazy/vim-nwscript/UltiSnips")
      vim.g.UltiSnipsSnippetDirectories = { nwSnippets, "UltiSnips" }
    end,
  },
}
