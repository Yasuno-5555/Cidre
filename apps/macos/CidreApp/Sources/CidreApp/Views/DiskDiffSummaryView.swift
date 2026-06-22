import SwiftUI

struct DiskDiffSummaryView: View {
    let state: DiskDiffState?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Pre/Post Disk Diff")
                .font(.headline)
            Text("Status: \(state?.status ?? "unknown")")
                .foregroundColor(color)
            if let reasons = state?.blockedReasons, !reasons.isEmpty {
                Text(reasons.joined(separator: ", "))
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
