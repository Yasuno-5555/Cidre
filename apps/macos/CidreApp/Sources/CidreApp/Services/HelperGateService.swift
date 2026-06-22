import Foundation

final class HelperGateService {
    static let shared = HelperGateService()
    private init() {}

    func evaluate(operation: String, repositoryPath: String) -> GateDecision? {
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-helper-gate",
            arguments: ["--operation", operation, "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(GateDecision.self, from: data)
    }
}
