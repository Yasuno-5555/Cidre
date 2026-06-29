import SwiftUI

class LiveDashboardViewModel: ObservableObject {
    @Published var status: RepositoryStatus?
    @Published var runtimeState: RuntimeValidationState?
    @Published var appReadinessResult: CommandResult?
    @Published var doctorResult: CommandResult?
    @Published var reportIndexResult: CommandExecution?
    @Published var isRunningReadiness = false
    @Published var isRunningDoctor = false
    @Published var isRunningReportIndex = false
    
    func refresh(repositoryPath: String) {
        status = RepositoryPathStore.shared.validatePath(repositoryPath)
        runtimeState = loadRuntimeState(repositoryPath: repositoryPath)
    }
    
    func runAppReadiness(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        isRunningReadiness = true
        let start = Date()
        let execution = LiveCommandRunner.shared.run(
            "scripts/jackrose-app-readiness",
            arguments: ["--json"],
            repositoryPath: repositoryPath,
            isMockMode: isMockMode
        )
        let duration = Date().timeIntervalSince(start)
        appReadinessResult = execution.parsedResult
        logStore.append(
            command: execution.command,
            arguments: execution.arguments,
            exitCode: execution.exitCode ?? 0,
            status: execution.status,
            summary: execution.parsedResult?.summary ?? "App readiness check finished.",
            duration: duration
        )
        runtimeState = loadRuntimeState(repositoryPath: repositoryPath)
        isRunningReadiness = false
    }
    
    func runInterfaceDoctor(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        isRunningDoctor = true
        let start = Date()
        let execution = LiveCommandRunner.shared.run(
            "scripts/jackrose-interface-doctor",
            arguments: ["--json"],
            repositoryPath: repositoryPath,
            isMockMode: isMockMode
        )
        let duration = Date().timeIntervalSince(start)
        doctorResult = execution.parsedResult
        logStore.append(
            command: execution.command,
            arguments: execution.arguments,
            exitCode: execution.exitCode ?? 0,
            status: execution.status,
            summary: execution.parsedResult?.summary ?? "Interface doctor finished.",
            duration: duration
        )
        runtimeState = loadRuntimeState(repositoryPath: repositoryPath)
        isRunningDoctor = false
    }

    func runReportIndex(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        isRunningReportIndex = true
        let start = Date()
        let execution = LiveCommandRunner.shared.run(
            "scripts/jackrose-report-index",
            arguments: ["--scan", "--json"],
            repositoryPath: repositoryPath,
            isMockMode: isMockMode
        )
        let duration = Date().timeIntervalSince(start)
        reportIndexResult = execution
        logStore.append(
            command: execution.command,
            arguments: execution.arguments,
            exitCode: execution.exitCode ?? 0,
            status: execution.status,
            summary: execution.parsedResult?.summary ?? "Report index finished.",
            duration: duration
        )
        runtimeState = loadRuntimeState(repositoryPath: repositoryPath)
        isRunningReportIndex = false
    }

    func runtimeStatus(for key: String) -> String {
        runtimeState?.status(for: key) ?? "pending"
    }

    private func loadRuntimeState(repositoryPath: String) -> RuntimeValidationState? {
        let stateURL = URL(fileURLWithPath: (repositoryPath as NSString).expandingTildeInPath)
            .appendingPathComponent(".local/state/jackrose/app-runtime/current/runtime-state.json")
        guard let data = try? Data(contentsOf: stateURL) else {
            return nil
        }
        return try? JSONDecoder().decode(RuntimeValidationState.self, from: data)
    }
}
