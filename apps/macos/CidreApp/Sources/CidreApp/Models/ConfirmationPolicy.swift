import Foundation

enum ConfirmationPolicy: String, Codable {
    case none
    case standard
    case destructive
    case explicitPhrase = "explicit-phrase"
}
