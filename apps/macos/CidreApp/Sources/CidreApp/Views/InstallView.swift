import SwiftUI

struct InstallView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var vm = ActionListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cidre Installer")
                .font(.largeTitle)
                .bold()
            
            Text("Guided installation actions provider from manifest.")
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
            vm.loadActions(category: "install")
        }
    }
}
