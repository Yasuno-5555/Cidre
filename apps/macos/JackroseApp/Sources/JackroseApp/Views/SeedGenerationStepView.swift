import SwiftUI

struct SeedGenerationStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Seed Generation",
            bodyText: "Generate the Jackrose seed, handoff context, checksums, and setup artifacts from the GUI."
        ) {
            Text("No command-copy instructions are shown here.")
        }
    }
}
