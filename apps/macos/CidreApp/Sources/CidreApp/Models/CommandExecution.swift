import Foundation

struct CommandExecution: Identifiable, Codable {
    let id: UUID
    let command: String
    let arguments: [String]
    let workingDirectory: String
    let startedAt: Date
    var finishedAt: Date?
    var exitCode: Int?
    var status: String
    var stdout: String
    var stderr: String
    var parsedResult: CommandResult?
}
