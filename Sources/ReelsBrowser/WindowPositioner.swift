import AppKit
import CoreGraphics

enum WindowPositioner {
    static func place(_ window: NSWindow, beside hostFrame: CGRect?) {
        guard let screen = NSScreen.main else { return }

        let visibleFrame = screen.visibleFrame
        let height = min(hostFrame?.height ?? visibleFrame.height, visibleFrame.height)
        let y = max(
            visibleFrame.minY,
            min(hostFrame?.minY ?? visibleFrame.minY, visibleFrame.maxY - height)
        )
        let preferredX = (hostFrame?.maxX ?? visibleFrame.maxX - ReelsConfiguration.panelWidth) + 8
        let x = min(preferredX, visibleFrame.maxX - ReelsConfiguration.panelWidth)

        window.setContentSize(NSSize(width: ReelsConfiguration.panelWidth, height: height))
        window.setFrameOrigin(NSPoint(x: x, y: y))
    }

    static func frontmostWindowFrame() -> CGRect? {
        let currentPID = NSRunningApplication.current.processIdentifier
        guard let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID)
            as? [[String: Any]] else { return nil }

        for info in windows {
            guard let ownerPID = info[kCGWindowOwnerPID as String] as? Int,
                  ownerPID != Int(currentPID),
                  let layer = info[kCGWindowLayer as String] as? Int,
                  layer == 0,
                  let bounds = info[kCGWindowBounds as String] as? [String: Any],
                  let frame = CGRect(dictionaryRepresentation: bounds as CFDictionary),
                  frame.width > 500,
                  frame.height > 300 else { continue }
            return frame
        }
        return nil
    }
}
