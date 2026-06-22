import Foundation

struct HelperResponse: Codable {
    let schemaVersion = 1
    let command = "cidre-privileged-helper"
    let status: String
    let summary: String
    let phase = "disk"
    let stage = "execute"
    let exitCode: Int32
    let warnings: [String]
    let errors: [[String: String]]
    let executedCommand: [String]
    let stdout: String
    let stderr: String

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary, phase, stage
        case exitCode = "exit_code"
        case warnings, errors
        case executedCommand = "executed_command"
        case stdout, stderr
    }
}

guard CommandLine.arguments.count == 2 else {
    FileHandle.standardError.write(Data("Usage: CidrePrivilegedHelper <request.json>\n".utf8))
    exit(2)
}

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))
    let request = try JSONDecoder().decode(HelperProtocol.self, from: data)
    let result = DiskOperationService.execute(request)
    HelperAuditLog.record(for: request, result: result)
    let response = HelperResponse(
        status: result.status,
        summary: result.summary,
        exitCode: result.exitCode,
        warnings: [],
        errors: result.status == "pass" ? [] : [["code": result.status == "blocked" ? "safety-check-failed" : "diskutil-failed", "message": result.summary]],
        executedCommand: result.command,
        stdout: result.stdout,
        stderr: result.stderr
    )
    let encoded = try JSONEncoder().encode(response)
    FileHandle.standardOutput.write(encoded)
    FileHandle.standardOutput.write(Data("\n".utf8))
    exit(result.exitCode)
} catch {
    FileHandle.standardError.write(Data("Invalid helper request: \(error.localizedDescription)\n".utf8))
    exit(2)
}
