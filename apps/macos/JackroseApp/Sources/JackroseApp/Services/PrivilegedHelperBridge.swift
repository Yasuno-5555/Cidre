import Foundation

final class PrivilegedHelperBridge {
    static let shared = PrivilegedHelperBridge()
    private init() {}

    func statusCommand() -> String {
        "scripts/jackrose-app-helper-status --json"
    }
}
