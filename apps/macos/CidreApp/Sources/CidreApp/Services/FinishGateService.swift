import Foundation

final class FinishGateService {
    static let shared = FinishGateService()
    private init() {}

    func evaluate(repositoryPath: String) -> FinishGateState? {
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-finish-gate",
            arguments: ["--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(FinishGateState.self, from: data)
    }
}
