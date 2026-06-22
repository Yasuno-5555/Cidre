import Foundation

final class ArtifactManager {
    static let shared = ArtifactManager()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-wizard-artifacts --json"
    }
}
