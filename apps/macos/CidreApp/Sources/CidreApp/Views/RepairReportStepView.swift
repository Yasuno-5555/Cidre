import SwiftUI

struct RepairReportStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Repair Report",
            bodyText: "Write a repair summary, log bundle references, and the recommended next safe action."
        ) {
            Text("This closes the repair flow with evidence and guidance.")
        }
    }
}
