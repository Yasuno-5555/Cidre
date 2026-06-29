import Foundation

final class UninstallPlanService {
    static let shared = UninstallPlanService()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-wizard-plan --mode uninstall --json"
    }
}
