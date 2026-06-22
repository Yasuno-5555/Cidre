import SwiftUI

struct PrivilegedHelperStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Privileged Preparation",
            bodyText: "Check helper bundle structure, installation readiness, and whether any guarded operation would require helper mediation."
        ) {
            Text("The app never treats privileged execution as a silent background detail.")
        }
    }
}
