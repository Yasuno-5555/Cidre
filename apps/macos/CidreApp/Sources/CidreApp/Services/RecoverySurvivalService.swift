import Foundation

final class RecoverySurvivalService {
    static let shared = RecoverySurvivalService()
    private init() {}

    func evaluate(repositoryPath: String) -> RecoverySurvivalState? {
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-recovery-survival-check",
            arguments: ["--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(RecoverySurvivalState.self, from: data)
    }
}
