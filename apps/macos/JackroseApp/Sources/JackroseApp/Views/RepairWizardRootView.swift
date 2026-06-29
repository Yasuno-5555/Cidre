import SwiftUI

struct RepairWizardRootView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var viewModel = RepairWizardViewModel()

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WizardProgressView(stages: viewModel.stages, currentIndex: viewModel.currentIndex)
                .frame(width: 240)

            VStack(alignment: .leading, spacing: 16) {
                repairStepView
                WizardResultView(execution: viewModel.lastExecution)
                HStack {
                    Button("Next") {
                        viewModel.advance(repositoryPath: appVM.repositoryPath)
                    }
                    .disabled(viewModel.currentIndex == viewModel.stages.count - 1)

                    Spacer()

                    Button("Run Step") {
                        viewModel.runCurrent(repositoryPath: appVM.repositoryPath, isMockMode: appVM.mockMode, logStore: appVM.logStore)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.load(repositoryPath: appVM.repositoryPath)
        }
    }

    @ViewBuilder
    private var repairStepView: some View {
        switch viewModel.stages[viewModel.currentIndex] {
        case .repairOverview:
            RepairOverviewStepView()
        case .failureScan:
            FailureScanStepView()
        case .logExport:
            LogExportStepView()
        case .rescueStatus:
            RescueStatusStepView()
        case .recoveryAction:
            RecoveryActionStepView()
        case .repairReport:
            RepairReportStepView()
        default:
            RepairOverviewStepView()
        }
    }
}
