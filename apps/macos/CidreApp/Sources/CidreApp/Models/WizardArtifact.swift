import Foundation

struct WizardArtifact: Codable, Identifiable {
    let id: UUID
    let title: String
    let path: String
    let kind: String

    init(id: UUID = UUID(), title: String, path: String, kind: String) {
        self.id = id
        self.title = title
        self.path = path
        self.kind = kind
    }
}
