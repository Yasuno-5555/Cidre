import SwiftUI

struct BackupSafetyStepView: View {
    var body: some View {
        WizardStepContainerView(
            title: "Backup / Safety",
            bodyText: "Generate restore-safe guidance, preflight context, and review existing Cidre state before any guarded operation."
        ) {
            Text("Dangerous actions must be staged. The app prepares the safety context first.")
        }
    }
}
