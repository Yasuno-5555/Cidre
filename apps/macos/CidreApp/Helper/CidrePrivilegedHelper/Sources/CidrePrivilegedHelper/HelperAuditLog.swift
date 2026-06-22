import Foundation

enum HelperAuditLog {
    static func record(for request: HelperProtocol, result: DiskOperationService.Result) {
        guard let path = request.auditLogPath else { return }
        let line = "\(ISO8601DateFormatter().string(from: Date())) plan=\(request.planID ?? "none") operation=\(request.operation) target=\(request.target ?? "none") dryRun=\(request.dryRun) status=\(result.status) exit=\(result.exitCode)\n"
        let url = URL(fileURLWithPath: path)
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: Data())
        }
        guard let handle = try? FileHandle(forWritingTo: url) else { return }
        defer { try? handle.close() }
        _ = try? handle.seekToEnd()
        try? handle.write(contentsOf: Data(line.utf8))
    }
}
