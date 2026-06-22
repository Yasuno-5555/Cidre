import Foundation

final class RollbackReportCheckService {
    static let shared = RollbackReportCheckService()
    private init() {}

    func evaluate(repositoryPath: String) -> GateDecision? {
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-rollback-report-check",
            arguments: ["--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(GateDecision.self, from: data)
    }
}
