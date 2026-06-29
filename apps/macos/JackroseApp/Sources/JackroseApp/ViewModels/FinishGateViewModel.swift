import Foundation

final class FinishGateViewModel: ObservableObject {
    @Published var gateState: FinishGateState?

    func load(repositoryPath: String) {
        gateState = FinishGateService.shared.evaluate(repositoryPath: repositoryPath)
    }
}
