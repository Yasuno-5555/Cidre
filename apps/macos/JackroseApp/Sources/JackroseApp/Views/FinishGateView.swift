import SwiftUI

struct FinishGateView: View {
    let gateState: FinishGateState?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Jackrose cannot finish setup yet.")
                .font(.headline)
            Text(gateState?.summary ?? "Boot safety has not been verified.")
                .foregroundColor(.secondary)
            Text("Do not restart or shut down until this gate passes.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
