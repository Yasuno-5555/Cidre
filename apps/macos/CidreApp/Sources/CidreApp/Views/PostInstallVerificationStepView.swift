import SwiftUI

struct PostInstallVerificationStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel

    var body: some View {
        WizardStepContainerView(
            title: "Post-install Verification",
            bodyText: "Verify setup state, reports, boot policy, and expected post-install checkpoints before the flow is marked complete."
        ) {
            VStack(spacing: 16) {
                Text("Verification stays explicit and visible.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                BootPolicyVerificationView(viewModel: wizardVM.bootPolicyVM)

                Divider()

                Text("If Reduced Security is not yet configured, follow the guidance above after restarting into macOS Recovery.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            if let lastResult = loadLastBootPolicyResult(repositoryPath: appVM.repositoryPath) {
                wizardVM.bootPolicyVM.updateFromResult(lastResult)
            }
        }
    }

    private func loadLastBootPolicyResult(repositoryPath: String) -> [String: Any]? {
        let stateDir = "\(repositoryPath)/.local/state/cidre/install/current"
        let resultPath = "\(stateDir)/last-result.json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resultPath)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }
}
