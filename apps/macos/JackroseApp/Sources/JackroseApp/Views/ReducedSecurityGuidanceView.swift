import SwiftUI

/// Clear, click-only guide for setting Reduced Security from macOS Recovery.
/// No terminal commands. No typing. Just clicks.
struct ReducedSecurityGuidanceView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("One-Time Setup: Enable Reduced Security")
                .font(.subheadline.bold())

            Text("Apple Silicon requires a one-time security approval to boot Jackrose. This uses Apple's signed Startup Security Utility — no terminal, no typing.")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                StepView(number: 1, icon: "power", title: "Shut down your Mac", detail: "Apple menu → Shut Down")
                StepView(number: 2, icon: "hand.tap", title: "Hold power button", detail: "Press and hold until \"Loading startup options\" appears")
                StepView(number: 3, icon: "gearshape", title: "Click Options", detail: "Select the gear icon labeled \"Options\"")
                StepView(number: 4, icon: "lock.shield", title: "Open Startup Security Utility", detail: "Menu bar → Utilities → Startup Security Utility")
                StepView(number: 5, icon: "square.grid.3x3", title: "Select Jackrose", detail: "Click the Jackrose volume in the list")
                StepView(number: 6, icon: "shield.lefthalf.filled", title: "Choose Reduced Security", detail: "Click the radio button for \"Reduced Security\"")
                StepView(number: 7, icon: "arrow.counterclockwise", title: "Restart back to macOS", detail: "Apple menu → Restart. Return to macOS (not Jackrose).")
                StepView(number: 8, icon: "apps.ipad", title: "Reopen Jackrose app", detail: "Launch Jackrose and click 'I have set Reduced Security' to continue the wizard.")
            }

            Divider()

            Text("After completing these steps and returning to Jackrose, the wizard will verify the security status and restore m1n1 as the active bootloader.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct StepView: View {
    let number: Int
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 24, height: 24)
                Text("\(number)")
                    .font(.caption2.bold())
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(title)
                        .font(.caption.bold())
                }
                Text(detail)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
