import Foundation

class RepositoryPathStore {
    static let shared = RepositoryPathStore()
    private let pathKey = "CidreRepositoryPath"
    
    private init() {}
    
    func loadPath() -> String {
        if let savedPath = UserDefaults.standard.string(forKey: pathKey) {
            return savedPath
        }
        return locateDefaultPath()
    }
    
    func savePath(_ path: String) {
        UserDefaults.standard.set(path, forKey: pathKey)
    }
    
    func resetPath() {
        UserDefaults.standard.removeObject(forKey: pathKey)
    }
    
    func validatePath(_ path: String) -> RepositoryStatus {
        let fm = FileManager.default
        let expandedPath = (path as NSString).expandingTildeInPath
        let pathUrl = URL(fileURLWithPath: expandedPath)
        
        let exists = fm.fileExists(atPath: pathUrl.path)
        let hasInterface = fm.fileExists(atPath: pathUrl.appendingPathComponent("interface").path)
        let hasScripts = fm.fileExists(atPath: pathUrl.appendingPathComponent("scripts").path)
        let hasManifest = fm.fileExists(atPath: pathUrl.appendingPathComponent("interface/command-manifest.json").path)
        let hasActions = fm.fileExists(atPath: pathUrl.appendingPathComponent("interface/app-actions.json").path)
        
        var warnings: [String] = []
        var errors: [String] = []
        
        if !exists {
            errors.append("Path does not exist")
        } else {
            if !hasInterface { errors.append("Missing interface directory") }
            if !hasScripts { errors.append("Missing scripts directory") }
            if !hasManifest { errors.append("Missing command-manifest.json") }
            if !hasActions { errors.append("Missing app-actions.json") }
        }
        
        let valid = exists && hasInterface && hasScripts && hasManifest && hasActions
        
        return RepositoryStatus(
            path: path,
            exists: exists,
            hasInterfaceDirectory: hasInterface,
            hasScriptsDirectory: hasScripts,
            hasCommandManifest: hasManifest,
            hasAppActions: hasActions,
            valid: valid,
            warnings: warnings,
            errors: errors
        )
    }
    
    private func locateDefaultPath() -> String {
        let fm = FileManager.default
        let homeDir = fm.homeDirectoryForCurrentUser
        
        let candidates = [
            homeDir.appendingPathComponent("Projects/Cidre").path,
            homeDir.appendingPathComponent("Cidre").path
        ]
        
        for candidate in candidates {
            if fm.fileExists(atPath: candidate) {
                return candidate
            }
        }
        
        return candidates[0]
    }
}
