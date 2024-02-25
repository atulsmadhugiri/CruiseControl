import MapKit
import SwiftUI

struct AimlessDriveDetailView: View {
  var aimlessDrive: AimlessDrive
  let stroke = StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)

  @State var publishInProgress: Bool = false

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
        Button {
          publishInProgress = true
          let drivePost: DrivePost = DrivePost(
            name: aimlessDrive.name,
            description: aimlessDrive.details,
            startTime: aimlessDrive.startTime,
            endTime: aimlessDrive.endTime,
            route: aimlessDrive.route,
            distanceTraveled: aimlessDrive.distanceTraveled)

          Task {
            await drivePost.saveDrivePost()
            publishInProgress = false
          }
        } label: {
          if publishInProgress {
            ProgressView().progressViewStyle(CircularProgressViewStyle()).frame(
              maxWidth: .infinity
            )
            .frame(height: 40)
            .tint(.gray)
          } else {
            Label("Post publicly", systemImage: "paperplane.fill")
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .font(.title3).foregroundStyle(.background)
          }
        }.buttonStyle(.borderedProminent)
          .tint(.primary)
          .padding()
      }.background(.thinMaterial)
    }
  }
}
