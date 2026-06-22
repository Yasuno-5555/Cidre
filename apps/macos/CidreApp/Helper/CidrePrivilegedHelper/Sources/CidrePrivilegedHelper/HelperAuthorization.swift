import Foundation

enum HelperAuthorization {
    static func canExecute(_ request: HelperProtocol) -> Bool {
        guard request.dryRun else {
            guard let planID = request.planID, !planID.isEmpty else { return false }
            return request.confirmationToken == "CIDRE EXECUTE \(planID)"
        }
        return true
    }
}
