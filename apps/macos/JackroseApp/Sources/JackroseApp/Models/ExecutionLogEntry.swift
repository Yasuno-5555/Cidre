import Foundation

struct ExecutionLogEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let commandLine: String
    let status: String
    let exitCode: Int
    let summary: String
    let duration: TimeInterval
}
