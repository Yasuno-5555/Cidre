import Foundation

final class PrivilegedHelperBridge {
    static let shared = PrivilegedHelperBridge()
    private init() {}

    func statusCommand() -> String {
        "scripts/cidre-app-helper-status --json"
    }
}
