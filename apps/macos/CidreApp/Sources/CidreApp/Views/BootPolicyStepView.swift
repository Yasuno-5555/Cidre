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

                // Auto-run step2 guidance (Asahi-style)
                if bootPolicyVM.step2Ready {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.triangle.branch")
                                    .foregroundColor(.blue)
                                Text("Auto-Run Setup Ready")
                                    .font(.headline)
                            }

                            Text("Cidre will auto-complete boot policy setup on first boot. No manual SSU or Terminal needed.")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Divider()

                            VStack(alignment: .leading, spacing: 8) {
                                StepView(number: 1, icon: "power", title: "Shut down your Mac", detail: "Apple menu → Shut Down")
                                StepView(number: 2, icon: "hand.tap", title: "Hold power button", detail: "Hold until 'Loading startup options' appears")
                                StepView(number: 3, icon: "square.grid.3x3", title: "Select Cidre", detail: "Setup runs automatically and restarts")
                                StepView(number: 4, icon: "hand.tap", title: "Hold power button again", detail: "Select Cidre → Linux boots!")
                            }

                            Divider()

                            Text("First boot runs the step2 setup automatically (Asahi-style). The second boot loads Linux via m1n1.")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            if !bootPolicyVM.ssuCompleted {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        wizardVM.markSsuCompleted(repositoryPath: appVM.repositoryPath)
                                    }) {
                                        Label("Continue to Verification", systemImage: "checkmark.circle")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                    .controlSize(.large)
                                    Spacer()
                                }
                            } else {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    Text("Proceeding to verification...").font(.caption)
                                }
                            }
                        }
                        .padding(8)
                    }
                }

                // SSU guidance (fallback when bputil deferred and no step2 automation)
                if bootPolicyVM.ssuRequired && !bootPolicyVM.step2Ready {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("One More Step: Enable Reduced Security")
                                    .font(.headline)
                            }

                            Text("Your Mac uses Full Security, which requires Apple-signed bootloaders. To allow Cidre's unsigned bootloader (m1n1), you must enable Reduced Security from macOS Recovery.")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Divider()

                            // Embedded step-by-step guide
                            ReducedSecurityGuidanceView()

                            Divider()

                            if !bootPolicyVM.ssuCompleted {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        wizardVM.markSsuCompleted(repositoryPath: appVM.repositoryPath)
                                    }) {
                                        Label("I have set Reduced Security — Continue", systemImage: "checkmark.circle")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                    .controlSize(.large)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            } else {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("SSU completed. Proceeding to verification...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(8)
                    }
                }

                // Fallback: manual recovery guidance (if ssuRequired is false but security mode unknown)
                if !bootPolicyVM.ssuRequired, case .manualRecoveryRequired = bootPolicyVM.reducedSecurityState {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.orange)
                                Text("LocalPolicy creation was deferred.")
                                    .font(.callout)
                            }
                            Text("Restart into macOS Recovery (hold power button at boot), open Startup Security Utility, select Cidre, and set Security Policy to Reduced Security.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                    }
                }

                // Success: Reduced Security is configured
                if case .reducedSecurity = bootPolicyVM.securityMode {
                    GroupBox {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(.green)
                            Text("Reduced Security is configured. Cidre is ready to boot.")
                                .font(.callout)
                        }
                        .padding(8)
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
