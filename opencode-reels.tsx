/** @jsxImportSource @opentui/solid */
import type { TuiPlugin, TuiPluginModule } from "@opencode-ai/plugin/tui"
import { TextAttributes } from "@opentui/core"
import { spawn } from "node:child_process"
import { homedir } from "node:os"
import { join } from "node:path"

const command = process.env.OPENCODE_REELS_BROWSER ?? join(homedir(), ".config/opencode/bin/opencode-reels-browser")

function launchBrowser(): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = spawn(command, [], { detached: true, stdio: "ignore" })
    child.once("error", reject)
    child.once("spawn", () => {
      child.unref()
      resolve()
    })
  })
}

const tui: TuiPlugin = async (api) => {
  api.slots.register({
    order: 280,
    slots: {
      sidebar_content() {
        const theme = () => api.theme.current

        return (
          <box>
            <text fg={theme().text} attributes={TextAttributes.BOLD}>
              Reels
            </text>
            <text
              fg={theme().accent}
              onMouseDown={() => {
                void launchBrowser().catch(() => {
                  api.ui.toast({
                    variant: "error",
                    message: "Reels browser is not installed. Run ./install.sh first.",
                  })
                })
              }}
            >
              [Open Instagram Reels]
            </text>
            <text fg={theme().textMuted}>native browser window</text>
          </box>
        )
      },
    },
  })
}

const plugin: TuiPluginModule & { id: string } = {
  id: "opencode-instagram-reels",
  tui,
}

export default plugin
