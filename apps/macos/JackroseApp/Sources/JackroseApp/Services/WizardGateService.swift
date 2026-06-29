import Foundation

final class WizardGateService {
    static let shared = WizardGateService()
    private init() {}

    func evaluate(from: WizardStage, to: WizardStage, repositoryPath: String) -> WizardGateState? {
        let result = LiveCommandRunner.shared.run(
            "scripts/jackrose-app-wizard-gate",
            arguments: ["--from", from.rawValue, "--to", to.rawValue, "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(WizardGateState.self, from: data)
    }
}
