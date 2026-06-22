import SwiftUI

struct ProtectedPartitionGuardView: View {
    let state: ProtectedPartitionGuardState?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Protected Apple Partitions")
                .font(.headline)
            Text("Status: \(state?.status ?? "unknown")")
                .foregroundColor(color)
            if let summary = state?.summary {
                Text(summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var color: Color {
        switch state?.status {
        case "passed": return .green
        case "failed": return .red
        default: return .secondary
        }
    }
}
