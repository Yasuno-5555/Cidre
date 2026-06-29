import SwiftUI

struct RepairView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var vm = ActionListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("System Repair & Rescue")
                .font(.largeTitle)
                .bold()
            
            Text("Read-only system diagnostic actions provider.")
                .foregroundColor(.secondary)
            
            List(vm.actions) { action in
                HStack {
                    VStack(alignment: .leading) {
                        Text(action.title)
                            .font(.headline)
                        Text(action.command)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("Run simulated") {
                        vm.runAction(action, isMockMode: appVM.mockMode)
                    }
                }
                .padding(.vertical, 4)
            }
            
            if let result = vm.lastResult {
                CommandResultView(result: result)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            vm.loadActions(category: "repair")
        }
    }
}
