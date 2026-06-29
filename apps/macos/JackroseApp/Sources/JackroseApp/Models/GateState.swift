import Foundation

struct GateState: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let checks: [GateCheck]
    let allowedActions: [String]?
    let blockedActions: [String]?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary, checks
        case allowedActions = "allowed_actions"
        case blockedActions = "blocked_actions"
    }
}
