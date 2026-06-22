import Foundation

class ReportLoader {
    static let shared = ReportLoader()
    
    private init() {}
    
    func loadReport(atPath path: String) -> String {
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            // Return a default mock preview if file not found
            if path.contains("install-report") {
                return "# Install Report (Mock)\n\nNo report file found at specified path. Please run installer first."
            } else if path.contains("uninstall-report") {
                return "# Uninstall Report (Mock)\n\nNo report file found at specified path. Please run uninstaller first."
            }
            return "# Report Preview\n\nUnable to read file at path: \(path)"
        }
        return content
    }
}
