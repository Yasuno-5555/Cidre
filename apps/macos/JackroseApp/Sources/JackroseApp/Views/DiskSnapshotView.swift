import SwiftUI

struct DiskSnapshotView: View {
    let availability: DiskSnapshotAvailability

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Latest Disk Snapshot")
                .font(.headline)
            Text("before: \(availability.beforeAvailable ? "available" : "missing")")
            Text("after: \(availability.afterAvailable ? "available" : "missing")")
        }
    }
}
