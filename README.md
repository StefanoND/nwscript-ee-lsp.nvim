# nwscript-ee-lsp.nvim

NWScript: EE LSP is a Neovim plugin for the NWScript language

## TODO

[x] Provide prebuilt [nwscript-ee-language-server](https://github.com/StefanoND/nwscript-ee-language-server) binary so [building-and-running](https://github.com/StefanoND/nwscript-ee-lsp.nvim/blob/trunk/README.md#nwscript-ee-language-server) isn't needed
[ ] Add documentation
[ ] Keymap configuration
[ ] Make all snippets from LuaSnip work in UltiSnips and Vice-Versa

## Features

- NWScript filetype support and extension
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) support
- [doxygen](https://github.com/doxygen/doxygen) support
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)/[ultisnips](https://github.com/SirVer/ultisnips) Snippets
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) Syntax highlighting
- [nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server) and it's [features](https://github.com/implicit-image/nwscript-ee-language-server?tab=readme-ov-file#features)

## Requirements

### Required

- [Neovim](https://github.com/neovim/neovim) >= 0.10.0
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server)

### Optional

- [Comment](https://github.com/numToStr/Comment.nvim) -- Optional, comment plugin
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) -- Optional, Snippet Engine for Neovim
- [lsp_signature](https://github.com/ray-x/lsp_signature.nvim) -- Optional, needed for rounded borders
- [neogen](https://github.com/danymat/neogen) -- Optional, Annotation generator
- [none-ls](https://github.com/nvimtools/none-ls.nvim) -- Optional, LSP diagnostic, code actions, etc. Injection
- [plenary](https://github.com/nvim-lua/plenary.nvim) -- Optional, Provides utility functions for plugins .nss extension
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) -- Optional, syntax highlighting
- [ultisnips](https://github.com/SirVer/ultisnips) -- Optional, Slution for snippets for Neovim
- [vim-nwscript](https://github.com/squattingmonk/vim-nwscript) -- Optional, auto-indention/wrapping of comments, snippets and ctags generation
- [which-key](https://github.com/folke/which-key.nvim) -- Optional, Displays keymap hints

### External

- [NodeJS](https://github.com/nodejs/node) -- Required, Executable for LSP

<details><summary>NodeJS Install</summary>

## Linux

### Arch

    sudo pacman -S nodejs --noconfirm --needed

### Debian

    sudo apt install nodejs -y

### Fedora

    sudo dnf install nodejs -y

## Windows

    winget install -e --id OpenJS.NodeJS

</details>

- [Universal-CTags](https://github.com/universal-ctags/ctags) -- Optional, If using squattingmonk's vim-nwscript
- [clang-format](https://clang.llvm.org/docs/ClangFormat.html) -- Optional, Formatting
- [doxygen](https://github.com/doxygen/doxygen) -- Optional, Documentation Generation

## Installation/Configuration

With [lazy.nvim](https://github.com/folke/lazy.nvim)

<details><summary>Default Options</summary>

## LSP

### Config

```lua
-- Setup with default config
lspconfig.nwscript_ls.setup()

-- This is the default config, if you don't want to change anything, use the setup command above
lspconfig.nwscript_ls.setup({
  capabilities = capabilities,
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
      ignoreGlobs = {},
    },
    compiler = {
      enabled = true,
      -- Return OS' name: Linux, Darwin (MacOS), FreeBSD, NetBSD, OpenBSD, Windows, CYGWIN_NT, MSYS_NT
      os = vim.uv.os_uname().sysname,
      verbose = true,
      reportWarnings = true,
      nwnHome = os.getenv("NWN_HOME"), -- Environment Variable in my PC
      nwnInstallation = os.getenv("NWN_ROOT"), -- Environment Variable in my PC
      nwneeBaseIncludes = {},
      nwnBaseIncludes = {},
      nwn2BaseIncludes = {},
      workspaceIncludes = tostring(vim.fn.getcwd()), -- "Current Working Directory"
    },
  }
})
```

### Capabilities

```lua
vim.tbl_deep_extend("force", util.default_config.capabilities, cmpcapabilities, {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
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
```

</details>

```lua
return { -- This is my personal configuration, plug'n'play no extra configuration required
  "StefanoND/nwscript-ee-lsp.nvim",
  ft = "nwscript",
  dependencies = {
    -- "PhilippeChab/nwscript-ee-language-server", -- Deprecated(?), LSP. Abandoned(?)
    -- "implicit-image/nwscript-ee-language-server", -- Required, LSP. Current maintainer
    "StefanoND/nwscript-ee-language-server", -- Required, LSP. My fork with prebuilt binaries
    "L3MON4D3/LuaSnip", -- Optional, Snippet Engine for Neovim
    "SirVer/ultisnips", -- Optional, Slution for snippets for Neovim
    "danymat/neogen", -- Optional, Annotation generator
    "folke/which-key.nvim", -- Optional, Displays keymap hints
    "numToStr/Comment.nvim", -- Optional, comment plugin
    "nvim-lua/plenary.nvim", -- Optional, Provides utility functions for plugins .nss extension
    "nvim-treesitter/nvim-treesitter", -- Optional, syntax highlighting
    "nvimtools/none-ls.nvim", -- Optional, LSP diagnostic, code actions, etc. Injection
    "ray-x/lsp_signature.nvim", -- Optional, needed for rounded borders
    {
      "squattingmonk/vim-nwscript", -- Optional, auto-indention/wrapping of comments, snippets and ctags generation
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
  }
  config = function()
    require("nwscript").setup()
  end,
}
```

## Keymap

Keymaps not listed here are using your own configured keymaps or the plugin's default keymaps

| Keymap      | Function                | Description                                    |
| ----------- | ----------------------- | ---------------------------------------------- |
| <leader>nwc | nasher compile -f '%:p' | Compile current script                         |
| <leader>nwC | nasher compile all      | Compile all scripts                            |
| <leader>nwi | nasher install -y main  | Pack project into module                       |
| <leader>nwu | nasher unpack -y main   | Unpack module to project folder                |
| <leader>tg  | NWScriptTagGen          | Generate ctags for current project             |
| <leader>tG  | NWScriptTagGenAll       | Generate ctags for project inc. external dirs. |

## Special Thanks

- [@squattingmonk](https://github.com/squattingmonk) for his nvim [config](https://github.com/squattingmonk/dotfiles/tree/master/nvim/.config/nvim) which I used as a starting point for my own config for nwscript
- [@implicit-image](https://github.com/implicit-image) for his emacs [config](https://github.com/implicit-image/lsp-nwscript.el) which I used as base to "translate" to neovim

## Credits

- [@neovim](https://github.com/neovim) for [Neovim](https://github.com/neovim/neovim)
- [@folke](https://github.com/folke) for [lazy.nvim](https://github.com/folke/lazy.nvim)
- [@PhilippeChab](https://github.com/PhilippeChab) for creating [nwscript-ee-language-server](https://github.com/PhilippeChab/nwscript-ee-language-server)
- [@implicit-image](https://github.com/implicit-image) for maintaining [nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server)

- [@numToStr](https://github.com/numToStr) for [Comment](https://github.com/numToStr/Comment.nvim)
- [@L3MON4D3](https://github.com/L3MON4D3) for [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [@ray-x](https://github.com/ray-x) for [lsp_signature](https://github.com/ray-x/lsp_signature.nvim)
- [@danymat](https://github.com/danymat) for [neogen](https://github.com/danymat/neogen)
- [@nvimtools](https://github.com/nvimtools) for [none-ls](https://github.com/nvimtools/none-ls.nvim)
- [@nvim-lua](https://github.com/nvim-lua) for [plenary](https://github.com/nvim-lua/plenary.nvim)
- [@nvim-treesitter](https://github.com/nvim-treesitter) for [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [@SirVer](https://github.com/SirVer) for [ultisnips](https://github.com/SirVer/ultisnips)
- [@squattingmonk](https://github.com/squattingmonk) for [vim-nwscript](https://github.com/squattingmonk/vim-nwscript)
- [@folke](https://github.com/folke) for [which-key](https://github.com/folke/which-key.nvim)

- [@nodejs](https://github.com/nodejs) for [NodeJS](https://github.com/nodejs/node)
- [@universal-ctags](https://github.com/universal-ctags) for [Universal-CTags](https://github.com/universal-ctags/ctags)
- [@llvm](https://github.com/llvm) for [clang-format](https://clang.llvm.org/docs/ClangFormat.html)
- [@doxygen](https://github.com/doxygen) for [doxygen](https://github.com/doxygen/doxygen)
