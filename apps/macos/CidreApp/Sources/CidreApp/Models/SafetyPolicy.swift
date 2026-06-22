import Foundation

struct SafetyPolicy: Codable {
    let allowMockCommands: Bool
    let allowReadOnlyCommands: Bool
    let allowDestructiveCommands: Bool
    let allowRootCommands: Bool
    let blockedReasons: [String]
}
