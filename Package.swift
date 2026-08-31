// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "opencode-instagram-reels",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "opencode-reels-browser", targets: ["ReelsBrowser"]),
    ],
    targets: [
        .executableTarget(name: "ReelsBrowser"),
    ]
)
