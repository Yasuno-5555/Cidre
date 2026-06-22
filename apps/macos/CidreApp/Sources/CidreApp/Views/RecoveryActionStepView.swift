import SwiftUI

struct RecoveryActionStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Recovery Action",
            bodyText: "Present the next guided recovery step while keeping blocked actions explicit and explained."
        ) {
            Text("The app owns the workflow and the safety boundaries.")
        }
    }
}
