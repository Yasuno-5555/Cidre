import Foundation

struct WizardOperation: Codable, Identifiable {
    let id: String
    let title: String
    let category: String
    let stage: WizardStage
    let privilegeLevel: PrivilegeRequirement
    let destructive: Bool
    let requiresConfirmation: Bool
    let requiresHelper: Bool
    let dryRunAvailable: Bool
    let command: String
    let rollbackHint: String?

    enum CodingKeys: String, CodingKey {
        case id, title, category, stage, destructive, command
        case privilegeLevel = "privilege_level"
        case requiresConfirmation = "requires_confirmation"
        case requiresHelper = "requires_helper"
        case dryRunAvailable = "dry_run_available"
        case rollbackHint = "rollback_hint"
    }
}
