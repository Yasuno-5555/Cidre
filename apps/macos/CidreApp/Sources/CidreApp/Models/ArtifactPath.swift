import Foundation

struct ArtifactPath: Codable, Identifiable {
    var id: String { role }
    let role: String
    let path: String
    let type: String
    let exists: Bool
}
