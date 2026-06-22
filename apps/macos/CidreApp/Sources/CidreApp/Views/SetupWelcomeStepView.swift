import SwiftUI

struct SetupWelcomeStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Start Cidre Setup",
            bodyText: "Terminal is not required. The app owns compatibility checks, safety gates, planning, artifacts, and guided progress tracking."
        ) {
            Text("This linear wizard is designed for a terminal-free setup flow on macOS.")
        }
    }
}
