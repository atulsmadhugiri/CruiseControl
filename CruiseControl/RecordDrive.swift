import MapKit
import SwiftUI

struct RecordDrive: View {
  @Environment(\.modelContext) var modelContext
  @StateObject private var locationFetcher = LocationFetcher()
  @State var isTracking: Bool = false
  @State var startTime: Date = Date()

  @State private var showingConfirmationSheet = false

  @State private var driveName = ""

  var body: some View {
    Map {
      if !locationFetcher.route.isEmpty {
        MapPolyline(coordinates: locationFetcher.route).stroke(.blue, lineWidth: 10)
      }
      UserAnnotation()
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
            showingConfirmationSheet = true
          }
        } label: {
          if !isTracking {
            Label("Start recording", systemImage: "record.circle")
          } else {
            Label("Stop recording", systemImage: "stop.fill")
          }
        }.buttonStyle(.borderedProminent)
          .tint(isTracking ? .red : .green)
          .padding()
          .sheet(isPresented: $showingConfirmationSheet) {
            TextField("Name", text: $driveName).frame(
              width: 360
            ).textFieldStyle(.roundedBorder)
            Button {
              let aimlessDrive = AimlessDrive(
                name: driveName,
                startTime: startTime,
                endTime: Date(),
                route: locationFetcher.route)
              modelContext.insert(aimlessDrive)
              showingConfirmationSheet = false
            } label: {
              Label("Save drive", systemImage: "checkmark.circle.fill")
            }.buttonStyle(.borderedProminent)
              .presentationDetents([.fraction(0.20)])
              .presentationDragIndicator(.visible)
          }
        Spacer()
      }.background(.thinMaterial)
    }
  }
}

#Preview {
  RecordDrive()
}
