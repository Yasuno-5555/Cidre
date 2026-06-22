import Foundation

struct RuntimeValidationState: Codable {
    let schemaVersion: Int
    let stage: String?
    let statuses: [String: String]
    let summary: String?
    let reason: String?
    let exitCode: Int?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case stage
        case statuses
        case summary
        case reason
        case exitCode = "exit_code"
        case updatedAt = "updated_at"
    }

    func status(for key: String) -> String {
        statuses[key] ?? "pending"
    }
}
