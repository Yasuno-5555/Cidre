import SwiftUI

struct LiveDashboardView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var dashboardVM = LiveDashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Cidre Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cidre Repository Status")
                        .font(.headline)
                    Text("Selected Path: \(appVM.repositoryPath)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let status = dashboardVM.status {
                        HStack {
                            Image(systemName: status.valid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(status.valid ? .green : .red)
                            Text(status.valid ? "Interface layer: Ready" : "Interface layer: Broken")
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.windowBackgroundColor))
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Runtime Validation")
                        .font(.headline)
                    runtimeRow(title: "Build", status: dashboardVM.runtimeStatus(for: "swift-build"))
                    runtimeRow(title: "Launch", status: dashboardVM.runtimeStatus(for: "app-launch"))
                    runtimeRow(title: "Repository", status: statusFromRepository())
                    runtimeRow(title: "Safe Commands", status: dashboardVM.runtimeStatus(for: "safe-command-execution"))
                    runtimeRow(title: "Reports", status: dashboardVM.runtimeStatus(for: "report-preview"))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.windowBackgroundColor))
                .cornerRadius(8)
                
                HStack(spacing: 12) {
                    Button(action: {
                        dashboardVM.refresh(repositoryPath: appVM.repositoryPath)
                    }) {
                        Label("Validate Repository", systemImage: "arrow.clockwise")
                    }
                    
                    Button(action: {
                        dashboardVM.runAppReadiness(
                            repositoryPath: appVM.repositoryPath,
                            isMockMode: appVM.mockMode,
                            logStore: appVM.logStore
                        )
                    }) {
                        if dashboardVM.isRunningReadiness {
                            ProgressView().scaleEffect(0.5)
                        } else {
                            Label("Run Readiness Check", systemImage: "play.fill")
                        }
                    }
                    .disabled(dashboardVM.isRunningReadiness)
                    
                    Button(action: {
                        dashboardVM.runInterfaceDoctor(
                            repositoryPath: appVM.repositoryPath,
                            isMockMode: appVM.mockMode,
                            logStore: appVM.logStore
                        )
                    }) {
                        if dashboardVM.isRunningDoctor {
                            ProgressView().scaleEffect(0.5)
                        } else {
                            Label("Run Interface Doctor", systemImage: "waveform.path.ecg")
                        }
                    }
                    .disabled(dashboardVM.isRunningDoctor)

                    Button(action: {
                        dashboardVM.runReportIndex(
                            repositoryPath: appVM.repositoryPath,
                            isMockMode: appVM.mockMode,
                            logStore: appVM.logStore
                        )
                    }) {
                        if dashboardVM.isRunningReportIndex {
                            ProgressView().scaleEffect(0.5)
                        } else {
                            Label("Scan Reports", systemImage: "doc.text.magnifyingglass")
                        }
                    }
                    .disabled(dashboardVM.isRunningReportIndex)
                }
                
                if let readiness = dashboardVM.appReadinessResult {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("App Readiness Summary")
                            .font(.headline)
                        Text(readiness.summary)
                            .foregroundColor(.secondary)
                        Text("Status: \(readiness.status.uppercased())")
                            .fontWeight(.bold)
                            .foregroundColor(readiness.status == "pass" ? .green : .orange)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(8)
                }
                
                if let doctor = dashboardVM.doctorResult {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Interface Doctor Summary")
                            .font(.headline)
                        Text(doctor.summary)
                            .foregroundColor(.secondary)
                        Text("Status: \(doctor.status.uppercased())")
                            .fontWeight(.bold)
                            .foregroundColor(doctor.status == "pass" ? .green : .orange)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(8)
                }

                if let reportIndex = dashboardVM.reportIndexResult {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Report Index")
                            .font(.headline)
                        Text(reportIndex.parseError == nil ? "Report scan completed." : "JSON parse failed for report scan.")
                            .foregroundColor(.secondary)
                        Text("Status: \(reportIndex.status.uppercased())")
                            .fontWeight(.bold)
                            .foregroundColor(reportIndex.status == "pass" ? .green : .orange)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            dashboardVM.refresh(repositoryPath: appVM.repositoryPath)
        }
    }

    private func statusFromRepository() -> String {
        guard let status = dashboardVM.status else {
            return "pending"
        }
        return status.valid ? "passed" : "failed"
    }

    private func runtimeRow(title: String, status: String) -> some View {
        HStack {
            Text(title + ":")
            Spacer()
            Text(status.uppercased())
                .fontWeight(.semibold)
                .foregroundColor(color(for: status))
        }
    }

    private func color(for status: String) -> Color {
        switch status {
        case "passed", "pass":
            return .green
        case "warn":
            return .orange
        case "blocked", "failed", "fail":
            return .red
        default:
            return .secondary
        }
    }
}
