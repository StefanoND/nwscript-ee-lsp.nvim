# nwscript-ee-lsp.nvim

NWScript: EE LSP is a Neovim plugin for the NWScript language

## WIP but working.

The script is working as intended as is, but everything's "hardcoded" to my setup before I decided to
turn this into a plugin, so I'm currently making it more configurable.

Credits goes to everyone mentioned in the .lua files

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
- [npm](https://github.com/npm/cli) -- Required, Package Manager for NodeJS
- [yarn](https://github.com/yarnpkg/yarn) -- Required, Dependency Manager for NodeJS
- [vsce](https://github.com/microsoft/vscode-vsce) -- Required, VSCode's Package Manager
- [Universal-CTags](https://github.com/universal-ctags/ctags) -- Optional, If using squattingmonk's vim-nwscript
- [clang-format](https://clang.llvm.org/docs/ClangFormat.html) -- Optional, Formatting
- [doxygen](https://github.com/doxygen/doxygen) -- Optional, Documentation Generation

## Installation/Configuration

With [lazy.nvim](https://github.com/folke/lazy.nvim)

````lua
return { -- This is my personal configuration, plug'n'play no extra configuration required
  "StefanoND/nwscript-ee-lsp.nvim",
  ft = "nwscript",
  dependencies = {
    -- "PhilippeChab/nwscript-ee-language-server", -- Deprecated(?), LSP. Abandoned(?)
    "implicit-image/nwscript-ee-language-server", -- Required, LSP. Current maintainer
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
}```

### [nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server)

[building-and-running:](https://github.com/implicit-image/nwscript-ee-language-server?tab=readme-ov-file#building-and-running)

    # Make sure you have NodeJS and npm installed

    # CD To the LSP folder downloaded from Lazy
    # Linux
    cd "$HOME"/.local/share/nvim/lazy/nwscript-ee-language-server
    # Windows
    cd "$UserProfile"/.local/share/nvim/lazy/nwscript-ee-language-server

    # Installs Yarn (Dependency Manager) and vsce (VSCode's Package Manager)
    sudo npm i -g yarn @vscode/vsce

    # Updates old (vulnerable) dependencies
    sudo npm audit fix

    # Install all dependencies
    yarn install

    # Builds the project. Also creates the .vsix file which we don't want/need
    vsce package

## Special Thanks

- [@squattingmonk](https://github.com/squattingmonk) for his nvim [config](https://github.com/squattingmonk/dotfiles/tree/master/nvim/.config/nvim) which I used as a starting point for my own config for nwscript

## Credits

- [@neovim](https://github.com/neovim) for [Neovim](https://github.com/neovim/neovim) >= 0.10.0
- [@folke](https://github.com/folke) for [lazy.nvim](https://github.com/folke/lazy.nvim)
- [@implicit-image](https://github.com/implicit-image) for [nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server)

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
- [@npm](https://github.com/npm) for [npm](https://github.com/npm/cli)
- [@yarnpkg](https://github.com/yarnpkg) for [yarn](https://github.com/yarnpkg/yarn)
- [@microsoft](https://github.com/microsoft) for [vsce](https://github.com/microsoft/vscode-vsce)
- [@universal-ctags](https://github.com/universal-ctags) for [Universal-CTags](https://github.com/universal-ctags/ctags)
- [@llvm](https://github.com/llvm) for [clang-format](https://clang.llvm.org/docs/ClangFormat.html)
- [@doxygen](https://github.com/doxygen) for [doxygen](https://github.com/doxygen/doxygen)
````
