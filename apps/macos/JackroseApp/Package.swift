// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "JackroseApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "JackroseApp", targets: ["JackroseApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "JackroseApp",
            dependencies: [],
            path: "Sources/JackroseApp"
        )
    ]
)
