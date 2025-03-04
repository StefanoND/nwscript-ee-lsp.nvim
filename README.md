# nwscript-ee-lsp.nvim

NWScript: EE LSP is a Neovim plugin for the NWScript language

## WIP but working.

The script is working as intended as is, but everything's "hardcoded" to my setup before I decided to
turn this into a plugin, so I'm currently making it more configurable.

Credits goes to everyone mentioned in the .lua files

## Features

Enhanced syntax highlighting
Completion
Hover information
Goto definition
Formatting
Range formatting
Signature help
Diagnostics
Document Symbols
Snippets

## Dependencies

### Formatting

[clang-format](https://clang.llvm.org/docs/ClangFormat.html)

### Tools

[NodeJS](https://github.com/nodejs/node)
[npm](https://github.com/npm/cli)

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

### Diagnostics

Neverwinter Nights home and installation folders.

## Usage
