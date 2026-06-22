import Foundation

enum PartitionMode: String, CaseIterable {
    case max    = "max"
    case auto   = "auto"
    case min    = "min"
    case custom = "custom"

    var label: String {
        switch self {
        case .max:    return "Max"
        case .auto:   return "Auto"
        case .min:    return "Min"
        case .custom: return "Custom"
        }
    }

    var description: String {
        switch self {
        case .max:    return "Largest possible Cidre partition (macOS gets its recommended minimum)"
        case .auto:   return "Balanced split — ~60% of available space for Cidre"
        case .min:    return "Smallest useful Cidre partition (20 GB)"
        case .custom: return "Enter container and partition sizes manually"
        }
    }
}

final class DiskMutationViewModel: ObservableObject {
    @Published var killSwitchState: InstallerKillSwitchState = .containmentDefault
    @Published var target = ""
    @Published var partitionMode: PartitionMode = .auto
    @Published var containerSize = ""
    @Published var partitionSize = ""
    @Published var volumeName = "Cidre"
    @Published var confirmation = ""
    @Published var planID: String?
    @Published var requiredConfirmation: String?
    @Published var execution: CommandExecution?
    @Published var isRunning = false
    @Published var limitsInfo: [String: Any]?
    private var plannedInputSignature: String?

    var canPreview: Bool {
        killSwitchState.destructiveInstallAllowed
            && planID != nil
            && plannedInputSignature == inputSignature
            && !target.isEmpty
    }

    var canExecute: Bool {
        killSwitchState.destructiveInstallAllowed
            && canPreview
            && confirmation.trimmingCharacters(in: .whitespacesAndNewlines) == requiredConfirmation
    }

    var canCreatePlan: Bool {
        killSwitchState.destructiveInstallAllowed && !target.isEmpty && !isRunning
    }

    var maxPartitionHuman: String {
        guard let limits = limitsInfo,
              let bytes = limits["max_partition_bytes"] as? Int else { return "—" }
        return formatHuman(bytes)
    }

    var autoPartitionHuman: String {
        guard let limits = limitsInfo,
              let bytes = limits["auto_partition_bytes"] as? Int else { return "—" }
        return formatHuman(bytes)
    }

    private func formatHuman(_ bytes: Int) -> String {
        let gb = Double(bytes) / 1_000_000_000
        return String(format: "%.1f GB", gb)
    }

    func detectStartupStore() {
        guard target.isEmpty else { return }
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
        process.arguments = ["info", "-plist", "/"]
        process.standardOutput = pipe
        process.standardError = Pipe()
        do {
            try process.run()
            process.waitUntilExit()
            guard process.terminationStatus == 0,
                  let plist = try PropertyListSerialization.propertyList(from: pipe.fileHandleForReading.readDataToEndOfFile(), options: [], format: nil) as? [String: Any],
                  let stores = plist["APFSPhysicalStores"] as? [[String: Any]],
                  let identifier = stores.first?["APFSPhysicalStore"] as? String else { return }
            target = identifier
        } catch {
            return
        }
        // Fetch limits once target is known
        fetchLimits()
    }

    func refreshKillSwitch(repositoryPath: String) {
        let execution = LiveCommandRunner.shared.run(
            "scripts/cidre-app-installer-killswitch",
            arguments: ["--status", "--json"],
            repositoryPath: repositoryPath,
            isMockMode: false
        )
        guard let data = execution.stdout.data(using: .utf8),
              let state = try? JSONDecoder().decode(InstallerKillSwitchState.self, from: data) else {
            killSwitchState = .containmentDefault
            return
        }
        killSwitchState = state
    }

    func fetchLimits() {
        guard !target.isEmpty else { return }
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let process = Process()
            let pipe = Pipe()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
            process.arguments = ["apfs", "resizeContainer", target, "limits", "-plist"]
            process.standardOutput = pipe
            process.standardError = Pipe()
            try? process.run()
            process.waitUntilExit()
            guard process.terminationStatus == 0,
                  let plist = try? PropertyListSerialization.propertyList(from: pipe.fileHandleForReading.readDataToEndOfFile(), options: [], format: nil) as? [String: Any],
                  let current = (plist["CurrentSize"] as? NSNumber)?.intValue,
                  let minPref = (plist["MinimumSizePreferred"] as? NSNumber)?.intValue else { return }
            let maxPartition = current - minPref
            let autoPartition = max(10_000_000_000, Int((Double(maxPartition) * 0.6 / 10_000_000_000).rounded()) * 10_000_000_000)
            let info: [String: Any] = [
                "current_bytes": current,
                "min_preferred_bytes": minPref,
                "max_partition_bytes": maxPartition,
                "auto_partition_bytes": min(autoPartition, maxPartition),
            ]
            DispatchQueue.main.async { self.limitsInfo = info }
        }
    }

    func createPlan(repositoryPath: String) {
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-disk-plan", arguments: planArguments)
        // Parse returned plan_id from JSON output
        guard let data = execution?.stdout.data(using: .utf8),
              let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
              execution?.status == "pass" else {
            planID = nil
            requiredConfirmation = nil
            return
        }
        planID = object["plan_id"] as? String
        requiredConfirmation = object["required_confirmation"] as? String
        plannedInputSignature = inputSignature
        // Persist resolved sizes from non-custom modes so Validate Preview stays in sync
        if partitionMode != .custom {
            containerSize = object["container_size"] as? String ?? containerSize
            partitionSize = object["partition_size"] as? String ?? partitionSize
        }
        confirmation = ""
    }

    func preview(repositoryPath: String) {
        guard let planID else { return }
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-helper-command", arguments: helperArguments(planID: planID, dryRun: true))
    }

    func execute(repositoryPath: String) {
        guard let planID, confirmation.trimmingCharacters(in: .whitespacesAndNewlines) == requiredConfirmation else { return }
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-helper-command", arguments: helperArguments(planID: planID, dryRun: false))
    }

    private var planArguments: [String] {
        var args = ["--mode", "install", "--target", target,
                    "--partition-mode", partitionMode.rawValue,
                    "--volume-name", volumeName, "--json"]
        if partitionMode == .custom {
            args += ["--container-size", containerSize, "--partition-size", partitionSize]
        }
        return args
    }

    private var inputSignature: String {
        [target, partitionMode.rawValue, containerSize, partitionSize, volumeName].joined(separator: "\n")
    }

    private func helperArguments(planID: String, dryRun: Bool) -> [String] {
        var arguments = [
            "--operation", "partition-create",
            "--target", target,
            "--container-size", containerSize,
            "--partition-size", partitionSize,
            "--volume-name", volumeName,
            "--plan-id", planID,
        ]
        if dryRun {
            arguments.append("--dry-run")
        } else {
            arguments.append(contentsOf: ["--confirm", confirmation.trimmingCharacters(in: .whitespacesAndNewlines)])
        }
        arguments.append("--json")
        return arguments
    }

    private func run(repositoryPath: String, command: String, arguments: [String]) {
        isRunning = true
        execution = LiveCommandRunner.shared.run(command, arguments: arguments, repositoryPath: repositoryPath, isMockMode: false)
        isRunning = false
    }
}
