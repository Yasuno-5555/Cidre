import Foundation

final class DiskDiffService {
    static let shared = DiskDiffService()
    private init() {}

    func evaluate(repositoryPath: String, snapshots: DiskSnapshotAvailability) -> DiskDiffState? {
        guard let beforePath = snapshots.beforePath, let afterPath = snapshots.afterPath else { return nil }
        let result = LiveCommandRunner.shared.run(
            "scripts/jackrose-app-prepost-disk-diff",
            arguments: ["--before", beforePath, "--after", afterPath, "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = result.stdout.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(DiskDiffState.self, from: data)
    }
}
