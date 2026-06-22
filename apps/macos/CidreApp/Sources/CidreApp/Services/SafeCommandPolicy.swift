import Foundation

class SafeCommandPolicy {
    static let shared = SafeCommandPolicy()
    
    private init() {}
    
    func getPolicy() -> SafetyPolicy {
        return SafetyPolicy(
            allowMockCommands: true,
            allowReadOnlyCommands: true,
            allowDestructiveCommands: false,
            allowRootCommands: false,
            blockedReasons: [
                "Destructive operations are disabled in this prototype release.",
                "Root privilege elevation is blocked."
            ]
        )
    }
    
    func validateCommand(_ command: String, in manifest: CommandManifest?) -> (allowed: Bool, reason: String?) {
        guard let manifest = manifest else {
            return (false, "No command manifest loaded")
        }
        
        let cleanedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let info = manifest.commands.first(where: { 
            $0.name == cleanedCommand || 
            $0.path == cleanedCommand || 
            $0.path.hasSuffix("/" + cleanedCommand) 
        }) else {
            return (false, "Command not listed in manifest")
        }
        
        if info.destructiveCapable {
            return (false, "Blocked: Destructive capable commands are disabled in v0.33.0 prototype")
        }
        
        if info.requiresRoot {
            return (false, "Blocked: Commands requiring root are disabled in v0.33.0 prototype")
        }
        
        return (true, nil)
    }
}
