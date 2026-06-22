import Foundation

struct WizardState: Codable {
    let schemaVersion: Int
    var mode: WizardMode
    var stage: WizardStage
    var status: String
    var terminalFree: Bool
    var helperRequired: Bool
    var lastOperation: String?
    var nextAction: String?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case mode, stage, status
        case terminalFree = "terminal_free"
        case helperRequired = "helper_required"
        case lastOperation = "last_operation"
        case nextAction = "next_action"
    }

    static func initial(mode: WizardMode) -> WizardState {
        WizardState(
            schemaVersion: 1,
            mode: mode,
            stage: mode == .install ? .welcome : (mode == .uninstall ? .uninstallWelcome : .repairOverview),
            status: "pending",
            terminalFree: true,
            helperRequired: false,
            lastOperation: nil,
            nextAction: nil
        )
    }
}
