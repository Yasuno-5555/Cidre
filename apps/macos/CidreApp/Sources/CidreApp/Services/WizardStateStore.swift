import Foundation

final class WizardStateStore {
    static let shared = WizardStateStore()

    private init() {}

    func currentDirectory(repositoryPath: String) -> URL {
        URL(fileURLWithPath: (repositoryPath as NSString).expandingTildeInPath)
            .appendingPathComponent(".local/state/cidre/app-wizard/current")
    }

    func stateURL(repositoryPath: String) -> URL {
        currentDirectory(repositoryPath: repositoryPath).appendingPathComponent("wizard-state.json")
    }

    func load(repositoryPath: String, mode: WizardMode) -> WizardState {
        let url = stateURL(repositoryPath: repositoryPath)
        guard let data = try? Data(contentsOf: url),
              let state = try? JSONDecoder().decode(WizardState.self, from: data) else {
            return .initial(mode: mode)
        }
        return state
    }

    func save(_ state: WizardState, repositoryPath: String) {
        let dir = currentDirectory(repositoryPath: repositoryPath)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        if let data = try? JSONEncoder().encode(state) {
            try? data.write(to: stateURL(repositoryPath: repositoryPath))
        }
    }
}
