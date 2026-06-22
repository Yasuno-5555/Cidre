import SwiftUI

struct MarkdownReportView: View {
    let content: String
    let filename: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(filename)
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            ScrollView {
                Text(content)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
