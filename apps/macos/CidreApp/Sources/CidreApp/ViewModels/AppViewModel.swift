import SwiftUI

class AppViewModel: ObservableObject {
    @Published var repositoryPath: String = ""
    @Published var mockMode: Bool = true
    @Published var executionMode: String = "mock"
    @Published var logStore = ExecutionLogStore()
    @Published var commandManifest: CommandManifest?
    
    init() {
        self.repositoryPath = RepositoryPathStore.shared.loadPath()
        loadManifest()
    }
    
    func loadManifest() {
        let manifestPath = URL(fileURLWithPath: (repositoryPath as NSString).expandingTildeInPath)
            .appendingPathComponent("interface/command-manifest.json")
        if let data = try? Data(contentsOf: manifestPath) {
            commandManifest = try? JSONDecoder().decode(CommandManifest.self, from: data)
        }
    }
}
