import SwiftUI

class ActionRunnerViewModel: ObservableObject {
    @Published var actions: [AppAction] = []
    @Published var executionResult: CommandExecution?
    @Published var isExecuting = false
    
    func loadActions(repositoryPath: String) {
        actions = [
            AppAction(id: "app-readiness", title: "App Readiness", category: "install", command: "scripts/jackrose-app-readiness --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "interface-doctor", title: "Interface Doctor", category: "repair", command: "scripts/jackrose-interface-doctor --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "report-index", title: "Report Index", category: "repair", command: "scripts/jackrose-report-index --scan --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "artifact-paths", title: "Artifact Paths", category: "repair", command: "scripts/jackrose-artifact-paths --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "install-dashboard-read", title: "Install Dashboard Read", category: "install", command: "scripts/jackrose-install-dashboard --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "uninstall-dashboard-read", title: "Uninstall Dashboard Read", category: "uninstall", command: "scripts/jackrose-uninstall-dashboard --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "real-install", title: "Real Install", category: "install", command: "scripts/jackrose-installer --apply", safeToRun: false, requiresPrivilege: true, destructive: true),
            AppAction(id: "real-uninstall", title: "Real Uninstall", category: "uninstall", command: "scripts/jackrose-uninstall-execute", safeToRun: false, requiresPrivilege: true, destructive: true)
        ]
    }
    
    func runAction(_ action: AppAction, repositoryPath: String, isMockMode: Bool, manifest: CommandManifest?, logStore: ExecutionLogStore) {
        let (allowed, reason) = SafeCommandPolicy.shared.validateCommand(action.command, in: manifest)
        
        if !allowed {
            let errorResult = CommandResult(
                schemaVersion: 1,
                command: action.command,
                status: "blocked",
                summary: reason ?? "Operation is blocked under safety policy.",
                phase: nil,
                stage: nil,
                exitCode: 1,
                warnings: [],
                errors: [CommandError(code: "safety-policy-violation", message: reason ?? "Blocked action")],
                artifacts: nil,
                nextActions: nil
            )
            
            executionResult = CommandExecution(
                id: UUID(),
                command: action.command,
                arguments: [],
                workingDirectory: repositoryPath,
                startedAt: Date(),
                finishedAt: Date(),
                exitCode: 1,
                status: "blocked",
                stdout: "",
                stderr: reason ?? "Blocked",
                parsedResult: errorResult,
                parseError: nil
            )
            logStore.append(
                command: action.command,
                arguments: [],
                exitCode: 1,
                status: "blocked",
                summary: errorResult.summary,
                duration: 0
            )
            return
        }
        
        isExecuting = true
        let start = Date()
        
        let parts = action.command.split(separator: " ").map(String.init)
        guard let baseCommand = parts.first else { return }
        let args = Array(parts.dropFirst())
        
        let execution = LiveCommandRunner.shared.run(
            baseCommand,
            arguments: args,
            repositoryPath: repositoryPath,
            isMockMode: isMockMode
        )
        
        let duration = Date().timeIntervalSince(start)
        executionResult = execution
        
        logStore.append(
            command: execution.command,
            arguments: execution.arguments,
            exitCode: execution.exitCode ?? 0,
            status: execution.status,
            summary: execution.parsedResult?.summary ?? "Action executed.",
            duration: duration
        )
        
        isExecuting = false
    }
}
