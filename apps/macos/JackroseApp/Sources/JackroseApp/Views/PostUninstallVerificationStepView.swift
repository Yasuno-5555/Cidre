import SwiftUI

struct PostUninstallVerificationStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Post-uninstall Verification",
            bodyText: "Verify disk state, restore guidance, and remaining artifacts after the uninstall workflow."
        ) {
            Text("The app records the result instead of handing work back to Terminal.")
        }
    }
}
