import SwiftUI

struct ManualBootGuideView: View {
    let guide: ManualBootGuide?
    let reducedSecurityNeeded: Bool

    init(guide: ManualBootGuide?, reducedSecurityNeeded: Bool = true) {
        self.guide = guide
        self.reducedSecurityNeeded = reducedSecurityNeeded
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Booting Jackrose")
                .font(.headline)

            // Step 1: First boot with Reduced Security setup
            FlowSection(
                title: "First Boot — One-Time Setup",
                steps: [
                    "Shut down your Mac",
                    "Hold power button until Startup Options appears",
                    "Click Options → Startup Security Utility",
                    "Select Jackrose → Reduced Security → Restart"
                ]
            )

            // Step 2: Boot Jackrose
            FlowSection(
                title: "Boot Jackrose",
                steps: [
                    "Hold power button at restart",
                    "Select Jackrose in Startup Options",
                    "Linux boots — auto-setup runs (first boot only)",
                    "Restart when prompted"
                ]
            )

            // Step 3: Done
            FlowSection(
                title: "Done",
                steps: [
                    "Hold power button → Jackrose → login",
                    "Jackrose desktop environment is ready"
                ]
            )

            // Reduced Security explicit guide
            if reducedSecurityNeeded {
                ReducedSecurityGuidanceView()
            }

            // Policy reminder
            Text("Your default startup disk (macOS) was not changed.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(10)
    }
}

fileprivate struct FlowSection: View {
    let title: String
    let steps: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.bold())

            ForEach(steps.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 6) {
                    Text("\(i + 1).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 14, alignment: .trailing)
                    Text(steps[i])
                        .font(.caption)
                }
            }
        }
    }
}
