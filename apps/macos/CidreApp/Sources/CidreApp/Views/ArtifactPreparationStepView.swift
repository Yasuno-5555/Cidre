import SwiftUI

struct ArtifactPreparationStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Artifact Preparation",
            bodyText: "Prepare reports, handoff paths, restore guidance, and operation logs that the app can track directly."
        ) {
            Text("The app remains the source of truth for setup progress.")
        }
    }
}
