import SwiftUI

final class UninstallWizardViewModel: ObservableObject {
    @Published var stages: [WizardStage] = WizardEngine.shared.stages(for: .uninstall)
    @Published var currentIndex = 0
    @Published var state: WizardState = .initial(mode: .uninstall)
    @Published var lastExecution: CommandExecution?
    @Published var isRunning = false
    @Published var confirmationText = ""

    func load(repositoryPath: String) {
        state = WizardStateStore.shared.load(repositoryPath: repositoryPath, mode: .uninstall)
        if let found = stages.firstIndex(of: state.stage) {
            currentIndex = found
        }
    }

    func advance(repositoryPath: String) {
        guard currentIndex + 1 < stages.count else { return }
        currentIndex += 1
        state.stage = stages[currentIndex]
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
    }

    func goBack(repositoryPath: String) {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        state.stage = stages[currentIndex]
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
    }

    func operationForCurrentStage() -> WizardOperation? {
        WizardEngine.shared.operations(for: .uninstall).first { $0.stage == stages[currentIndex] }
    }

    func canRunCurrentOperation() -> Bool {
        stages[currentIndex] != .uninstallConfirmation || confirmationText == "I understand this will remove Jackrose from this Mac."
    }

    func runCurrent(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        guard let operation = operationForCurrentStage(), canRunCurrentOperation() else { return }
        isRunning = true
        let start = Date()
        let execution = WizardOperationRunner.shared.run(operation: operation, repositoryPath: repositoryPath, isMockMode: isMockMode)
        lastExecution = execution
        state.status = execution.status
        state.stage = stages[currentIndex]
        state.lastOperation = operation.id
        WizardStateStore.shared.save(state, repositoryPath: repositoryPath)
        logStore.append(command: execution.command, arguments: execution.arguments, exitCode: execution.exitCode ?? 0, status: execution.status, summary: execution.parsedResult?.summary ?? execution.stdout, duration: Date().timeIntervalSince(start))
        isRunning = false
    }
}
