import SwiftUI

struct UninstallExecutionStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Execution",
            bodyText: "Run guarded helper preparation checks and record what would be executed, what is blocked, and what still needs review."
        ) {
            Text("Unsupported delete operations remain blocked with reasons.")
        }
    }
}
