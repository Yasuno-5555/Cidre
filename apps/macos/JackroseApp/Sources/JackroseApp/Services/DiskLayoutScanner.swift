import Foundation

final class DiskLayoutScanner {
    static let shared = DiskLayoutScanner()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-disk-scan --json"
    }
}
