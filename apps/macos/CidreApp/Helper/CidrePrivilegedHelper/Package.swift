// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CidrePrivilegedHelper",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "CidrePrivilegedHelper", targets: ["CidrePrivilegedHelper"])
    ],
    targets: [
        .executableTarget(
            name: "CidrePrivilegedHelper",
            path: "Sources/CidrePrivilegedHelper"
        )
    ]
)
