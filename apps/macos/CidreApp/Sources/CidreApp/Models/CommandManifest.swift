import Foundation

struct CommandManifest: Codable {
    let schemaVersion: Int
    let commands: [CommandInfo]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case commands
    }
}

struct CommandInfo: Codable, Identifiable {
    var id: String { name }
    let name: String
    let path: String
    let category: String
    let supportsJSON: Bool
    let supportsPlain: Bool
    let supportsNonInteractive: Bool
    let supportsDryRun: Bool
    let destructiveCapable: Bool
    let requiresRoot: Bool
    let requiresMacOS: Bool
    let requiresLinux: Bool

    enum CodingKeys: String, CodingKey {
        case name, path, category
        case supportsJSON = "supports_json"
        case supportsPlain = "supports_plain"
        case supportsNonInteractive = "supports_noninteractive"
        case supportsDryRun = "supports_dry_run"
        case destructiveCapable = "destructive_capable"
        case requiresRoot = "requires_root"
        case requiresMacOS = "requires_macos"
        case requiresLinux = "requires_linux"
    }
}
