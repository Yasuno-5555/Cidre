import SwiftUI

struct ReportDetailView: View {
    @EnvironmentObject var appVM: AppViewModel
    let reportPath: String
    @State private var content: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Report Detail")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Copy Path") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(reportPath, forType: .string)
                    }
                }
                
                Text(reportPath)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(MarkdownReportRenderer.shared.render(content))
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            let expandedPath = (reportPath as NSString).expandingTildeInPath
            let absoluteUrl = URL(fileURLWithPath: expandedPath)
            if let fileContent = try? String(contentsOf: absoluteUrl, encoding: .utf8) {
                content = fileContent
            } else {
                let relativeUrl = URL(fileURLWithPath: (appVM.repositoryPath as NSString).expandingTildeInPath).appendingPathComponent(reportPath)
                content = (try? String(contentsOf: relativeUrl, encoding: .utf8)) ?? "Could not load report content at \(reportPath)"
            }
        }
    }
}
