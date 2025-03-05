# nwscript-ee-lsp.nvim

NWScript: EE LSP is a Neovim plugin for the NWScript language

## WIP but working.

The script is working as intended as is, but everything's "hardcoded" to my setup before I decided to
turn this into a plugin, so I'm currently making it more configurable.

Credits goes to everyone mentioned in the .lua files

## Features

NWScript filetype support and extension
Formatting
LuaSnip/UltiSnips Snippets
Treesitter highlighting
Documentation Generation (from [doxygen](https://github.com/doxygen/doxygen))
Comment (from [Comment.nvim](https://github.com/numToStr/Comment.nvim))
[nwscript-ee-language-server](https://github.com/implicit-image/nwscript-ee-language-server) and it's [features](https://github.com/implicit-image/nwscript-ee-language-server?tab=readme-ov-file#features)

## Dependencies

    dependencies = {
      -- "PhilippeChab/nwscript-ee-language-server", -- Deprecated(?), LSP Abandoned(?)
      "implicit-image/nwscript-ee-language-server", -- Required, LSP Current maintainer
      "L3MON4D3/LuaSnip", -- Optional, Snippet Engine for Neovim
      "SirVer/ultisnips", -- Optional, Slution for snippets for Neovim
      "danymat/neogen", -- Optional, Annotation generator
      "numToStr/Comment.nvim", -- Optional, comment plugin
      "nvim-lua/plenary.nvim", -- Optional, .nss extension
      "nvim-treesitter/nvim-treesitter", -- Optional, syntax highlighting
      "nvimtools/none-ls.nvim", -- Optional, LSP diagnostic, code actions, etc. Injection
      "ray-x/lsp_signature.nvim", -- Optional, needed for rounded borders
      "squattingmonk/vim-nwscript", -- Optional, auto-indention/wrapping of comments, snippets and ctags generation
    }

### Tools

[clang-format](https://clang.llvm.org/docs/ClangFormat.html) (Formatting)
[NodeJS](https://github.com/nodejs/node) (Executable for LSP)
[npm](https://github.com/npm/cli) (Package Manager for NodeJS)
[Universal-CTags](https://github.com/universal-ctags/ctags) (If using squattingmonk's vim-nwscript)
[doxygen](https://github.com/doxygen/doxygen) (Documentation Generation)
[llvm](https://github.com/llvm/llvm-project)/[clang](https://clang.llvm.org/)

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

## Config

### Lazy.vim

    return {
      {
        "StefanoND/nwscript-ee-lsp.nvim",
        dependencies = {
          "implicit-image/nwscript-ee-language-server", -- Required, LSP Current maintainer
          "L3MON4D3/LuaSnip", -- Optional, Snippet Engine for Neovim
          "SirVer/ultisnips", -- Optional, Slution for snippets for Neovim
          "danymat/neogen", -- Optional, Annotation generator
          "numToStr/Comment.nvim", -- Optional, comment plugin
          "nvim-lua/plenary.nvim", -- Optional, .nss extension
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
        },
        config = function()
          require("nwscript").setup()
        end,
      },
    }

## Usage

## Credits
