import Foundation

struct WizardOperationResult: Codable {
    let schemaVersion: Int
    let operation: String
    let status: String
    let summary: String
    let artifacts: [String]
    let blockedReason: String?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case operation, status, summary, artifacts
        case blockedReason = "blocked_reason"
    }
}
