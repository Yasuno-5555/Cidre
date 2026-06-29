import Foundation

final class SigningReadinessChecker {
    static let shared = SigningReadinessChecker()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-signing-check --json"
    }
}
