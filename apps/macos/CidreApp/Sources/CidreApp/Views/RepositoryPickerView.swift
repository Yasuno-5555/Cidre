import SwiftUI

struct RepositoryPickerView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var settingsVM = RepositorySettingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cidre Repository Location")
                .font(.headline)
            
            HStack {
                TextField("Enter absolute path to Cidre repo", text: $settingsVM.pathInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Validate") {
                    settingsVM.validate()
                }
            }
            
            if let status = settingsVM.status {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: status.valid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(status.valid ? .green : .red)
                        Text(status.valid ? "Valid Cidre repository path" : "Invalid Cidre repository path")
                            .fontWeight(.semibold)
                    }
                    
                    if !status.valid {
                        ForEach(status.errors, id: \.self) { error in
                            Text("• \(error)")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color(.windowBackgroundColor))
                .cornerRadius(6)
            }
            
            Button("Save Settings") {
                settingsVM.save(appVM: appVM)
                appVM.loadManifest()
            }
            .disabled(settingsVM.status?.valid != true)
        }
        .padding()
        .onAppear {
            settingsVM.load(currentPath: appVM.repositoryPath)
        }
    }
}
