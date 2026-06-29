import Foundation

/// Persisted state for the boot policy flow, survives app restarts
/// (e.g., when user closes Jackrose, reboots to Recovery for SSU, and returns).
struct BootPolicyPersistedState: Codable {
    let ssuRequired: Bool
    let ssuCompleted: Bool
}

final class BootPolicyStateStore {
    static let shared = BootPolicyStateStore()

    private init() {}

    func stateURL(repositoryPath: String) -> URL {
        URL(fileURLWithPath: repositoryPath)
            .appendingPathComponent(".local/state/jackrose/install/current/boot-policy-state.json")
    }

    func load(repositoryPath: String) -> BootPolicyPersistedState? {
        let url = stateURL(repositoryPath: repositoryPath)
        guard let data = try? Data(contentsOf: url),
              let state = try? JSONDecoder().decode(BootPolicyPersistedState.self, from: data) else {
            return nil
        }
        return state
    }

    func save(_ state: BootPolicyPersistedState, repositoryPath: String) {
        let url = stateURL(repositoryPath: repositoryPath)
        let urlDir = url.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: urlDir, withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(state) else { return }
        try? data.write(to: url, options: .atomic)
    }

    func clear(repositoryPath: String) {
        let url = stateURL(repositoryPath: repositoryPath)
        try? FileManager.default.removeItem(at: url)
    }
}
