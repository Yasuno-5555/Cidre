import Foundation

final class RestoreGuideGenerator {
    static let shared = RestoreGuideGenerator()
    private init() {}

    func command() -> String {
        "scripts/cidre-macos-restore-report"
    }
}
