import Foundation

enum PrivilegeRequirement: String, Codable {
    case none
    case user
    case admin
    case helper
    case external
}
