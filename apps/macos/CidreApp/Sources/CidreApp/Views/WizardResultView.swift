import SwiftUI

struct WizardResultView: View {
    let execution: CommandExecution?

    var body: some View {
        if let execution {
            VStack(alignment: .leading, spacing: 8) {
                Text("Latest Result")
                    .font(.headline)
                Text("Status: \(execution.status.uppercased())")
                    .fontWeight(.semibold)
                if let parsed = execution.parsedResult {
                    Text(parsed.summary)
                        .foregroundColor(.secondary)
                } else if !execution.stdout.isEmpty {
                    Text(execution.stdout)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.controlBackgroundColor))
            .cornerRadius(10)
        }
    }
}
