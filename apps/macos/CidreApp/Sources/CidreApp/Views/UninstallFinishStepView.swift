import SwiftUI

struct UninstallFinishStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Finish",
            bodyText: "Write the uninstall report and preserve the safety log for later review."
        ) {
            Text("Exported state and reports remain part of the final outcome.")
        }
    }
}
