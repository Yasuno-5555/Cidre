import Foundation

final class UninstallPlanService {
    static let shared = UninstallPlanService()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-wizard-plan --mode uninstall --json"
    }
}
