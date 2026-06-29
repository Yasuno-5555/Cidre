import Foundation

class JackroseRepositoryLocator {
    static let shared = JackroseRepositoryLocator()
    
    private init() {}
    
    func locateRepository() -> String {
        // Fallback paths for macOS environment or prototyping
        let fallbackPaths = [
            "\(NSHomeDirectory())/Projects/Jackrose",
            "\(NSHomeDirectory())/Jackrose",
            "/home/yasuno/Projects/Jackrose" // Match user workspace path
        ]
        
        for path in fallbackPaths {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        return "/home/yasuno/Projects/Jackrose"
    }
}
