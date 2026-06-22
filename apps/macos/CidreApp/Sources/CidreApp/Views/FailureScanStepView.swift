import SwiftUI

struct FailureScanStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Failure Scan",
            bodyText: "Scan runtime reports, install logs, and recovery artifacts to classify the current problem."
        ) {
            Text("The app can keep the recovery context visible while you proceed.")
        }
    }
}
