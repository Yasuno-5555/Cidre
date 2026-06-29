import Foundation

final class TerminalFreePolicy {
    static let shared = TerminalFreePolicy()

    private let forbiddenPhrases = [
        "open terminal",
        "terminal.app",
        "copy this command",
        "run the following command",
        "iterm2"
    ]

    private init() {}

    func validate(message: String) -> Bool {
        let lowered = message.lowercased()
        return forbiddenPhrases.allSatisfy { !lowered.contains($0) }
    }
}
