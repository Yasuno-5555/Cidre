import SwiftUI

class LiveDashboardViewModel: ObservableObject {
    @Published var status: RepositoryStatus?
    @Published var appReadinessResult: CommandResult?
    @Published var doctorResult: CommandResult?
    @Published var isRunningReadiness = false
    @Published var isRunningDoctor = false
    
    func refresh(repositoryPath: String) {
        status = RepositoryPathStore.shared.validatePath(repositoryPath)
    }
    
    func runAppReadiness(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        isRunningReadiness = true
        let start = Date()
        let execution = LiveCommandRunner.shared.run(
            "scripts/cidre-app-readiness",
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
        isRunningReadiness = false
    }
    
    func runInterfaceDoctor(repositoryPath: String, isMockMode: Bool, logStore: ExecutionLogStore) {
        isRunningDoctor = true
        let start = Date()
        let execution = LiveCommandRunner.shared.run(
            "scripts/cidre-interface-doctor",
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
        isRunningDoctor = false
    }
}
