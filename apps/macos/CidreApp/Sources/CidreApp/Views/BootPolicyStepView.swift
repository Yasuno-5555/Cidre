import SwiftUI

struct BootPolicyStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel

    var body: some View {
        WizardStepContainerView(
            title: "Boot Policy",
            bodyText: "Register Cidre in the Mac's Startup Options. This requires your macOS owner password to authorize the boot policy creation."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Owner credentials
                GroupBox("Owner Authentication") {
                    VStack(alignment: .leading, spacing: 8) {
                        if wizardVM.ownerCredentials != nil {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.green)
                                Text("Owner credentials provided for bless/bputil")
                                    .font(.callout)
                            }
                        } else {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .foregroundColor(.orange)
                                Text("Owner credentials required. Go back to Privileged Preparation to enter them.")
                                    .font(.callout)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Boot policy status
                if let result = bootPolicyVM.lastResult {
                    GroupBox("Boot Policy Result") {
                        VStack(alignment: .leading, spacing: 8) {
                            StatusRow(
                                label: "Status",
                                value: result["status"] as? String ?? "unknown"
                            )
                            if let summary = result["summary"] as? String {
                                Text(summary)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if let vgUUID = result["volume_group_uuid"] as? String, !vgUUID.isEmpty {
                                StatusRow(label: "Volume Group UUID", value: vgUUID)
                            }
                            if let stepsCompleted = result["steps_completed"] as? String {
                                StatusRow(label: "Steps completed", value: stepsCompleted)
                            }
                            if let stepsFailed = result["steps_failed"] as? String {
                                StatusRow(label: "Steps failed", value: stepsFailed)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Reduced Security guidance
                if case .manualRecoveryRequired = bootPolicyVM.reducedSecurityState {
                    GroupBox("Reduced Security Required") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.orange)
                                Text("LocalPolicy creation was deferred.")
                                    .font(.callout)
                            }
                            Text("bputil -g only works when booted into the target Volume Group. To set Reduced Security for Cidre, restart into macOS Recovery (hold power button at boot), open Startup Security Utility, select Cidre, and set Security Policy to Reduced Security.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                } else if case .reducedSecurity = bootPolicyVM.securityMode {
                    GroupBox("Security Mode") {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(.green)
                            Text("Reduced Security is configured. Cidre should be bootable from Startup Options.")
                                .font(.callout)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }

    private var bootPolicyVM: BootPolicyViewModel {
        wizardVM.bootPolicyVM
    }
}

// MARK: - Status Row

fileprivate struct StatusRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
    }
}
