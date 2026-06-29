import Foundation

class SafeCommandPolicy {
    static let shared = SafeCommandPolicy()
    
    private init() {}
    
    func getPolicy() -> SafetyPolicy {
        return SafetyPolicy(
            allowMockCommands: true,
            allowReadOnlyCommands: true,
            allowDestructiveCommands: true,
            allowRootCommands: true,
            blockedReasons: [
                "Disk changes require a validated plan and exact confirmation phrase.",
                "Privilege elevation is restricted to the Jackrose helper allowlist."
            ]
        )
    }
    
    func validateCommand(_ command: String, in manifest: CommandManifest?) -> (allowed: Bool, reason: String?) {
        guard let manifest = manifest else {
            return (false, "No command manifest loaded")
        }

        let cleanedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
        let baseCommand = cleanedCommand.split(separator: " ").first.map(String.init) ?? cleanedCommand
        guard let info = manifest.commands.first(where: { 
            $0.name == baseCommand ||
            $0.path == baseCommand ||
            $0.path.hasSuffix("/" + baseCommand)
        }) else {
            return (false, "Command not listed in manifest")
        }

        if info.destructiveCapable && baseCommand != "jackrose-app-helper-command" && !baseCommand.hasSuffix("/jackrose-app-helper-command") {
            return (false, "Blocked: destructive commands must use the authenticated Jackrose helper")
        }

        if info.requiresRoot && baseCommand != "jackrose-app-helper-command" && !baseCommand.hasSuffix("/jackrose-app-helper-command") {
            return (false, "Blocked: privilege elevation is limited to the authenticated Jackrose helper")
        }

        return (true, nil)
    }
}
