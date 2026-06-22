import SwiftUI

struct SafetyStatusView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        let policy = SafeCommandPolicy.shared.getPolicy()
        
        VStack(alignment: .leading, spacing: 16) {
            Text("App Safety Status")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: policy.allowMockCommands ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(policy.allowMockCommands ? .green : .red)
                    Text("Mock command execution: ALLOWED")
                }
                
                HStack {
                    Image(systemName: policy.allowReadOnlyCommands ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(policy.allowReadOnlyCommands ? .green : .red)
                    Text("Read-only command execution: ALLOWED")
                }
                
                HStack {
                    Image(systemName: policy.allowDestructiveCommands ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(policy.allowDestructiveCommands ? .green : .red)
                    Text("Destructive command execution: BLOCKED")
                }
                
                HStack {
                    Image(systemName: policy.allowRootCommands ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(policy.allowRootCommands ? .green : .red)
                    Text("Commands requiring sudo/root: BLOCKED")
                }
            }
            .padding()
            .background(Color(.windowBackgroundColor))
            .cornerRadius(8)
            
            Text("Blocked Reasons")
                .font(.headline)
            
            ForEach(policy.blockedReasons, id: \.self) { reason in
                Text("• \(reason)")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
