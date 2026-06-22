import SwiftUI

struct WizardProgressView: View {
    let stages: [WizardStage]
    let currentIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Progress")
                .font(.headline)
            ForEach(Array(stages.enumerated()), id: \.offset) { index, stage in
                HStack {
                    Circle()
                        .fill(index <= currentIndex ? Color.green : Color.secondary.opacity(0.3))
                        .frame(width: 10, height: 10)
                    Text(stage.title)
                        .foregroundColor(index == currentIndex ? .primary : .secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(10)
    }
}
