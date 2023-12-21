import MapKit
import SwiftUI

struct AimlessDriveDetailView: View {
  var aimlessDrive: AimlessDrive
  var body: some View {
    Map {
      MapPolyline(coordinates: aimlessDrive.route).stroke(.blue, lineWidth: 10)
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
    }
  }
}
