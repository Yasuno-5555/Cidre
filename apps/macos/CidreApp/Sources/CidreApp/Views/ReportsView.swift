import SwiftUI

struct ReportsView: View {
    @StateObject var vm = ReportViewModel()
    @State private var selectedArtifact: ArtifactPath?
    
    var body: some View {
        HStack(spacing: 0) {
            List(vm.availableArtifacts, selection: $selectedArtifact) { artifact in
                VStack(alignment: .leading) {
                    Text(artifact.role)
                        .font(.headline)
                    Text(artifact.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .tag(artifact)
            }
            .frame(width: 250)
            
            Divider()
            
            if let selected = selectedArtifact {
                ReportDetailView(reportPath: selected.path)
            } else {
                VStack {
                    Text("Select a report to preview")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            vm.loadArtifacts()
        }
    }
}
extension ArtifactPath: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(role)
    }
    
    static func == (lhs: ArtifactPath, rhs: ArtifactPath) -> Bool {
        return lhs.role == rhs.role
    }
}
