import SwiftUI

struct ContentView: View {
    @StateObject var appVM = AppViewModel()
    @State private var selection: String? = "dashboard"
    
    var body: some View {
        NavigationView {
            SidebarView(selection: $selection)
            
            LiveDashboardView()
        }
        .environmentObject(appVM)
        .frame(minWidth: 800, minHeight: 600)
    }
}
