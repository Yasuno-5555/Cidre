import Foundation

struct UninstallPlan: Codable {
    let schemaVersion: Int
    let mode: String
    let stages: [String]
    let exportRequired: Bool
    let blockedOperations: [String]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case mode, stages
        case exportRequired = "export_required"
        case blockedOperations = "blocked_operations"
    }
}
