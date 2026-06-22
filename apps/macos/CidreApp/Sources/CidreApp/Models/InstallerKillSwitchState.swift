import Foundation

struct InstallerKillSwitchState: Codable {
    let schemaVersion: Int
    let status: String
    let summary: String
    let installerStatus: String
    let destructiveInstallAllowed: Bool
    let reason: String

    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case status, summary, reason
        case installerStatus = "installer_status"
        case destructiveInstallAllowed = "destructive_install_allowed"
    }

    static let containmentDefault = InstallerKillSwitchState(
        schemaVersion: 1,
        status: "pass",
        summary: "Disk-changing install flows are disabled by default.",
        installerStatus: "disabled",
        destructiveInstallAllowed: false,
        reason: "DFU_RESTORE_001 containment active"
    )
}
