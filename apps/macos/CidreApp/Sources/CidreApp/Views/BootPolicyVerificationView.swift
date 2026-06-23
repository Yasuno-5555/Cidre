import SwiftUI

/// Displays post-install boot policy verification status.
/// Shows checkmarks for completed steps and guidance for remaining ones.
struct BootPolicyVerificationView: View {
    @ObservedObject var viewModel: BootPolicyViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Boot Policy Verification")
                .font(.headline)

            Divider()

            // Volume Group status
            VerificationRow(
                label: "Volume Group",
                status: viewModel.lastResult?["volume_group_uuid"] != nil ? .passed : .unknown
            )

            // m1n1 status
            switch viewModel.m1n1State {
            case .acquired(let version, _):
                VerificationRow(label: "m1n1 Bootloader", status: .passed, detail: "v\(version)")
            case .downloading:
                VerificationRow(label: "m1n1 Bootloader", status: .running, detail: "Downloading...")
            case .failed(let reason):
                VerificationRow(label: "m1n1 Bootloader", status: .failed, detail: reason)
            case .notAcquired:
                VerificationRow(label: "m1n1 Bootloader", status: .warning, detail: "Not acquired")
            }

            // Security Mode
            switch viewModel.securityMode {
            case .fullSecurity:
                VerificationRow(label: "LocalPolicy", status: .passed, detail: "Full Security")
            case .reducedSecurity:
                VerificationRow(label: "LocalPolicy", status: .passed, detail: "Reduced Security")
            case .permissiveSecurity:
                VerificationRow(label: "LocalPolicy", status: .passed, detail: "Permissive Security")
            case .unknown:
                VerificationRow(label: "LocalPolicy", status: .unknown)
            }

            // Reduced Security
            switch viewModel.reducedSecurityState {
            case .setViaBputil, .setViaRecovery:
                VerificationRow(label: "Reduced Security", status: .passed)
            case .manualRecoveryRequired:
                VerificationRow(label: "Reduced Security", status: .warning, detail: "Manual step required")
            case .unknown:
                VerificationRow(label: "Reduced Security", status: .unknown)
            }

            Divider()

            // Guidance for Reduced Security
            if viewModel.reducedSecurityState == .manualRecoveryRequired {
                ReducedSecurityGuidanceView()
            }

            // Summary
            if !viewModel.summaryText.isEmpty {
                Text(viewModel.summaryText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
    }
}

// MARK: - Verification Row

fileprivate enum VerifyStatus {
    case passed, failed, warning, running, unknown
}

fileprivate struct VerificationRow: View {
    let label: String
    let status: VerifyStatus
    var detail: String?

    var body: some View {
        HStack(spacing: 8) {
            statusIcon
            Text(label)
                .frame(width: 140, alignment: .leading)
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .passed:
            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        case .failed:
            Image(systemName: "xmark.circle.fill").foregroundColor(.red)
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
        case .running:
            ProgressView().scaleEffect(0.7)
        case .unknown:
            Image(systemName: "circle").foregroundColor(.secondary)
        }
    }
}
