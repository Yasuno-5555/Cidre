import SwiftUI

struct WizardConfirmationView: View {
    let prompt: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Confirmation Required")
                .font(.headline)
            Text(prompt)
                .foregroundColor(.secondary)
            TextField("Type confirmation phrase", text: $text)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(10)
    }
}
