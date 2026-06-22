import Foundation

final class SigningReadinessChecker {
    static let shared = SigningReadinessChecker()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-signing-check --json"
    }
}
