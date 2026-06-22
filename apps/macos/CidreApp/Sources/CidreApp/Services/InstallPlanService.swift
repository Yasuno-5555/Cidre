import Foundation

final class InstallPlanService {
    static let shared = InstallPlanService()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-wizard-plan --mode install --json"
    }
}
