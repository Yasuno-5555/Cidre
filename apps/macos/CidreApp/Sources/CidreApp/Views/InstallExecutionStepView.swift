import SwiftUI

struct InstallExecutionStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Install Execution",
            bodyText: "Run the prepared installer stage and keep its progress, artifacts, and verification result in this wizard."
        ) {
            Text("Disk preparation is executed from the Disk Plan step after preview, confirmation, and macOS administrator authentication.")
        }
    }
}
