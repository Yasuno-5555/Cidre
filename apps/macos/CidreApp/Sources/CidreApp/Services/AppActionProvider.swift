import Foundation

class AppActionProvider {
    static let shared = AppActionProvider()
    
    private init() {}
    
    func getActions(category: String? = nil) -> [AppAction] {
        // Load from interface/app-actions.json or use fallback
        let seed = JSONLoader.shared.load(AppActionsList.self, fromFile: "interface/app-actions.json")
        let actions = seed?.actions ?? [
            AppAction(id: "install-preflight", title: "Verify Installation Readiness", category: "install", command: "./install-macos --install-preflight --json", safeToRun: true, requiresPrivilege: false, destructive: false),
            AppAction(id: "uninstall-scan", title: "Scan Deletion Targets", category: "uninstall", command: "scripts/cidre-uninstall-target-scan --json", safeToRun: true, requiresPrivilege: false, destructive: false)
        ]
        
        if let cat = category {
            return actions.filter { $0.category == cat }
        }
        return actions
    }
}

struct AppActionsList: Codable {
    let schemaVersion: Int
    let actions: [AppAction]
    
    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case actions
    }
}
