import Foundation

final class ArtifactManager {
    static let shared = ArtifactManager()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-wizard-artifacts --json"
    }
}
