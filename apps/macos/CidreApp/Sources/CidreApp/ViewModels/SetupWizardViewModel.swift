import SwiftUI

final class SetupWizardViewModel: ObservableObject {
    @Published var stages: [WizardStage] = WizardEngine.shared.stages(for: .install)
    @Published var currentIndex = 0
    @Published var state: WizardState = .initial(mode: .install)
    @Published var lastExecution: CommandExecution?
    @Published var isRunning = false

    func load(repositoryPath: String) {
        state = WizardStateStore.shared.load(repositoryPath: repositoryPath, mode: .install)
        if let found = stages.firstIndex(of: state.stage) {
            currentIndex = found
        }
    }

    func advance(repositoryPath: String) {
        guard currentIndex + 1 < stages.count else { return }
        currentIndex += 1
        state.stage = stages[currentIndex]
        state.nextAction = stages.indices.contains(currentIndex + 1) ? stages[currentIndex + 1].title : nil
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
    }

    func goBack(repositoryPath: String) {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        state.stage = stages[currentIndex]
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
    }

    func operationForCurrentStage() -> WizardOperation? {
        WizardEngine.shared.operations(for: .install).first { $0.stage == stages[currentIndex] }
    }

    func runCurrent(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        guard let operation = operationForCurrentStage() else { return }
        isRunning = true
        state.status = "running"
        state.lastOperation = operation.id
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
        let start = Date()
        let execution = WizardOperationRunner.shared.run(operation: operation, repositoryPath: repositoryPath, isMockMode: isMockMode)
        lastExecution = execution
        state.status = execution.status
        state.helperRequired = operation.requiresHelper
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
        logStore.append(command: execution.command, arguments: execution.arguments, exitCode: execution.exitCode ?? 0, status: execution.status, summary: execution.parsedResult?.summary ?? execution.stdout, duration: Date().timeIntervalSince(start))
        isRunning = false
    }
}
