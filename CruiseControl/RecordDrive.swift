import MapKit
import SwiftUI

struct RecordDrive: View {
  @Environment(\.modelContext) var modelContext
  @StateObject private var locationFetcher = LocationFetcher()
  @State var isTracking: Bool = false
  @State var startTime: Date = Date()

  var body: some View {
    Map {
      MapPolyline(coordinates: locationFetcher.route).stroke(.blue, lineWidth: 14)
    }.safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Button {
          if !isTracking {
            locationFetcher.startTracking()
            startTime = Date()
            isTracking = true
          } else {
            locationFetcher.stopTracking()
            isTracking = false
            let aimlessDrive = AimlessDrive(
              startTime: startTime, endTime: Date(), route: locationFetcher.route)
            modelContext.insert(aimlessDrive)
          }
        } label: {
          if !isTracking {
            Label("Start recording", systemImage: "record.circle")
          } else {
            Label("Stop recording", systemImage: "stop.fill")
          }
        }.buttonStyle(.borderedProminent).tint(isTracking ? .red : .green).padding()
        Spacer()
      }.background(.thinMaterial)
    }
  }
}

#Preview {
  RecordDrive()
}
