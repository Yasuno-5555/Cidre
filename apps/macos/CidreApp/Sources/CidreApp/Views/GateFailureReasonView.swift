import SwiftUI

struct GateFailureReasonView: View {
    let gateState: GateState?

    var body: some View {
        if let checks = gateState?.checks.filter({ $0.status != "passed" }), !checks.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reasons")
                    .font(.headline)
                ForEach(checks) { check in
                    Text("- \(check.reason ?? check.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
