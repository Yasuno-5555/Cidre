import Foundation

final class DiskLayoutScanner {
    static let shared = DiskLayoutScanner()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-disk-scan --json"
    }
}
