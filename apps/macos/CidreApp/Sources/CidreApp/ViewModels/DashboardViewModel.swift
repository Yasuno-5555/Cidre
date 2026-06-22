import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var readinessStatus: String = "unknown"
    @Published var checkedTime: String = "never"
    @Published var manifestCommandsCount: Int = 0
    @Published var activeStage: String = "uninstall-preflight"
    @Published var activeStatus: String = "pending"
    
    func refresh(repoPath: String, isMockMode: Bool) {
        if isMockMode {
            readinessStatus = "pass"
            checkedTime = "June 22, 2026 01:40:00 UTC"
            manifestCommandsCount = 5
            activeStage = "uninstall-preflight"
            activeStatus = "pending"
            return
        }
        
        // Real read logic from repository paths
        let manifest = JSONLoader.shared.load(CommandManifest.self, fromFile: "interface/command-manifest.json")
        manifestCommandsCount = manifest?.commands.count ?? 0
        
        let readiness = CommandRunner.shared.execute("scripts/cidre-app-readiness --json", isMockMode: false)
        readinessStatus = readiness.status
        checkedTime = "Just checked"
    }
}
