import Foundation

final class WizardOperationRunner {
    static let shared = WizardOperationRunner()

    private init() {}

    func run(operation: WizardOperation, repositoryPath: String, isMockMode: Bool) -> CommandExecution {
        let parts = operation.command.split(separator: " ").map(String.init)
        let command = parts.first ?? operation.command
        let arguments = Array(parts.dropFirst())
        return LiveCommandRunner.shared.run(command, arguments: arguments, repositoryPath: repositoryPath, isMockMode: isMockMode)
    }
}
