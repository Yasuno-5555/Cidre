import SwiftUI

struct UninstallDiskScanStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Disk Scan",
            bodyText: "Scan disk layout and identify Jackrose or Asahi candidate targets while preserving protected targets."
        ) {
            Text("Unknown targets remain visible and guarded.")
        }
    }
}
