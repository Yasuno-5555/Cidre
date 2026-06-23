import SwiftUI

final class SetupWizardViewModel: ObservableObject {
    @Published var stages: [WizardStage] = WizardEngine.shared.stages(for: .install)
    @Published var currentIndex = 0
    @Published var state: WizardState = .initial(mode: .install)
    @Published var lastExecution: CommandExecution?
    @Published var isRunning = false
    @Published var gateDecision: WizardGateState?

    /// Owner credentials for bless/bputil operations. Held in memory only.
    @Published var ownerCredentials: OwnerCredentials?

    /// Boot policy state tracking
    @Published var bootPolicyVM = BootPolicyViewModel()

    /// Install target device (e.g. disk3s1), set during disk planning
    @Published var installTarget: String?

    func load(repositoryPath: String) {
        state = WizardStateStore.shared.load(repositoryPath: repositoryPath, mode: .install)
        if let found = stages.firstIndex(of: state.stage) {
            currentIndex = found
        }
    }

    func advance(repositoryPath: String) {
        guard currentIndex + 1 < stages.count else { return }
        let from = stages[currentIndex]
        let to = stages[currentIndex + 1]
        if let decision = WizardGateService.shared.evaluate(from: from, to: to, repositoryPath: repositoryPath),
           decision.status != "passed" {
            gateDecision = decision
            lastExecution = CommandExecution(
                id: UUID(),
                command: "scripts/cidre-app-wizard-gate",
                arguments: ["--from", from.rawValue, "--to", to.rawValue, "--json"],
                workingDirectory: repositoryPath,
                startedAt: Date(),
                finishedAt: Date(),
                exitCode: decision.exitCode,
                status: "blocked",
                stdout: decision.summary,
                stderr: "",
                parsedResult: nil,
                parseError: nil
            )
            return
        }
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
        guard var operation = operationForCurrentStage() else { return }

        // Append owner credentials and target for boot-policy-create operation
        if operation.id == "boot-policy-create" {
            var cmd = operation.command
            if let installTarget = installTarget, !installTarget.isEmpty {
                cmd += " --target \(installTarget)"
            }
            if let creds = ownerCredentials {
                cmd += " --owner-user \(creds.username) --owner-password \(creds.password)"
            }
            cmd += " --json"
            operation = WizardOperation(
                id: operation.id, title: operation.title, category: operation.category,
                stage: operation.stage, privilegeLevel: operation.privilegeLevel,
                destructive: operation.destructive, requiresConfirmation: operation.requiresConfirmation,
                requiresHelper: operation.requiresHelper, dryRunAvailable: operation.dryRunAvailable,
                command: cmd, rollbackHint: operation.rollbackHint
            )
        }

        // m1n1-build builds from source - just ensure --json
        if operation.id == "m1n1-build" {
            var cmd = operation.command
            cmd += " --json"
            operation = WizardOperation(
                id: operation.id, title: operation.title, category: operation.category,
                stage: operation.stage, privilegeLevel: operation.privilegeLevel,
                destructive: operation.destructive, requiresConfirmation: operation.requiresConfirmation,
                requiresHelper: operation.requiresHelper, dryRunAvailable: operation.dryRunAvailable,
                command: cmd, rollbackHint: operation.rollbackHint
            )
        }

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

        // Update boot policy view model from result
        if operation.id == "boot-policy-create" {
            bootPolicyVM.updateFromResult(execution.parsedResult.map { _ in
                (try? JSONSerialization.jsonObject(with: execution.stdout.data(using: .utf8) ?? Data())) as? [String: Any]
            } ?? nil)
        }

        isRunning = false
    }
}
