import Foundation

struct HelperProtocol: Codable {
    let schemaVersion: Int
    let operation: String
    let target: String?
    let dryRun: Bool
    let confirmationToken: String?
    let planID: String?
    let auditLogPath: String?
    let arguments: [String]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case operation, target
        case dryRun = "dry_run"
        case confirmationToken = "confirmation_token"
        case planID = "plan_id"
        case auditLogPath = "audit_log_path"
        case arguments
    }
}
