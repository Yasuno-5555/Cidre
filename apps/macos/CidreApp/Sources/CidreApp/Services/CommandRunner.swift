import Foundation

class CommandRunner {
    static let shared = CommandRunner()
    
    private init() {}
    
    func execute(_ command: String, isMockMode: Bool = true) -> CommandResult {
        if isMockMode {
            // Mock execution results
            if command.contains("install-preflight") {
                return CommandResult(
                    schemaVersion: 1,
                    command: "cidre-install-preflight",
                    status: "pass",
                    summary: "Install preflight checks passed successfully.",
                    phase: "install",
                    stage: "macos-preflight",
                    exitCode: 0,
                    warnings: [],
                    errors: [],
                    artifacts: nil,
                    nextActions: nil
                )
            } else if command.contains("uninstall-execute") {
                return CommandResult(
                    schemaVersion: 1,
                    command: "cidre-uninstall-execute",
                    status: "blocked",
                    summary: "Destructive uninstall refused (mock check).",
                    phase: "uninstall",
                    stage: "execute-optional",
                    exitCode: 8,
                    warnings: [],
                    errors: [
                        CommandError(code: "confirmation-required", message: "Explicit confirmation phrase is required.")
                    ],
                    artifacts: nil,
                    nextActions: [
                        NextAction(label: "Review dry-run plan", command: "scripts/cidre-uninstall-dry-run --target <target>")
                    ]
                )
            }
        }
        
        // Safety validation (Real execution is blocked for safety in prototype)
        return CommandResult(
            schemaVersion: 1,
            command: command,
            status: "blocked",
            summary: "Command execution blocked in read-only prototype mode.",
            phase: nil,
            stage: nil,
            exitCode: 8,
            warnings: ["Prototype is read-only"],
            errors: [
                CommandError(code: "read-only-prototype", message: "Execution of system commands is restricted in this release.")
            ],
            artifacts: nil,
            nextActions: nil
        )
    }
}
