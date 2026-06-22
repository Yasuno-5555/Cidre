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
            }
            .padding()
        }
        .onAppear {
            dashboardVM.refresh(repositoryPath: appVM.repositoryPath)
        }
    }
}
