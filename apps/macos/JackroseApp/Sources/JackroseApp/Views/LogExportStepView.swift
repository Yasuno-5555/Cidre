import SwiftUI

struct LogExportStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Log Export",
            bodyText: "Collect runtime logs, install state, and app reports into a repair-safe bundle."
        ) {
            Text("This gives repair workflows an export path without Terminal.")
        }
    }
}
