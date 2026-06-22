// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CidreApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "CidreApp", targets: ["CidreApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CidreApp",
            dependencies: [],
            path: "Sources/CidreApp"
        )
    ]
)
