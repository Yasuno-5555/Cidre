import SwiftUI

struct ExecutionLogView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Execution Logs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button("Clear Logs") {
                    appVM.logStore.clear()
                }
            }
            
            if appVM.logStore.logs.isEmpty {
                VStack {
                    Spacer()
                    Text("No command logs recorded yet.")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(appVM.logStore.logs) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(entry.commandLine)
                                .font(.system(.headline, design: .monospaced))
                            Spacer()
                            Text(entry.status.uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(entry.status == "pass" ? .green : (entry.status == "blocked" ? .red : .orange))
                        }
                        
                        Text(entry.summary)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Exit Code: \(entry.exitCode)")
                            Spacer()
                            Text(String(format: "Duration: %.2f sec", entry.duration))
                            Spacer()
                            Text(entry.timestamp, style: .time)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
    }
}
