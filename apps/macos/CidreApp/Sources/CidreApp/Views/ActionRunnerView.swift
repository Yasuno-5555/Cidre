import SwiftUI

struct ActionRunnerView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var runnerVM = ActionRunnerViewModel()
    let categoryFilter: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(categoryFilter?.capitalized ?? "All") Actions")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List {
                ForEach(runnerVM.actions.filter { categoryFilter == nil || $0.category == categoryFilter }) { action in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(action.title)
                                .font(.headline)
                            Text(action.command)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if action.destructive {
                            Text("Blocked")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(4)
                        } else {
                            Button("Run") {
                                runnerVM.runAction(
                                    action,
                                    repositoryPath: appVM.repositoryPath,
                                    isMockMode: appVM.mockMode,
                                    manifest: appVM.commandManifest,
                                    logStore: appVM.logStore
                                )
                            }
                            .disabled(runnerVM.isExecuting)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(PlainListStyle())
            
            if let result = runnerVM.executionResult {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Command Result")
                        .font(.headline)
                    Text("Command: \(result.command) \(result.arguments.joined(separator: " "))")
                        .font(.system(.caption, design: .monospaced))
                    
                    HStack {
                        Text("Status: \(result.status.uppercased())")
                            .fontWeight(.bold)
                            .foregroundColor(result.status == "pass" ? .green : (result.status == "blocked" ? .red : .orange))
                        
                        if let exitCode = result.exitCode {
                            Text("Exit Code: \(exitCode)")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let parsed = result.parsedResult {
                        Text(parsed.summary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(4)
                    } else {
                        if let parseError = result.parseError {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("JSON parse failed")
                                    .fontWeight(.bold)
                                Text("Command:")
                                Text("\(result.command) \(result.arguments.joined(separator: " "))")
                                    .font(.system(.caption, design: .monospaced))
                                Text("Exit code: \(result.exitCode ?? -1)")
                                Text("Parser error: \(parseError)")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(4)
                        }
                        if !result.stdout.isEmpty {
                            Text(result.stdout)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.controlBackgroundColor))
                                .cornerRadius(4)
                        }
                        if !result.stderr.isEmpty {
                            Text(result.stderr)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.controlBackgroundColor))
                                .cornerRadius(4)
                        }
                    }
                }
                .padding()
                .background(Color(.windowBackgroundColor))
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            runnerVM.loadActions(repositoryPath: appVM.repositoryPath)
        }
    }
}
