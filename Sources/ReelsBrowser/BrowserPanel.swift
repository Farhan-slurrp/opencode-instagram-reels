import AppKit

final class BrowserPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

final class WindowDragView: NSView {
    override var mouseDownCanMoveWindow: Bool { true }
}
