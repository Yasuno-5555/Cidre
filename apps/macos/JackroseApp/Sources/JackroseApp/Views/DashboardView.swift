import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var vm = DashboardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Jackrose Dashboard")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 20) {
                DashboardCard(title: "App Readiness", value: vm.readinessStatus.uppercased(), color: vm.readinessStatus == "pass" ? .green : .red)
                DashboardCard(title: "Command Manifest", value: "\(vm.manifestCommandsCount) Tools", color: .blue)
                DashboardCard(title: "Active Stage", value: vm.activeStage, color: .orange)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("System Diagnostics")
                    .font(.title2)
                    .bold()
                Text("Last Checked: \(vm.checkedTime)")
                    .foregroundColor(.secondary)
                
                Button(action: {
                    vm.refresh(repoPath: appVM.repositoryPath, isMockMode: appVM.mockMode)
                }) {
                    Label("Run Diagnostic Scan", systemImage: "arrow.clockwise")
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .onAppear {
            vm.refresh(repoPath: appVM.repositoryPath, isMockMode: appVM.mockMode)
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(color)
        }
        .padding()
        .frame(width: 180, height: 100)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
