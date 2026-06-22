import SwiftUI

struct ContentView: View {
    @StateObject var appVM = AppViewModel()
    @State private var selection: String? = "setup-wizard"
    
    var body: some View {
        NavigationView {
            SidebarView(selection: $selection)

            Group {
                switch selection {
                case "setup-wizard":
                    SetupWizardRootView()
                case "uninstall-wizard":
                    UninstallWizardRootView()
                case "repair-wizard":
                    RepairWizardRootView()
                case "dashboard":
                    LiveDashboardView()
                case "install":
                    ActionRunnerView(categoryFilter: "install")
                case "uninstall":
                    ActionRunnerView(categoryFilter: "uninstall")
                case "repair":
                    ActionRunnerView(categoryFilter: "repair")
                case "reports":
                    ReportsView()
                case "logs":
                    ExecutionLogView()
                case "settings":
                    SettingsView()
                default:
                    SetupWizardRootView()
                }
            }
        }
        .environmentObject(appVM)
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            selection = appVM.launchSelection
        }
    }
}
