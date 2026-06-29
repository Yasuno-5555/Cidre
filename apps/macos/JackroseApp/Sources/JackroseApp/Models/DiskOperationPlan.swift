import Foundation

struct DiskOperationPlan: Codable {
    let schemaVersion: Int
    let mode: String
    let helperRequired: Bool
    let plannedOperations: [String]
    let blockedOperations: [String]
    let requiredConfirmation: String?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case mode
        case helperRequired = "helper_required"
        case plannedOperations = "planned_operations"
        case blockedOperations = "blocked_operations"
        case requiredConfirmation = "required_confirmation"
    }
}
