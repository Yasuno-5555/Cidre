import SwiftUI

class ReportViewModel: ObservableObject {
    @Published var availableArtifacts: [ArtifactPath] = []
    @Published var selectedReportContent: String = ""
    
    func loadArtifacts() {
        // Mock default artifacts paths
        availableArtifacts = [
            ArtifactPath(role: "install-report", path: ".local/state/jackrose/install/current/install-report.md", type: "markdown", exists: true),
            ArtifactPath(role: "uninstall-report", path: ".local/state/jackrose/uninstall/current/uninstall-report.md", type: "markdown", exists: true)
        ]
    }
    
    func loadReportContent(_ artifact: ArtifactPath) {
        selectedReportContent = ReportLoader.shared.loadReport(atPath: artifact.path)
    }
}
