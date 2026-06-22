import Foundation

struct DiskLayout: Codable {
    let schemaVersion: Int
    let internalDisk: String
    let targets: [DiskTarget]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case internalDisk = "internal_disk"
        case targets
    }
}
