import SwiftUI

struct UninstallWelcomeStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Remove Cidre Safely",
            bodyText: "Terminal is not required. The app handles export, scans, planning, guarded execution checks, and post-uninstall reporting."
        ) {
            Text("Deletion never skips export and target review.")
        }
    }
}
