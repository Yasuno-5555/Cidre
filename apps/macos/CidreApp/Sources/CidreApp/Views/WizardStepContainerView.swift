import SwiftUI

struct WizardStepContainerView<Content: View>: View {
    let title: String
    let bodyText: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(bodyText)
                .foregroundColor(.secondary)
            content
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
