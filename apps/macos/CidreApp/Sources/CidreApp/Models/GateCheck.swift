import Foundation

struct GateCheck: Codable, Identifiable {
    let id: String
    let status: String
    let reason: String?
}
