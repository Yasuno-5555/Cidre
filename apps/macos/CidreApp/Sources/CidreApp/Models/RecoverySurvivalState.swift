import Foundation

struct RecoverySurvivalState: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let errors: [CommandError]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary, errors
    }
}
