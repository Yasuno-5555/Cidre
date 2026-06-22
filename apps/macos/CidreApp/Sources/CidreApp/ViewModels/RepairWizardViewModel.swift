import SwiftUI

final class RepairWizardViewModel: ObservableObject {
    @Published var stages: [WizardStage] = WizardEngine.shared.stages(for: .repair)
    @Published var currentIndex = 0
    @Published var state: WizardState = .initial(mode: .repair)
    @Published var lastExecution: CommandExecution?

    func load(repositoryPath: String) {
        state = WizardStateStore.shared.load(repositoryPath: repositoryPath, mode: .repair)
        if let found = stages.firstIndex(of: state.stage) {
            currentIndex = found
        }
    }

    func runCurrent(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        guard let operation = WizardEngine.shared.operations(for: .repair).first(where: { $0.stage == stages[currentIndex] }) else { return }
        let execution = WizardOperationRunner.shared.run(operation: operation, repositoryPath: repositoryPath, isMockMode: isMockMode)
        lastExecution = execution
        state.status = execution.status
        state.lastOperation = operation.id
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
        logStore.append(command: execution.command, arguments: execution.arguments, exitCode: execution.exitCode ?? 0, status: execution.status, summary: execution.parsedResult?.summary ?? execution.stdout, duration: 0)
    }

    func advance(repositoryPath: String) {
        guard currentIndex + 1 < stages.count else { return }
        currentIndex += 1
        state.stage = stages[currentIndex]
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
    }
}
