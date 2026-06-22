import SwiftUI

struct RepairOverviewStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Repair Overview",
            bodyText: "Review failure classification, logs, runtime reports, rescue state, and export options from a single repair flow."
        ) {
            Text("Repair is framed as guided recovery rather than a list of terminal recipes.")
        }
    }
}
