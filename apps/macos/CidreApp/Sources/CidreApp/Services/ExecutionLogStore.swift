import Foundation

class ExecutionLogStore: ObservableObject {
    @Published var logs: [ExecutionLogEntry] = []
    
    func append(command: String, arguments: [String], exitCode: Int, status: String, summary: String, duration: TimeInterval) {
        let entry = ExecutionLogEntry(
            id: UUID(),
            timestamp: Date(),
            commandLine: "\(command) \(arguments.joined(separator: " "))",
            status: status,
            exitCode: exitCode,
            summary: summary,
            duration: duration
        )
        logs.insert(entry, at: 0)
    }
    
    func clear() {
        logs.removeAll()
    }
}
