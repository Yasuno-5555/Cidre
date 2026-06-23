import SwiftUI

/// Shown after the user returns from Recovery/SSU.
/// Runs `boot-policy-verify` to confirm Reduced Security is enabled.
struct PostRecoveryRestoreStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel

    var body: some View {
        WizardStepContainerView(
            title: "Verify Boot Policy",
            bodyText: "Confirm that Reduced Security is enabled for Cidre. This step verifies the security configuration you set in Startup Security Utility."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Status overview
                GroupBox("Verification Status") {
                    VStack(alignment: .leading, spacing: 10) {
                        // Reduced Security check
                        HStack(spacing: 8) {
                            Image(systemName: bootPolicyVM.reducedSecurityVerified
                                  ? "checkmark.shield.fill"
                                  : (bootPolicyVM.ssuRequired ? "circle" : "checkmark.shield.fill"))
                                .foregroundColor(bootPolicyVM.reducedSecurityVerified ? .green : .secondary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(bootPolicyVM.reducedSecurityVerified
                                     ? "Reduced Security is enabled"
                                     : "Reduced Security not yet verified")
                                    .font(.callout)
                                if let mode = bootPolicyVM.lastResult?["security_mode"] as? String {
                                    Text("Security Mode: \(mode)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        // Security state summary
                        if case .reducedSecurity = bootPolicyVM.securityMode {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                Text("Cidre is ready to boot from Startup Options").font(.callout)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Summary from script
                if !bootPolicyVM.summaryText.isEmpty {
                    GroupBox("Result") {
                        Text(bootPolicyVM.summaryText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Guidance if still not verified
                if !bootPolicyVM.reducedSecurityVerified && !wizardVM.isRunning {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Reduced Security is not yet enabled for Cidre.")
                                    .font(.callout)
                            }
                            Text("Restart into macOS Recovery (hold power button at boot), open Startup Security Utility, select Cidre, and set Security Policy to Reduced Security. Then return here and run this verification again.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                    }
                }

                // Success state
                if bootPolicyVM.reducedSecurityVerified {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("All boot policy checks passed. Continue to Post-install Verification.")
                            .font(.callout)
                    }
                }
            }
        }
        .onAppear {
            // Load persisted SSU state
            if let bpState = BootPolicyStateStore.shared.load(repositoryPath: appVM.repositoryPath) {
                bootPolicyVM.ssuRequired = bpState.ssuRequired
                bootPolicyVM.ssuCompleted = bpState.ssuCompleted
            }
        }
    }

    private var bootPolicyVM: BootPolicyViewModel {
        wizardVM.bootPolicyVM
    }
}
