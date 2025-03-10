#!/usr/bin/env bash

if ! [ "$EUID" -ne 0 ]; then
  echo
  printf "%s: [WARN] Don't run this script as root. Exiting.\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
  echo
  sleep 1s
  exit 1
fi

SCRIPT_PATH=$(dirname "$(realpath "$0")")

cd "$SCRIPT_PATH"

cd ../

CURDIR=$PWD

if ! [[ -d "$CURDIR/nwscript-ee-language-server" ]]; then
  echo
  printf "%s: [ERROR] nwscript-ee-language-server plugin not found\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
  echo
  sleep 1s
  exit 1
fi

LSPDIR="$CURDIR/nwscript-ee-language-server"
cd "$LSPDIR"

if [[ -d "$LSPDIR/server/out" ]]; then
  echo
  printf "%s: [INFO] LPS is already built. Exiting.\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
  echo
  exit 0
fi

if ! [[ "$(command -v node)" ]]; then
  echo
  printf "%s: [ERROR] Node.js not found, verify if it's installed and in PATH\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
  echo
  sleep 1s
  exit 1
fi
if ! [[ "$(command -v npm)" ]]; then
  echo
  printf "%s: [ERROR] npm not found, verify if it's installed and in PATH\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
  echo
  sleep 1s
  exit 2
fi
if ! [[ -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME"/.local/bin
  printf "%s: [INFO] Creating %s/.local/bin folder\n" "$(date)" "$HOME" | tee -a "$SCRIPT_PATH/nwscript.log"
  sync
fi
ORIGINALPREFIX=$(cat "$HOME"/.npmrc)
if ! grep -i "local" "$HOME"/.npmrc; then
  printf "%s: [INFO] Setting %s/.local as npm's default install path\n" "$(date)" "$HOME" | tee -a "$SCRIPT_PATH/nwscript.log"
  npm config set prefix "$HOME/.local"
  sync
fi

printf "%s: [INFO] Installing 'yarn' and '@vscode/vsce'\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
npm install -g yarn @vscode/vsce
sync
printf "%s: [INFO] Running 'npm audit fix'\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
npm audit fix
sync

printf "%s: [INFO] Running 'yarn install'\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
yarn install
sync
printf "%s: [INFO] Running 'vsce package'\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
vsce package
sync
printf "%s: [INFO] Uninstalling 'yarn' and '@vscode/vsce'\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
npm uninstall -g yarn @vscode/vsce
sync
printf "%s: [INFO] Setting npm's default install path back to '%s'\n" "$(date)" "$ORIGINALPREFIX" | tee -a "$SCRIPT_PATH/nwscript.log"
npm config set prefix "$ORIGINALPREFIX"
sync

printf "%s: [SUCCESS] LSP built.\n\n" "$(date)" | tee -a "$SCRIPT_PATH/nwscript.log"
sync
exit 0
