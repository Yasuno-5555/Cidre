import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Jackrose.app Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                RepositoryPickerView()
                
                Divider()
                
                Form {
                    Section(header: Text("Execution Mode")) {
                        Toggle("Enable Mock Mode", isOn: $appVM.mockMode)
                        
                        Picker("Execution Mode", selection: $appVM.executionMode) {
                            Text("Live Wizard").tag("live")
                            Text("Mock Commands").tag("mock")
                            Text("Read-only execution").tag("read-only")
                        }
                        .pickerStyle(RadioGroupPickerStyle())
                    }
                }
                
                Divider()
                
                SafetyStatusView()
            }
            .padding()
        }
    }
}
