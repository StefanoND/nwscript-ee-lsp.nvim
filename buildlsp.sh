#!/usr/bin/env bash

SCRIPTPATH=$(dirname "$(realpath "$0")")
LOGPATH="$SCRIPTPATH/nwscript.log"
SUCCESS="SUCCESS"
INFO="INFO"
WARN="WARN"
ERROR="ERROR"
NEXT="\n"
END="\n\n"

print_log() {
  printf "%s: [%s] %s %s" "$(date)" "$1" "$2" "$3" | tee -a "$LOGPATH"
  sync
}

if ! [ "$EUID" -ne 0 ]; then
  print_log "$WARN" "Don't run this script as root. Exiting" "$END"
  sleep 1s
  exit 1
fi

commandExists() {
  command -v "$1" >/dev/null 2>&1
}

PKGS=(
  'git'
  'curl'
)

for PKG in "${PKGS[@]}"; do
  if ! commandExists "$PKG"; then
    print_log "$ERROR" "$PKG not found. Exiting." "$END"
    exit 1
  fi
done

HOMEPATH="$HOME"
APPSPATH="$HOMEPATH/.apps"
LSPROOTPATH="$APPSPATH/nwscript_ls"
OUTPATH="$LSPROOTPATH/server/out"
LSPPATH="$OUTPATH/server.js"
GITREPO='https://github.com/implicit-image/nwscript-ee-language-server.git'

if [ -f "$LSPPATH" ]; then
  print_log "$SUCCESS" "LSP is already built. Nothing else to do." "$END"
  exit 0
fi

BACKEDUPNPM="n"

if commandExists 'npm' && ! commandExists 'nvm'; then
  if ! grep -i "prefix" "$HOMEPATH/.npmrc"; then
    BACKEDUPNPM="y"
    print_log "$INFO" "Creating a backup of '$HOMEPATH/.npmrc'." "$NEXT"
    mv "$HOMEPATH/.npmrc" "$HOMEPATH/.npmrc.old" && sync
    touch "$HOMEPATH/.npmrc" && sync
    print_log "$INFO" "Setting '$HOMEPATH/.local' as npm's default install path." "$NEXT"
    npm config set prefix "$HOMEPATH/.local" && sync
  fi
fi

if ! commandExists 'nvm'; then
  print_log "$WARN" "'nvm' not found. Installing 'Node.js' and 'npm' automatically not possible" "$NEXT"
fi

if ! commandExists 'nvm' && ! commandExists 'node'; then
  print_log "$ERROR" "'Node.js' not found. Please install it or install 'nvm'." "$END"
  exit 1
fi

# This SHOULD never happen
if ! commandExists 'nvm' && ! commandExists 'npm'; then
  print_log "$ERROR" "'npm' not found. Please install it or install 'nvm'" "$END"
  exit 1
fi

if ! commandExists 'node' && ! commandExists 'npm' && commandExists 'nvm'; then
  print_log "$INFO" "Installing 'Node.JS' and 'npm'." "$NEXT"
  nvm install --latest-npm node && sync
fi

if ! commandExists 'node' && commandExists 'npm' && commandExists 'nvm'; then
  print_log "$INFO" "Installing 'Node.JS'." "$NEXT"
  nvm install node && sync
fi

# This SHOULD never happen
if commandExists 'node' && ! commandExists 'npm' && commandExists 'nvm'; then
  print_log "$INFO" "Installing 'npm'." "$NEXT"
  nvm install install-latest-npm && sync
fi

if ! [ -d "$APPSPATH" ]; then
  print_log "$INFO" "Creating '$APPSPATH' folder." "$NEXT"
  mkdir -p "$APPSPATH" && sync
fi

if ! [ -d "$HOMEPATH/.local/bin" ]; then
  print_log "$INFO" "Creating '$HOMEPATH/.local/bin' folder." "$NEXT"
  mkdir -p "$HOMEPATH/.local/bin" && sync
fi

if [ -d "$LSPROOTPATH" ]; then
  print_log "$INFO" "Updating LSP repo at '$LSPROOTPATH' folder." "$NEXT"
  cd "$LSPROOTPATH" && git fetch && git pull && sync
fi

if ! [ -d "$LSPROOTPATH" ]; then
  print_log "$INFO" "Cloning LSP repo to '$LSPROOTPATH' folder." "$NEXT"
  git clone --depth=1 "$GITREPO" "$LSPROOTPATH" && sync
fi

if [ -d "$LSPROOTPATH" ]; then
  cd $LSPROOTPATH
fi

print_log "$INFO" "Installing 'yarn' and '@vscode/vsce'." "$NEXT"
npm install -g yarn @vscode/vsce && sync

print_log "$INFO" "Running 'npm audit fix'." "$NEXT"
npm audit fix && sync

print_log "$INFO" "Running 'yarn install'." "$NEXT"
yarn install && sync

print_log "$INFO" "Running 'vsce package'." "$NEXT"
vsce package && sync

print_log "$INFO" "Uninstalling 'yarn' and '@vscode/vsce'." "$NEXT"
npm uninstall -g yarn @vscode/vsce && sync

if [ ${BACKEDUPNPM,,} = "y" ]; then
  if [ -f "$HOMEPATH/.npmrc.old" ]; then
    if [ -f "$HOMEPATH/.npmrc" ]; then
      rm "$HOMEPATH/.npmrc" && sync
    fi
    print_log "$INFO" "Restoring '$HOMEPATH/.npmrc' from backup." "$NEXT"
    mv "$HOMEPATH/.npmrc.old" "$HOMEPATH/.npmrc" && sync
  fi
fi

if [ -f "$HOMEPATH/.local/bin/nwscript_ls" ]; then
  print_log "$INFO" "Backing up '$HOMEPATH/.local/bin/nwscript_ls'" "$NEXT"
  mv "$HOMEPATH/.local/bin/nwscript_ls" "$HOMEPATH/.local/bin/nwscript_ls.old" && sync
fi

if ! [ -f "$HOMEPATH/.local/bin/nwscript_ls" ]; then
  print_log "$INFO" "Creating '$HOMEPATH/.local/bin/nwscript_ls'" "$NEXT"
  touch "$HOMEPATH/.local/bin/nwscript_ls" && sync
  printf "#!/usr/bin/env bash\n" | tee "$HOMEPATH/.local/bin/nwscript_ls" && sync
  if ! [ "$NWN_LSP" = "" ]; then
    printf "node \$NWN_LSP --stdio" | tee -a "$HOMEPATH/.local/bin/nwscript_ls" && sync
  else
    printf "node %s --stdio" "$LSPPATH" | tee -a "$HOMEPATH/.local/bin/nwscript_ls" && sync
  fi
fi

print_log "$SUCCESS" "LSP built." "$END"
exit 0
