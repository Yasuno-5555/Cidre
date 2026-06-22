import Foundation

final class TargetClassifier {
    static let shared = TargetClassifier()
    private init() {}

    func command() -> String {
        "scripts/cidre-app-target-classify --json"
    }
}
