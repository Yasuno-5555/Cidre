import SwiftUI

struct WizardBlockedView: View {
    let reason: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blocked")
                .font(.headline)
            Text(reason)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.08))
        .cornerRadius(10)
    }
}
