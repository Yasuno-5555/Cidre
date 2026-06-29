import SwiftUI

struct UninstallWizardRootView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = UninstallWizardViewModel()

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WizardProgressView(stages: viewModel.stages, currentIndex: viewModel.currentIndex)
                .frame(width: 240)

            VStack(alignment: .leading, spacing: 16) {
                uninstallStepView
                if viewModel.stages[viewModel.currentIndex] == .uninstallConfirmation {
                    WizardConfirmationView(
                        prompt: "I understand this will remove Jackrose from this Mac.",
                        text: $viewModel.confirmationText
                    )
                }
                WizardResultView(execution: viewModel.lastExecution)
                HStack {
                    Button("Back") {
                        viewModel.goBack(repositoryPath: appVM.repositoryPath)
                    }
                    .disabled(viewModel.currentIndex == 0)

                    Button("Next") {
                        viewModel.advance(repositoryPath: appVM.repositoryPath)
                    }
                    .disabled(viewModel.currentIndex == viewModel.stages.count - 1)

                    Spacer()

                    if let operation = viewModel.operationForCurrentStage() {
                        WizardOperationButton(title: operation.title, running: viewModel.isRunning) {
                            viewModel.runCurrent(repositoryPath: appVM.repositoryPath, isMockMode: appVM.mockMode, logStore: appVM.logStore)
                        }
                        .frame(width: 260)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.load(repositoryPath: appVM.repositoryPath)
        }
    }

    @ViewBuilder
    private var uninstallStepView: some View {
        switch viewModel.stages[viewModel.currentIndex] {
        case .uninstallWelcome:
            UninstallWelcomeStepView()
        case .uninstallExport:
            UninstallExportStepView()
        case .uninstallDiskScan:
            UninstallDiskScanStepView()
        case .uninstallTargetReview:
            TargetReviewStepView()
        case .uninstallPlan:
            UninstallPlanStepView()
        case .uninstallConfirmation:
            UninstallConfirmationStepView()
        case .uninstallExecution:
            UninstallExecutionStepView()
        case .uninstallVerification:
            PostUninstallVerificationStepView()
        case .uninstallFinish:
            UninstallFinishStepView()
        default:
            UninstallWelcomeStepView()
        }
    }
}
