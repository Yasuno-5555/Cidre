import Foundation

final class HelperInstallManager {
    static let shared = HelperInstallManager()
    private init() {}

    func checkCommand() -> String {
        "scripts/jackrose-app-helper-install-check --json"
    }
}
