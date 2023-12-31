import MapKit
import SwiftUI

struct RecordDrive: View {
  @Environment(\.modelContext) var modelContext
  @StateObject private var locationFetcher = LocationFetcher()
  @State var isTracking: Bool = false
  @State var startTime: Date = Date()

  @State private var showingConfirmationSheet = false

  @State private var driveName = ""
  @State private var driveDetails = ""

  @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

  let stroke = StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
  var body: some View {
    Map(position: $position) {
      if !locationFetcher.route.isEmpty {
        MapPolyline(coordinates: locationFetcher.route).stroke(.blue, style: stroke)
      }
      if let startingLocation = locationFetcher.route.first {
        Annotation("Start", coordinate: startingLocation, anchor: .bottom) {
          Image(systemName: "flag.fill")
            .padding(8)
            .foregroundStyle(.white)
            .background(Color.indigo)
            .cornerRadius(4)
        }
      }
      UserAnnotation()

    }.mapControls {
      MapUserLocationButton()
      MapCompass()
    }.safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Button {
          if !isTracking {
            withAnimation(.easeInOut) {
              position = .userLocation(fallback: .automatic)
            }
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
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .font(.title3)
          } else {
            Label("Stop recording", systemImage: "stop.fill")
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .font(.title3)
          }
        }.buttonStyle(.borderedProminent)
          .tint(isTracking ? .red : .green)
          .padding()
          .sheet(isPresented: $showingConfirmationSheet) {
            TextField("Name", text: $driveName).frame(
              width: 360
            ).textFieldStyle(.roundedBorder)
            TextField("Details", text: $driveDetails, axis: .vertical).frame(width: 360)
              .textFieldStyle(.roundedBorder).lineLimit(3, reservesSpace: true)
            Button {
              let aimlessDrive = AimlessDrive(
                name: driveName,
                details: driveDetails,
                startTime: startTime,
                endTime: Date(),
                route: locationFetcher.route,
                distanceTraveled: distanceTraveled(route: locationFetcher.route))
              modelContext.insert(aimlessDrive)
              showingConfirmationSheet = false
            } label: {
              Label("Save drive", systemImage: "checkmark.circle.fill")
            }.buttonStyle(.borderedProminent)
              .presentationDetents([.fraction(0.26)])
              .presentationDragIndicator(.visible)
              .tint(.green)
          }
        Spacer()
      }.background(.thinMaterial)
    }
  }
}

#Preview {
  RecordDrive()
}
