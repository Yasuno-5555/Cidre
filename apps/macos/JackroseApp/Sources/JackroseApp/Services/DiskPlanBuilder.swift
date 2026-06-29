import Foundation

final class DiskPlanBuilder {
    static let shared = DiskPlanBuilder()
    private init() {}

    func command(for mode: WizardMode) -> String {
        "scripts/jackrose-app-disk-plan --mode \(mode.rawValue) --json"
    }
}
