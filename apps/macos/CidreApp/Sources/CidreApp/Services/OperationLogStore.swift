import Foundation

final class OperationLogStore: ObservableObject {
    @Published var entries: [WizardOperationResult] = []

    func append(_ result: WizardOperationResult) {
        entries.insert(result, at: 0)
    }

    func clear() {
        entries.removeAll()
    }
}
