import Foundation

struct HelperStatus: Codable {
    let schemaVersion: Int
    let status: String
    let helperBundleExists: Bool
    let helperInstallReady: Bool
    let summary: String

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case status, summary
        case helperBundleExists = "helper_bundle_exists"
        case helperInstallReady = "helper_install_ready"
    }
}
