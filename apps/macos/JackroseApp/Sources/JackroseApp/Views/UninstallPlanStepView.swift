import SwiftUI

struct UninstallPlanStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Uninstall Plan",
            bodyText: "Build a dry-run uninstall plan, helper requirements, and post-uninstall verification path."
        ) {
            Text("Dangerous actions stay staged rather than immediate.")
        }
    }
}
