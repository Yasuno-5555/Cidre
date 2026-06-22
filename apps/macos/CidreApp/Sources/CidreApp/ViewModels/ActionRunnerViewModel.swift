import SwiftUI

class ActionRunnerViewModel: ObservableObject {
    @Published var actions: [AppAction] = []
    @Published var executionResult: CommandExecution?
    @Published var isExecuting = false
    
    func loadActions(repositoryPath: String) {
        let fixturesDir = URL(fileURLWithPath: (repositoryPath as NSString).expandingTildeInPath).appendingPathComponent("apps/macos/CidreApp/Fixtures")
        let actionsUrl = fixturesDir.appendingPathComponent("app-actions.sample.json")
        if let data = try? Data(contentsOf: actionsUrl),
           let list = try? JSONDecoder().decode([AppAction].self, from: data) {
            actions = list
        } else {
            actions = [
                AppAction(id: "install-preflight", title: "Install Preflight Check", category: "install", command: "scripts/cidre-install-preflight --json", safeToRun: true, requiresPrivilege: false, destructive: false),
                AppAction(id: "install-execute", title: "Real Install", category: "install", command: "scripts/cidre-install-execute", safeToRun: false, requiresPrivilege: true, destructive: true),
                AppAction(id: "uninstall-preflight", title: "Uninstall Preflight Check", category: "uninstall", command: "scripts/cidre-uninstall-preflight --json", safeToRun: true, requiresPrivilege: false, destructive: false),
                AppAction(id: "uninstall-execute", title: "Real Uninstall", category: "uninstall", command: "scripts/cidre-uninstall-execute", safeToRun: false, requiresPrivilege: true, destructive: true)
            ]
        }
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
                parsedResult: errorResult
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
