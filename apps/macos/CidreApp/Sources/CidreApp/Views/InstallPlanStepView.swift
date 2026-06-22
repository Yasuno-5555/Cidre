import SwiftUI

struct InstallPlanStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Install Plan",
            bodyText: "Review the linear setup stages, required artifacts, helper-dependent work, and external-stage tracking requirements."
        ) {
            Text("This keeps the setup flow intentional and reviewable.")
        }
    }
}
