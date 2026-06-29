import SwiftUI

class RepositorySettingsViewModel: ObservableObject {
    @Published var pathInput: String = ""
    @Published var status: RepositoryStatus?
    
    func load(currentPath: String) {
        pathInput = currentPath
        validate()
    }
    
    func validate() {
        status = RepositoryPathStore.shared.validatePath(pathInput)
    }
    
    func save(appVM: AppViewModel) {
        validate()
        if let status = status, status.valid {
            RepositoryPathStore.shared.savePath(pathInput)
            appVM.repositoryPath = pathInput
        }
    }
}
