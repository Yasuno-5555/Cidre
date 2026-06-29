import SwiftUI

struct BootChainStepView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel

    var body: some View {
        WizardStepContainerView(
            title: "Boot Chain",
            bodyText: "Deploy the boot chain (m1n1 bootloader + Linux kernel + initramfs) to the Jackrose System volume. This is required for the Mac to recognize Jackrose as a bootable OS."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Status overview
                GroupBox("Boot Chain Components") {
                    VStack(alignment: .leading, spacing: 8) {
                        StatusRow(
                            label: "m1n1 bootloader",
                            status: bootPolicyVM.m1n1Status
                        )
                        StatusRow(
                            label: "Linux kernel (Image)",
                            status: bootPolicyVM.kernelStatus
                        )
                        StatusRow(
                            label: "initramfs",
                            status: bootPolicyVM.initramfsStatus
                        )
                    }
                    .padding(.vertical, 4)
                }

                // Guidance
                if bootPolicyVM.allComponentsReady {
                    Text("All boot chain components are ready. Advance to the next step to create the boot policy.")
                        .font(.callout)
                        .foregroundColor(.green)
                } else {
                    Text("Run the operation below to stage the boot chain onto the Jackrose volume.")
                        .font(.callout)
                        .foregroundColor(.secondary)
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
    let status: ComponentStatus

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: status.icon)
                .foregroundColor(status.color)
                .font(.callout)
            Text(label)
                .font(.callout)
            Spacer()
            Text(status.label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
