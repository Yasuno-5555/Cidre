import Foundation
import Combine

/// State of m1n1 bootloader acquisition
enum M1n1State: Equatable {
    case notAcquired
    case downloading
    case acquired(version: String, path: String)
    case failed(reason: String)
}

/// Boot security mode for the Cidre Volume Group
enum SecurityModeState: Equatable {
    case unknown
    case fullSecurity
    case reducedSecurity
    case permissiveSecurity
}

/// How Reduced Security was (or needs to be) configured
enum ReducedSecurityState: Equatable {
    case unknown
    case setViaBputil
    case setViaRecovery
    case manualRecoveryRequired
}

/// Manages boot policy state: m1n1 acquisition, boot policy creation, security mode verification.
final class BootPolicyViewModel: ObservableObject {
    @Published var m1n1State: M1n1State = .notAcquired
    @Published var securityMode: SecurityModeState = .unknown
    @Published var reducedSecurityState: ReducedSecurityState = .unknown
    @Published var ownerCredentials: OwnerCredentials?
    @Published var isRunning = false
    @Published var lastResult: [String: Any]?
    @Published var summaryText: String = ""
    @Published var guidanceText: String = ""

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Script Execution Helpers

    /// Build arguments for scripts that need owner credentials
    func credentialArgs() -> [String] {
        guard let creds = ownerCredentials else { return [] }
        return ["--owner-user", creds.username, "--owner-password", creds.password]
    }

    /// Parse a CommandResult-like dictionary from script JSON output
    func parseResult(from jsonString: String?) -> [String: Any]? {
        guard let jsonString, let data = jsonString.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    /// Update state from a parsed result dictionary
    func updateFromResult(_ result: [String: Any]?) {
        lastResult = result
        guard let result else { return }

        if let m1n1Installed = result["m1n1_installed"] as? Bool, m1n1Installed {
            let version = result["m1n1_version"] as? String ?? "unknown"
            m1n1State = .acquired(version: version, path: result["m1n1_path"] as? String ?? "")
        }

        if let mode = result["security_mode"] as? String {
            switch mode {
            case "full": securityMode = .fullSecurity
            case "reduced": securityMode = .reducedSecurity
            case "permissive": securityMode = .permissiveSecurity
            default: securityMode = .unknown
            }
        }

        if let reducedStatus = result["reduced_security_status"] as? String {
            switch reducedStatus {
            case "set-via-bputil", "set-via-fork": reducedSecurityState = .setViaBputil
            case "set-via-recovery": reducedSecurityState = .setViaRecovery
            default: reducedSecurityState = .manualRecoveryRequired
            }
        }

        summaryText = result["summary"] as? String ?? ""
        guidanceText = result["reduced_security_guide"] as? String ?? ""
    }
}
