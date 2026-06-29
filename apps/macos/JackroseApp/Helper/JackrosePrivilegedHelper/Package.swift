// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "JackrosePrivilegedHelper",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "JackrosePrivilegedHelper", targets: ["JackrosePrivilegedHelper"])
    ],
    targets: [
        .executableTarget(
            name: "JackrosePrivilegedHelper",
            path: "Sources/JackrosePrivilegedHelper"
        )
    ]
)
