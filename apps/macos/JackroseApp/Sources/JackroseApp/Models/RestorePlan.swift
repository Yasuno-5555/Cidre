import Foundation

struct RestorePlan: Codable {
    let schemaVersion: Int
    let summary: String
    let artifacts: [String]

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case summary, artifacts
    }
}
