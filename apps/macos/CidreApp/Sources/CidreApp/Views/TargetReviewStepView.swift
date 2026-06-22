import SwiftUI

struct TargetReviewStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Target Review",
            bodyText: "Review candidate targets, protected targets, and unknown targets before building the uninstall plan."
        ) {
            Text("Only reviewed candidate targets may continue.")
        }
    }
}
