#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BIN_DIR="${HOME}/.config/opencode/bin"
PLUGIN_DIR="${HOME}/.config/opencode/plugins"
TUI_CONFIG="${HOME}/.config/opencode/tui.jsonc"
APP_INSTALL_DIR="${HOME}/Applications/Instagram Reels.app"

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' "This companion currently supports macOS only." >&2
  exit 1
fi

mkdir -p "$BIN_DIR" "$PLUGIN_DIR"
"$ROOT_DIR/scripts/build-app.sh"
mkdir -p "$(dirname -- "$APP_INSTALL_DIR")"
rm -rf "$APP_INSTALL_DIR"
cp -R "$ROOT_DIR/dist/Instagram Reels.app" "$APP_INSTALL_DIR"
printf '%s\n' '#!/bin/sh' "exec /usr/bin/open -a \"$APP_INSTALL_DIR\"" > "$BIN_DIR/opencode-reels-browser"
chmod 755 "$BIN_DIR/opencode-reels-browser"
cp "$ROOT_DIR/opencode-reels.tsx" "$PLUGIN_DIR/opencode-instagram-reels.tsx"

if [ ! -f "$TUI_CONFIG" ]; then
  mkdir -p "$(dirname -- "$TUI_CONFIG")"
  printf '%s\n' '{' '  "$schema": "https://opencode.ai/tui.json",' '  "plugin": []' '}' > "$TUI_CONFIG"
fi

node - "$TUI_CONFIG" "$PLUGIN_DIR/opencode-instagram-reels.tsx" <<'NODE'
const fs = require("node:fs")
const [configPath, pluginPath] = process.argv.slice(2)
const source = fs.readFileSync(configPath, "utf8")
if (source.includes(pluginPath)) process.exit(0)
const pluginArray = /("plugin"\s*:\s*\[)/.exec(source)
if (!pluginArray) throw new Error(`No plugin array found in ${configPath}`)
const entry = `\n    ${JSON.stringify(pluginPath)},`
const updated = source.slice(0, pluginArray.index + pluginArray[0].length)
  + entry
  + source.slice(pluginArray.index + pluginArray[0].length)
fs.writeFileSync(configPath, updated)
NODE

printf '%s\n' "Installed opencode-reels-browser to $BIN_DIR"
printf '%s\n' "Installed the TUI plugin to $PLUGIN_DIR"
printf '%s\n' "Registered the plugin in $TUI_CONFIG"
