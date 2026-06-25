import Foundation

struct CommandResult: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let phase: String?
    let stage: String?
    let exitCode: Int
    let warnings: [String]?
    let errors: [CommandError]?
    let artifacts: [String]?
    let nextActions: [NextAction]?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary, phase, stage
        case exitCode = "exit_code"
        case warnings, errors, artifacts
        case nextActions = "next_actions"
    }
}

struct CommandError: Codable {
    let code: String
    let message: String
}

struct NextAction: Codable {
    let label: String
    let command: String
}
