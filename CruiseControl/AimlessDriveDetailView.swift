import MapKit
import SwiftUI

struct AimlessDriveDetailView: View {
  var aimlessDrive: AimlessDrive
  var body: some View {
    Map {
      Annotation("Start", coordinate: aimlessDrive.startLocation, anchor: .bottom) {
        Image(systemName: "flag.fill")
          .padding(8)
          .foregroundStyle(.white)
          .background(Color.indigo)
          .cornerRadius(4)
      }

      Annotation("End", coordinate: aimlessDrive.endLocation, anchor: .bottom) {
        Image(systemName: "flag.checkered")
          .padding(8)
          .foregroundStyle(.white)
          .background(Color.orange)
          .cornerRadius(4)
      }
    }
  }
}
