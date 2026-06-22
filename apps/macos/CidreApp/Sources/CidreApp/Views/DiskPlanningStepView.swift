import SwiftUI

struct DiskPlanningStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @StateObject private var mutation = DiskMutationViewModel()

    var body: some View {
        WizardStepContainerView(
            title: "Disk Plan",
            bodyText: "Create a new APFS partition from an existing APFS container. The plan is validated before macOS requests administrator authentication."
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Keep a current backup, connect power, and close disk-intensive applications before continuing.")
                    .foregroundColor(.orange)

                HStack {
                    TextField("APFS container, e.g. disk3s2", text: $mutation.target)
                    TextField("Container after resize, e.g. 350G", text: $mutation.containerSize)
                }
                HStack {
                    TextField("New partition size, e.g. 80G", text: $mutation.partitionSize)
                    TextField("New volume name", text: $mutation.volumeName)
                }
                HStack {
                    Button("Create Plan") {
                        mutation.createPlan(repositoryPath: appVM.repositoryPath)
                    }
                    Button("Validate Preview") {
                        mutation.preview(repositoryPath: appVM.repositoryPath)
                    }
                    .disabled(!mutation.canPreview || mutation.isRunning)
                }

                if let phrase = mutation.requiredConfirmation {
                    WizardConfirmationView(prompt: "Type exactly: \(phrase)", text: $mutation.confirmation)
                    Button("Authenticate and Modify Disk", role: .destructive) {
                        mutation.execute(repositoryPath: appVM.repositoryPath)
                    }
                    .disabled(!mutation.canExecute || mutation.isRunning)
                }

                WizardResultView(execution: mutation.execution)
            }
        }
        .onAppear {
            mutation.detectStartupStore()
        }
    }
}
