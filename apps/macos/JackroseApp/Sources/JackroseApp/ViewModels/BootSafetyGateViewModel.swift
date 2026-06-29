import Foundation

final class BootSafetyGateViewModel: ObservableObject {
    @Published var gateState: GateState?

    func load(repositoryPath: String) {
        gateState = GateEvaluationService.shared.evaluate(scope: "install", repositoryPath: repositoryPath)
    }
}
