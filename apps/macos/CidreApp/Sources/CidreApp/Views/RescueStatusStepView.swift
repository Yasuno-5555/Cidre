import SwiftUI

struct RescueStatusStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Rescue Status",
            bodyText: "Inspect rescue slot state, rescue planning artifacts, and current recovery guidance."
        ) {
            Text("Repair stays connected to rescue readiness.")
        }
    }
}
