import SwiftUI

class ActionListViewModel: ObservableObject {
    @Published var actions: [AppAction] = []
    @Published var lastResult: CommandResult? = nil
    
    func loadActions(category: String) {
        self.actions = AppActionProvider.shared.getActions(category: category)
    }
    
    func runAction(_ action: AppAction, isMockMode: Bool) {
        self.lastResult = CommandRunner.shared.execute(action.command, isMockMode: isMockMode)
    }
}
