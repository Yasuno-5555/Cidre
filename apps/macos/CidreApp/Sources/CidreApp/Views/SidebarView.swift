import SwiftUI

struct SidebarView: View {
    @Binding var selection: String?
    
    var body: some View {
        List(selection: $selection) {
            NavigationLink(destination: LiveDashboardView(), tag: "dashboard", selection: $selection) {
                Label("Dashboard", systemImage: "speedometer")
            }
            NavigationLink(destination: ActionRunnerView(categoryFilter: "install"), tag: "install", selection: $selection) {
                Label("Install", systemImage: "square.and.arrow.down")
            }
            NavigationLink(destination: ActionRunnerView(categoryFilter: "uninstall"), tag: "uninstall", selection: $selection) {
                Label("Uninstall", systemImage: "trash")
            }
            NavigationLink(destination: ActionRunnerView(categoryFilter: "repair"), tag: "repair", selection: $selection) {
                Label("Repair", systemImage: "wrench.and.screwdriver")
            }
            NavigationLink(destination: ReportsView(), tag: "reports", selection: $selection) {
                Label("Reports", systemImage: "doc.text")
            }
            NavigationLink(destination: ExecutionLogView(), tag: "logs", selection: $selection) {
                Label("Logs", systemImage: "terminal")
            }
            NavigationLink(destination: SettingsView(), tag: "settings", selection: $selection) {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200)
    }
}
