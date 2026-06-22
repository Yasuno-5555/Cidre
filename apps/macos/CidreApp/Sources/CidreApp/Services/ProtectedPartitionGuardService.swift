import Foundation

final class ProtectedPartitionGuardService {
    static let shared = ProtectedPartitionGuardService()
    private init() {}

    func evaluate(repositoryPath: String, snapshots: DiskSnapshotAvailability) -> ProtectedPartitionGuardState? {
        guard let afterPath = snapshots.afterPath else { return nil }
        let result = LiveCommandRunner.shared.run(
            "scripts/cidre-app-protected-partition-guard",
            arguments: ["--snapshot", afterPath, "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(ProtectedPartitionGuardState.self, from: data)
    }
}
