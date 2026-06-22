import SwiftUI

class AppViewModel: ObservableObject {
    @Published var repositoryPath: String = ""
    @Published var mockMode: Bool = false
    @Published var executionMode: String = "live"
    @Published var logStore = ExecutionLogStore()
    @Published var operationLogStore = OperationLogStore()
    @Published var commandManifest: CommandManifest?
    @Published var launchSelection: String = "setup-wizard"
    
    init() {
        self.repositoryPath = RepositoryPathStore.shared.loadPath()
        loadManifest()
        updateLaunchSelection()
    }
    
    func loadManifest() {
        let manifestPath = URL(fileURLWithPath: (repositoryPath as NSString).expandingTildeInPath)
            .appendingPathComponent("interface/command-manifest.json")
        if let data = try? Data(contentsOf: manifestPath) {
            commandManifest = try? JSONDecoder().decode(CommandManifest.self, from: data)
        }
    }

    func updateLaunchSelection() {
        let stateURL = WizardStateStore.shared.stateURL(repositoryPath: repositoryPath)
        launchSelection = FileManager.default.fileExists(atPath: stateURL.path) ? "dashboard" : "setup-wizard"
    }
}
