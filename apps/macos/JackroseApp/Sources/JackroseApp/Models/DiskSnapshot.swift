import Foundation

struct DiskSnapshotStatus: Codable {
    let schemaVersion: Int
    let command: String
    let status: String
    let summary: String
    let snapshotFile: String?

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case command, status, summary
        case snapshotFile = "snapshot_file"
    }
}

struct DiskSnapshotAvailability {
    let beforeAvailable: Bool
    let afterAvailable: Bool
    let beforePath: String?
    let afterPath: String?
}
