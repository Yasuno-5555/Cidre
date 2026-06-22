import Foundation
import CryptoKit

enum DiskOperationService {
    struct Result {
        let status: String
        let summary: String
        let exitCode: Int32
        let command: [String]
        let stdout: String
        let stderr: String
    }

    private static let diskIdentifier = try! NSRegularExpression(pattern: #"^disk[0-9]+s[0-9]+$"#)
    private static let containerIdentifier = try! NSRegularExpression(pattern: #"^disk[0-9]+s[0-9]+$"#)
    private static let sizeValue = try! NSRegularExpression(pattern: #"^(0|[1-9][0-9]*(B|K|M|G|T|P))$"#, options: .caseInsensitive)

    static func execute(_ request: HelperProtocol) -> Result {
        guard request.schemaVersion == 1 else { return rejected("Unsupported helper request schema.") }
        guard HelperAuthorization.canExecute(request) else { return rejected("Confirmation token does not match the plan.") }
        guard let target = request.target, matches(diskIdentifier, target) else {
            return rejected("Target must be a partition or APFS container identifier such as disk3s2.")
        }
        if request.operation == "partition-create" || request.operation == "partition-delete" {
            guard request.planID == expectedPlanID(for: request, target: target) else {
                return rejected("Plan ID does not match the requested disk operation.")
            }
        }

        let command: [String]
        switch request.operation {
        case "partition-create":
            guard request.arguments.count == 3,
                  matches(containerIdentifier, target),
                  matches(sizeValue, request.arguments[0]),
                  validVolumeName(request.arguments[1]),
                  matches(sizeValue, request.arguments[2]) else {
                return rejected("partition-create requires container-size, volume-name, and partition-size.")
            }
            guard let resizeError = validateResize(target: target, containerSize: request.arguments[0], partitionSize: request.arguments[2]) else {
                return rejected("Could not read APFS resize limits for the selected target.")
            }
            guard resizeError.isEmpty else { return rejected(resizeError) }
            command = ["/usr/sbin/diskutil", "apfs", "resizeContainer", target, request.arguments[0], "APFS", request.arguments[1], request.arguments[2]]
        case "apfs-resize-container":
            guard request.arguments.count == 1, matches(sizeValue, request.arguments[0]) else {
                return rejected("apfs-resize-container requires one validated size.")
            }
            guard let resizeError = validateResize(target: target, containerSize: request.arguments[0], partitionSize: nil) else {
                return rejected("Could not read APFS resize limits for the selected target.")
            }
            guard resizeError.isEmpty else { return rejected(resizeError) }
            command = ["/usr/sbin/diskutil", "apfs", "resizeContainer", target, request.arguments[0]]
        case "apfs-delete-volume":
            guard request.arguments.isEmpty else { return rejected("apfs-delete-volume accepts no extra arguments.") }
            guard !isProtectedForDeletion(target) else { return rejected("The selected APFS volume is protected or belongs to the startup system.") }
            command = ["/usr/sbin/diskutil", "apfs", "deleteVolume", target]
        case "partition-delete":
            guard request.arguments.isEmpty else { return rejected("partition-delete accepts no extra arguments.") }
            guard !isProtectedForDeletion(target) else { return rejected("The selected partition is protected or belongs to the startup system.") }
            command = ["/usr/sbin/diskutil", "eraseVolume", "free", "CidreFreeSpace", target]
        default:
            return rejected("Operation is not in the helper allowlist.")
        }

        guard validateTargetStillExists(target) else { return rejected("Target disappeared or changed before execution.") }
        if request.dryRun {
            return Result(status: "pass", summary: "Validated disk operation preview.", exitCode: 0, command: command, stdout: "", stderr: "")
        }

        let process = Process()
        let stdout = Pipe()
        let stderr = Pipe()
        process.executableURL = URL(fileURLWithPath: command[0])
        process.arguments = Array(command.dropFirst())
        process.standardOutput = stdout
        process.standardError = stderr
        do {
            try process.run()
            process.waitUntilExit()
            let output = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let error = String(data: stderr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            return Result(
                status: process.terminationStatus == 0 ? "pass" : "fail",
                summary: process.terminationStatus == 0 ? "Disk operation completed." : "diskutil rejected or failed the operation.",
                exitCode: process.terminationStatus,
                command: command,
                stdout: output,
                stderr: error
            )
        } catch {
            return Result(status: "fail", summary: "Could not start diskutil.", exitCode: 1, command: command, stdout: "", stderr: error.localizedDescription)
        }
    }

    private static func rejected(_ message: String) -> Result {
        Result(status: "blocked", summary: message, exitCode: 4, command: [], stdout: "", stderr: "")
    }

    private static func matches(_ expression: NSRegularExpression, _ value: String) -> Bool {
        expression.firstMatch(in: value, range: NSRange(value.startIndex..., in: value)) != nil
    }

    private static func validVolumeName(_ value: String) -> Bool {
        !value.isEmpty && value.count <= 64 && !value.contains("/") && !value.contains("\n")
    }

    private static func expectedPlanID(for request: HelperProtocol, target: String) -> String? {
        let mode = request.operation == "partition-create" ? "install" : "uninstall"
        let containerSize = request.arguments.indices.contains(0) && request.operation == "partition-create" ? request.arguments[0] : ""
        let volumeName = request.arguments.indices.contains(1) && request.operation == "partition-create" ? request.arguments[1] : ""
        let partitionSize = request.arguments.indices.contains(2) && request.operation == "partition-create" ? request.arguments[2] : ""
        let canonical = [mode, request.operation, target, containerSize, partitionSize, volumeName].joined(separator: "\n")
        let digest = SHA256.hash(data: Data(canonical.utf8))
        return digest.prefix(8).map { String(format: "%02x", $0) }.joined()
    }

    private static func validateResize(target: String, containerSize: String, partitionSize: String?) -> String? {
        guard let limits = plist(["apfs", "resizeContainer", target, "limits", "-plist"]),
              let current = (limits["CurrentSize"] as? NSNumber)?.int64Value,
              let preferred = (limits["MinimumSizePreferred"] as? NSNumber)?.int64Value,
              let requested = bytes(from: containerSize) else { return nil }
        if requested < preferred {
            return "Requested container size is below macOS recommended minimum (\(preferred) bytes). Free space and retry."
        }
        if requested > current {
            return "Requested container size exceeds the current APFS physical store size."
        }
        if let partitionSize {
            guard let partitionBytes = bytes(from: partitionSize), partitionBytes > 0 else {
                return "New partition size must be a positive explicit size."
            }
            if requested > current - partitionBytes {
                return "Container and new partition sizes exceed the current physical store size."
            }
        }
        return ""
    }

    private static func bytes(from value: String) -> Int64? {
        if value == "0" { return 0 }
        guard let unit = value.last, let number = Int64(value.dropLast()) else { return nil }
        let multiplier: Int64
        switch String(unit).uppercased() {
        case "B": multiplier = 1
        case "K": multiplier = 1_000
        case "M": multiplier = 1_000_000
        case "G": multiplier = 1_000_000_000
        case "T": multiplier = 1_000_000_000_000
        case "P": multiplier = 1_000_000_000_000_000
        default: return nil
        }
        return number.multipliedReportingOverflow(by: multiplier).overflow ? nil : number * multiplier
    }

    private static func validateTargetStillExists(_ target: String) -> Bool {
        runDiskutil(["info", "-plist", target]).status == 0
    }

    private static func isProtectedForDeletion(_ target: String) -> Bool {
        guard let targetInfo = plist(["info", "-plist", target]),
              let rootInfo = plist(["info", "-plist", "/"]) else { return true }
        let mountPoint = targetInfo["MountPoint"] as? String
        if mountPoint == "/" || mountPoint == "/System/Volumes/Data" { return true }
        let targetUUIDs = identifiers(in: targetInfo)
        let rootUUIDs = identifiers(in: rootInfo)
        if !targetUUIDs.isDisjoint(with: rootUUIDs) { return true }
        let name = ((targetInfo["VolumeName"] as? String) ?? "").lowercased()
        return name.contains("recovery") || name.contains("preboot") || name.contains("vm")
    }

    private static func identifiers(in dictionary: [String: Any]) -> Set<String> {
        let keys = ["DeviceIdentifier", "APFSContainerReference", "APFSVolumeGroupUUID", "VolumeUUID", "ParentWholeDisk"]
        var result = Set(keys.compactMap { dictionary[$0] as? String })
        func collect(_ value: Any) {
            if let nested = value as? [String: Any] {
                for (key, item) in nested {
                    if (keys + ["APFSPhysicalStore"]).contains(key), let identifier = item as? String {
                        result.insert(identifier)
                    }
                    collect(item)
                }
            } else if let items = value as? [Any] {
                items.forEach(collect)
            }
        }
        collect(dictionary)
        return result
    }

    private static func plist(_ arguments: [String]) -> [String: Any]? {
        let result = runDiskutil(arguments)
        guard result.status == 0 else { return nil }
        return (try? PropertyListSerialization.propertyList(from: result.data, options: [], format: nil)) as? [String: Any]
    }

    private static func runDiskutil(_ arguments: [String]) -> (status: Int32, data: Data) {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
            return (process.terminationStatus, pipe.fileHandleForReading.readDataToEndOfFile())
        } catch {
            return (1, Data())
        }
    }
}
