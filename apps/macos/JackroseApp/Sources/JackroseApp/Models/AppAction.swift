import Foundation

struct AppAction: Codable, Identifiable {
    let id: String
    let title: String
    let category: String
    let command: String
    let safeToRun: Bool
    let requiresPrivilege: Bool
    let destructive: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, category, command
        case safeToRun = "safe_to_run"
        case requiresPrivilege = "requires_privilege"
        case destructive
    }
}
