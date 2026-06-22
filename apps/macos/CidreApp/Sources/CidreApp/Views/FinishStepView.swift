import SwiftUI

struct FinishStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Finish",
            bodyText: "Write the setup report, keep the operation log, and summarize the next safe actions inside the app."
        ) {
            Text("Cidre.app closes the loop with report generation rather than terminal instructions.")
        }
    }
}
