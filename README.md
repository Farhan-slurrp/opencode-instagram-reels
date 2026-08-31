# OpenCode Instagram Reels

A macOS companion browser launched from the OpenCode TUI sidebar. It opens
Instagram Reels in an attached floating `WKWebView` panel and keeps login
cookies between launches.

![OpenCode Instagram Reels](image-1.png)

The panel is a separate native window positioned beside OpenCode. The terminal
TUI cannot host an interactive WebKit view inside its character buffer.

## Requirements

- macOS 13 or newer
- Xcode Command Line Tools
- OpenCode 1.17 or newer with TUI plugin support

## Install

From a checkout of this repository:

```sh
./install.sh
```

The installer:

- builds and signs `Instagram Reels.app`
- installs the app to `~/Applications`
- installs an app launcher to `~/.config/opencode/bin`
- installs the TUI plugin to `~/.config/opencode/plugins`
- registers the plugin in `~/.config/opencode/tui.jsonc`

Fully quit and restart OpenCode, open a session, and click **Open Instagram
Reels** in the sidebar. The panel opens beside the terminal; the first launch
may require signing in to Instagram.

## Build An App

Build a signed application bundle with:

```sh
./scripts/build-app.sh
```

The default signature is ad hoc and is suitable for local use. For distribution
with a Developer ID certificate, set `CODESIGN_IDENTITY`:

```sh
CODESIGN_IDENTITY="Developer ID Application: Example, Inc. (TEAMID)" \
  ./scripts/build-app.sh
```

## Development

Run the companion directly:

```sh
swift run opencode-reels-browser
```

Build and install the attached panel:

```sh
./install.sh
```

Build the TUI plugin independently:

```sh
bun build opencode-reels.tsx \
  --target bun \
  --external "@opencode-ai/plugin/tui" \
  --external "@opentui/core" \
  --external "@opentui/solid" \
  --outdir /tmp/opencode-reels-plugin
```

## Project Layout

- `Sources/ReelsBrowser/AppDelegate.swift`: browser lifecycle and view wiring
- `Sources/ReelsBrowser/BrowserPanel.swift`: keyable borderless panel behavior
- `Sources/ReelsBrowser/WindowPositioner.swift`: screen and terminal placement
- `Sources/ReelsBrowser/ReelsConfiguration.swift`: shared app configuration
- `Sources/ReelsBrowser/main.swift`: application bootstrap
- `opencode-reels.tsx`: OpenCode sidebar plugin
- `install.sh`: local installation and TUI registration
- `scripts/build-app.sh`: `.app` packaging and signing

## License

MIT. See [LICENSE](LICENSE).
