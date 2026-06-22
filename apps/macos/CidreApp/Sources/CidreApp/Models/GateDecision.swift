import Foundation

struct GateDecision: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let exitCode: Int

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary
        case exitCode = "exit_code"
    }
}
