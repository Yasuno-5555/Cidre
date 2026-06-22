import SwiftUI

struct UninstallConfirmationStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Confirmation",
            bodyText: "Explicit confirmation is required before helper-mediated deletion can even be considered."
        ) {
            Text("The uninstall flow stays GUI-owned and reviewable.")
        }
    }
}
