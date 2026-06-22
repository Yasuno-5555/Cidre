import Foundation

final class PackagingReadinessChecker {
    static let shared = PackagingReadinessChecker()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-package-check --json"
    }
}
