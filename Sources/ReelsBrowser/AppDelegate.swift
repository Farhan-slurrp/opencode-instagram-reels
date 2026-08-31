import AppKit
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
    private var window: BrowserPanel!
    private var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        createWindow(near: WindowPositioner.frontmostWindowFrame())
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            if window == nil {
                createWindow(near: WindowPositioner.frontmostWindowFrame())
            } else {
                window.makeKeyAndOrderFront(nil)
            }
            NSApp.activate(ignoringOtherApps: true)
        }
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else { return }
        webView?.load(URLRequest(url: url))
        window?.makeKeyAndOrderFront(nil)
    }

    private func createWindow(near hostFrame: CGRect?) {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: ReelsConfiguration.url))

        window = BrowserPanel(
            contentRect: NSRect(x: 0, y: 0, width: ReelsConfiguration.panelWidth, height: 900),
            styleMask: [.borderless, .resizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = makeContentView()
        window.isMovableByWindowBackground = true
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.setFrameAutosaveName(ReelsConfiguration.frameAutosaveName)

        if !window.setFrameUsingName(ReelsConfiguration.frameAutosaveName) {
            WindowPositioner.place(window, beside: hostFrame)
        }

        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeContentView() -> NSView {
        let container = NSView()
        let dragView = WindowDragView()
        let closeButton = NSButton(title: "×", target: self, action: #selector(closePanel))

        dragView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.bezelStyle = .texturedRounded
        closeButton.isBordered = false
        closeButton.font = .systemFont(ofSize: 18, weight: .medium)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(dragView)
        container.addSubview(webView)
        container.addSubview(closeButton)

        NSLayoutConstraint.activate([
            dragView.topAnchor.constraint(equalTo: container.topAnchor),
            dragView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dragView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dragView.heightAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: dragView.topAnchor, constant: 3),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            webView.topAnchor.constraint(equalTo: dragView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    @objc private func closePanel() {
        window.orderOut(nil)
    }
}
