#!/usr/bin/env bash
#
# Description of the script.

nwneeLSPPath="$HOME"/.local/share/nvim/lazy/nwscript-ee-language-server
cd "$nwneeLSPPath" || exit
if ! npm list | grep -i yarn; then
  sudo npm i -g yarn @vscode/vsce
  sync
  sudo npm audit fix
  sync
fi
yarn install
sync
vsce package
sync

## This part below is not needed, for personal testing purposes
# extract nwscript-ee-language-server*.vsix
# sync
