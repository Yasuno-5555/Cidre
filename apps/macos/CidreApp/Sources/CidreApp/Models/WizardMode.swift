import Foundation

enum WizardMode: String, Codable, CaseIterable, Identifiable {
    case install
    case uninstall
    case repair

    var id: String { rawValue }

    var title: String {
        switch self {
        case .install:
            return "Setup Wizard"
        case .uninstall:
            return "Uninstall Wizard"
        case .repair:
            return "Repair Wizard"
        }
    }
}
