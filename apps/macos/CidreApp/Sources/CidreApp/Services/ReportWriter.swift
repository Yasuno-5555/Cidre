import Foundation

final class ReportWriter {
    static let shared = ReportWriter()
    private init() {}

    func command(for mode: WizardMode) -> String {
        "scripts/cidre-app-wizard-report --mode \(mode.rawValue) --json"
    }
}
