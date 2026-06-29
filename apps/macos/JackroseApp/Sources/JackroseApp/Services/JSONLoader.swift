import Foundation

class JSONLoader {
    static let shared = JSONLoader()
    
    private init() {}
    
    func load<T: Decodable>(_ type: T.Type, fromFile file: String) -> T? {
        let repoPath = JackroseRepositoryLocator.shared.locateRepository()
        let fullPath = "\(repoPath)/\(file)"
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: fullPath)) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
    
    func loadFixture<T: Decodable>(_ type: T.Type, fixtureName: String) -> T? {
        let repoPath = JackroseRepositoryLocator.shared.locateRepository()
        let fullPath = "\(repoPath)/apps/macos/JackroseApp/Fixtures/\(fixtureName)"
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: fullPath)) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
