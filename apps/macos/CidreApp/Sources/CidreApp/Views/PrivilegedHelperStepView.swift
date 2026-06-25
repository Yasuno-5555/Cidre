import SwiftUI

struct PrivilegedHelperStepView: View {
    @EnvironmentObject var appVM: AppViewModel
    @ObservedObject var wizardVM: SetupWizardViewModel
    @ObservedObject var bootPolicyVM: BootPolicyViewModel

    var body: some View {
        WizardStepContainerView(
            title: "Privileged Preparation",
            bodyText: "Build the m1n1 bootloader and configure owner authentication for boot policy creation."
        ) {
            VStack(spacing: 16) {
                // Owner credentials (wired to wizard VM for script passing)
                OwnerCredentialInputView(
                    credentials: $wizardVM.ownerCredentials
                )

                Divider()

                // m1n1 build status
                m1n1StatusSection

                // Boot policy readiness
                bootPolicyReadinessSection
            }
        }
    }

    @ViewBuilder
    private var m1n1StatusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("m1n1 Bootloader")
                .font(.headline)

            switch bootPolicyVM.m1n1State {
            case .notAcquired:
                HStack {
                    Image(systemName: "circle").foregroundColor(.secondary)
                    Text("Not yet built").foregroundColor(.secondary)
                }
                Text("Click \"Build m1n1 bootloader from source\" below to compile the bootloader.")
                    .font(.caption).foregroundColor(.secondary)

            case .downloading:
                HStack {
                    ProgressView().scaleEffect(0.8)
                    Text("Building m1n1...")
                }

            case .acquired(let version, _):
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text("m1n1 \(version) ready")
                }

            case .failed(let reason):
                HStack {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                    Text("Build failed").foregroundColor(.red)
                }
                Text(reason).font(.caption).foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var bootPolicyReadinessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Boot Policy")
                .font(.headline)

            if wizardVM.ownerCredentials != nil {
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text("Owner authentication configured")
                }
            } else {
                HStack {
                    Image(systemName: "circle").foregroundColor(.secondary)
                    Text("Enter macOS credentials above to enable boot policy creation")
                        .foregroundColor(.secondary)
                }
            }

            if let target = wizardVM.installTarget {
                Text("Target: \(target)").font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
}
