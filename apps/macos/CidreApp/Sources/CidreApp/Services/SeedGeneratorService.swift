import Foundation

final class SeedGeneratorService {
    static let shared = SeedGeneratorService()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-wizard-run --operation seed-generate --json"
    }
}
