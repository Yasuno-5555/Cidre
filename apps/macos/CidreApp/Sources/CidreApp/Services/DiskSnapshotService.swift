import Foundation

final class DiskSnapshotService {
    static let shared = DiskSnapshotService()
    private init() {}

    func availability(repositoryPath: String) -> DiskSnapshotAvailability {
        let snapshotsDir = URL(fileURLWithPath: repositoryPath).appendingPathComponent(".local/state/cidre/boot-safety/snapshots")
        let fm = FileManager.default
        let files = (try? fm.contentsOfDirectory(at: snapshotsDir, includingPropertiesForKeys: nil)) ?? []
        let before = files.filter { $0.lastPathComponent.contains("before") && $0.pathExtension == "json" }.sorted { $0.lastPathComponent < $1.lastPathComponent }.last
        let after = files.filter { $0.lastPathComponent.contains("after") && $0.pathExtension == "json" }.sorted { $0.lastPathComponent < $1.lastPathComponent }.last
        return DiskSnapshotAvailability(
            beforeAvailable: before != nil,
            afterAvailable: after != nil,
            beforePath: before?.path,
            afterPath: after?.path
        )
    }
}
