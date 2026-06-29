import Foundation

final class SeedGeneratorService {
    static let shared = SeedGeneratorService()
    private init() {}

    func command() -> String {
        "scripts/jackrose-app-wizard-run --operation seed-generate --json"
    }
}
