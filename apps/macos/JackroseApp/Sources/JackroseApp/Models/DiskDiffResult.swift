import Foundation

struct DiskDiffState: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let blockedReasons: [String]?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary
        case blockedReasons = "blocked_reasons"
    }
}
