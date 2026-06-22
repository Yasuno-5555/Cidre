import SwiftUI

struct CompatibilityStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Compatibility",
            bodyText: "Check macOS, Apple Silicon, bundled resources, backend scripts, and helper readiness."
        ) {
            Text("The app performs these checks directly instead of asking you to run commands manually.")
        }
    }
}
