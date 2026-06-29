import SwiftUI

struct UninstallExportStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Export",
            bodyText: "State export and exit planning are required before uninstall can continue."
        ) {
            Text("This preserves recovery context before any guarded delete path is considered.")
        }
    }
}
