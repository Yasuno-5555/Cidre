import Foundation

final class PackagingReadinessChecker {
    static let shared = PackagingReadinessChecker()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-package-check --json"
    }
}
