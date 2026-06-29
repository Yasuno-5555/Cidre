import SwiftUI

struct SetupWelcomeStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Start Jackrose Setup",
            bodyText: "Terminal is not required. The app owns compatibility checks, safety gates, planning, artifacts, and guided progress tracking. Disk-changing install remains blocked until boot safety verification passes."
        ) {
            Text("This linear wizard is designed for a terminal-free setup flow on macOS, but it now defaults to DFU incident containment for any real disk mutation.")
        }
    }
}
