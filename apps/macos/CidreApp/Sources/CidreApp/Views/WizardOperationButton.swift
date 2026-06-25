import SwiftUI

struct WizardOperationButton: View {
    let title: String
    let running: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if running {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(running)
    }
}
