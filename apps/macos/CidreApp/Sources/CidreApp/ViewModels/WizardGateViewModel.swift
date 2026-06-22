import Foundation

final class WizardGateViewModel: ObservableObject {
    @Published var decision: WizardGateState?

    func evaluate(from: WizardStage, to: WizardStage, repositoryPath: String) {
        decision = WizardGateService.shared.evaluate(from: from, to: to, repositoryPath: repositoryPath)
    }
}
