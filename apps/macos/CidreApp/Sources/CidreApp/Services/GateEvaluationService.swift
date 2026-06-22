import Foundation

final class GateEvaluationService {
    static let shared = GateEvaluationService()
    private init() {}

    func evaluate(scope: String, repositoryPath: String) -> GateState? {
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-gate-evaluate",
            arguments: ["--scope", scope, "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(GateState.self, from: data)
    }
}
