import Foundation

final class RestoreGuideGenerator {
    static let shared = RestoreGuideGenerator()
    private init() {}

    func command() -> String {
        "scripts/jackrose-macos-restore-report"
    }
}
