import MapKit
import SwiftUI

struct RecordDrive: View {
  @StateObject private var locationFetcher = LocationFetcher()
  @State var isTracking: Bool = false

  var body: some View {
    Map {
      MapPolyline(coordinates: locationFetcher.route).stroke(.blue, lineWidth: 14)
    }.safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Button {
          if isTracking {
            locationFetcher.stopTracking()
            isTracking = false
          } else {
            locationFetcher.startTracking()
            isTracking = true
          }
        } label: {
          if isTracking {
            Label("Stop recording", systemImage: "stop.fill")
          } else {
            Label("Start recording", systemImage: "record.circle")
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
