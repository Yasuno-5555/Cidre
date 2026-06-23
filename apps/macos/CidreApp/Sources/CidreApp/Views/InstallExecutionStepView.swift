import SwiftUI

struct InstallExecutionStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel
    @StateObject private var mutation = DiskMutationViewModel()

    var body: some View {
        WizardStepContainerView(
            title: "Install Execution",
            bodyText: "Run the prepared installer stage and monitor payload staging, verification results, and manual boot guidance."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Cidre installation payload is staged directly on the prepared APFS volume. The boot policy and startup disk configurations remain untouched.")
                    .font(.body)
                    .foregroundColor(.secondary)

                ControlledInstallDashboardView(lastResult: mutation.controlledInstallLastResult)

                if let plan = mutation.controlledInstallPlan {
                    InstallPlanPreviewView(plan: plan)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("No Active Install Plan")
                            .font(.headline)
                        Text("Please make sure you have successfully completed the Disk Plan stage.")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(8)
                }

                InstallPayloadProgressView(lastResult: mutation.controlledInstallLastResult)
                InstallVerificationView(lastResult: mutation.controlledInstallLastResult)
                NoDefaultBootPolicyView(lastResult: mutation.controlledInstallLastResult)

                // Boot policy status (from last boot-policy-create result)
                if let lastResult = mutation.controlledInstallLastResult,
                   let bootCheck = lastResult["boot_check"] as? [String: Any] {
                    BootPolicyStatusBanner(bootCheck: bootCheck)
                }

                if mutation.manualBootGuide != nil {
                    ManualBootGuideView(guide: mutation.manualBootGuide)
                }
            }
        }
        .onAppear {
            mutation.refreshKillSwitch(repositoryPath: appVM.repositoryPath)
            mutation.refreshSafetyStatus(repositoryPath: appVM.repositoryPath)
            // Propagate install target from plan to wizard VM
            if let plan = mutation.controlledInstallPlan {
                wizardVM.installTarget = plan.target
            }
        }
    }
}

// MARK: - Boot Policy Status Banner

fileprivate struct BootPolicyStatusBanner: View {
    let bootCheck: [String: Any]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: statusIcon)
                    .foregroundColor(statusColor)
                Text("Boot Policy Status")
                    .font(.headline)
            }

            if let summary = bootCheck["summary"] as? String {
                Text(summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let checks = bootCheck["checks"] as? [[String: Any]] {
                ForEach(checks.indices, id: \.self) { i in
                    if let id = checks[i]["id"] as? String,
                       let status = checks[i]["status"] as? String {
                        HStack(spacing: 4) {
                            Image(systemName: status == "passed" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(status == "passed" ? .green : .red)
                            Text(id)
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(statusColor.opacity(0.08))
        )
    }

    private var statusIcon: String {
        let s = bootCheck["status"] as? String ?? "unknown"
        return s == "passed" ? "checkmark.shield.fill" : "shield.slash"
    }

    private var statusColor: Color {
        let s = bootCheck["status"] as? String ?? "unknown"
        return s == "passed" ? .green : .orange
    }
}

