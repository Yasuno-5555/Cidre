import SwiftUI

struct RollbackReportRequiredView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Rollback Report Required")
                .font(.headline)
            Text("Jackrose requires a rollback or failure report before setup can be treated as complete.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
