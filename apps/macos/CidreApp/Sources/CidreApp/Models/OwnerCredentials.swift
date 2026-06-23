import Foundation

/// Owner authentication credentials for bless/bputil operations.
/// These are held only in memory and never persisted to disk.
struct OwnerCredentials: Codable {
    let username: String
    let password: String
}
