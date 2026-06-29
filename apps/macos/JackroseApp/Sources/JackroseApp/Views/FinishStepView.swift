import SwiftUI

struct FinishStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @StateObject private var viewModel = FinishGateViewModel()

    var body: some View {
        WizardStepContainerView(
            title: "Finish",
            bodyText: "Write the setup report, keep the operation log, and summarize the next safe actions inside the app."
        ) {
            if viewModel.gateState?.status == "passed" {
                Text("Jackrose.app closes the loop with report generation rather than terminal instructions.")
            } else {
                FinishGateView(gateState: viewModel.gateState)
            }
        }
        .onAppear {
            viewModel.load(repositoryPath: appVM.repositoryPath)
        }
    }
}
