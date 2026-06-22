import SwiftUI

struct SetupWizardRootView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = SetupWizardViewModel()

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WizardProgressView(stages: viewModel.stages, currentIndex: viewModel.currentIndex)
                .frame(width: 240)

            VStack(alignment: .leading, spacing: 16) {
                stepView
                if let blockedReason = viewModel.lastExecution?.parsedResult?.errors.first?.message,
                   viewModel.lastExecution?.status == "blocked" {
                    WizardBlockedView(reason: blockedReason)
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
    private var stepView: some View {
        switch viewModel.stages[viewModel.currentIndex] {
        case .welcome:
            SetupWelcomeStepView()
        case .compatibility:
            CompatibilityStepView()
        case .backupSafety:
            BackupSafetyStepView()
        case .diskPlanning:
            DiskPlanningStepView()
        case .installPlan:
            InstallPlanStepView()
        case .privilegedPreparation:
            PrivilegedHelperStepView()
        case .seedGeneration:
            SeedGenerationStepView()
        case .artifactPreparation:
            ArtifactPreparationStepView()
        case .installExecution:
            InstallExecutionStepView()
        case .postInstallVerification:
            PostInstallVerificationStepView()
        case .finish:
            FinishStepView()
        default:
            SetupWelcomeStepView()
        }
    }
}
