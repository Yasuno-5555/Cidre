import Foundation

struct APFSSnapshotStatus: Codable {
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
