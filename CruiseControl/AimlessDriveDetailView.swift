import MapKit
import SwiftUI

struct AimlessDriveDetailView: View {
  var aimlessDrive: AimlessDrive
  let stroke = StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
  var body: some View {
    Map {
      MapPolyline(coordinates: aimlessDrive.route).stroke(.blue, style: stroke)
      if let startingLocation = aimlessDrive.route.first {
        Annotation("Start", coordinate: startingLocation, anchor: .bottom) {
          Image(systemName: "flag.fill")
            .padding(8)
            .foregroundStyle(.white)
            .background(Color.indigo)
            .cornerRadius(4)
        }
      }

      if let endingLocation = aimlessDrive.route.last {
        Annotation("End", coordinate: endingLocation, anchor: .bottom) {
          Image(systemName: "flag.checkered")
            .padding(8)
            .foregroundStyle(.white)
            .background(Color.orange)
            .cornerRadius(4)
        }
      }
    }.safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Button {
          let drivePost: DrivePost = DrivePost(
            name: aimlessDrive.name,
            description: aimlessDrive.details,
            startTime: aimlessDrive.startTime,
            endTime: aimlessDrive.endTime,
            route: aimlessDrive.route,
            distanceTraveled: aimlessDrive.distanceTraveled)

          Task {
            await drivePost.saveDrivePost()
          }
        } label: {
          Label("DEBUG: Publish to PublicDB", systemImage: "ladybug.fill")
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .font(.system(size: 16.0, weight: .bold, design: .monospaced))
        }.buttonStyle(.borderedProminent)
          .tint(.secondary)
          .padding()
        Spacer()
      }.background(.thinMaterial)
    }
  }
}
