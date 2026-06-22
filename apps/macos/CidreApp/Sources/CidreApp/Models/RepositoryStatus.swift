import Foundation

struct RepositoryStatus: Codable {
    let path: String
    let exists: Bool
    let hasInterfaceDirectory: Bool
    let hasScriptsDirectory: Bool
    let hasCommandManifest: Bool
    let hasAppActions: Bool
    let valid: Bool
    let warnings: [String]
    let errors: [String]
}
