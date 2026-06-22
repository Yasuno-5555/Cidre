import Foundation

class CidreRepositoryLocator {
    static let shared = CidreRepositoryLocator()
    
    private init() {}
    
    func locateRepository() -> String {
        // Fallback paths for macOS environment or prototyping
        let fallbackPaths = [
            "\(NSHomeDirectory())/Projects/Cidre",
            "\(NSHomeDirectory())/Cidre",
            "/home/yasuno/Projects/Cidre" // Match user workspace path
        ]
        
        for path in fallbackPaths {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        return "/home/yasuno/Projects/Cidre"
    }
}
