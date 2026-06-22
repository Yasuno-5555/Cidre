import Foundation

struct InstallPlan: Codable {
    let schemaVersion: Int
    let mode: String
    let stages: [String]
    let helperRequiredOperations: [String]
    let blockedOperations: [String]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case mode, stages
        case helperRequiredOperations = "helper_required_operations"
        case blockedOperations = "blocked_operations"
    }
}
