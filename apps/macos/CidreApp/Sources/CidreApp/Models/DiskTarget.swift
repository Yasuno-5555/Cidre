import Foundation

struct DiskTarget: Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let protected: Bool
    let mountPoint: String?
}
