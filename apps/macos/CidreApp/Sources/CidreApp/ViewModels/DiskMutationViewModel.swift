import Foundation

final class DiskMutationViewModel: ObservableObject {
    @Published var target = ""
    @Published var containerSize = ""
    @Published var partitionSize = "80G"
    @Published var volumeName = "Cidre"
    @Published var confirmation = ""
    @Published var planID: String?
    @Published var requiredConfirmation: String?
    @Published var execution: CommandExecution?
    @Published var isRunning = false
    private var plannedInputSignature: String?

    var canPreview: Bool {
        planID != nil && plannedInputSignature == inputSignature && !target.isEmpty && !containerSize.isEmpty && !partitionSize.isEmpty
    }

    var canExecute: Bool {
        canPreview && confirmation == requiredConfirmation
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
    }

    func createPlan(repositoryPath: String) {
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-disk-plan", arguments: planArguments)
        guard let data = execution?.stdout.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              execution?.status == "pass" else {
            planID = nil
            requiredConfirmation = nil
            return
        }
        planID = object["plan_id"] as? String
        requiredConfirmation = object["required_confirmation"] as? String
        plannedInputSignature = inputSignature
        confirmation = ""
    }

    func preview(repositoryPath: String) {
        guard let planID else { return }
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-helper-command", arguments: helperArguments(planID: planID, dryRun: true))
    }

    func execute(repositoryPath: String) {
        guard let planID, confirmation == requiredConfirmation else { return }
        run(repositoryPath: repositoryPath, command: "scripts/cidre-app-helper-command", arguments: helperArguments(planID: planID, dryRun: false))
    }

    private var planArguments: [String] {
        ["--mode", "install", "--target", target, "--container-size", containerSize, "--partition-size", partitionSize, "--volume-name", volumeName, "--json"]
    }

    private var inputSignature: String {
        [target, containerSize, partitionSize, volumeName].joined(separator: "\n")
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
            arguments.append(contentsOf: ["--confirm", confirmation])
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
