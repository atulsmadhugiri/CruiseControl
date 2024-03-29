import MapKit
import SwiftUI

struct AimlessDriveListCell: View {
  var drive: AimlessDrive
  var body: some View {
    HStack {
      Map(interactionModes: []) {
        MapPolyline(coordinates: drive.route)
          .stroke(
            .blue,
            style: StrokeStyle(
              lineWidth: 6,
              lineCap: .round,
              lineJoin: .round
            )
          )
      }.frame(width: 120, height: 90)
        .allowsHitTesting(false)
        .cornerRadius(8.0)

      VStack(alignment: .leading) {
        Text(drive.name).font(.system(size: 20, design: .rounded).weight(.bold))
        Text(formattedDistanceTraveled(distance: drive.distanceTraveled))
        Text(drive.endTime.formatted(date: .abbreviated, time: .shortened))
          .font(.system(size: 12, design: .rounded))
        Spacer()
      }.padding()
    }
  }
}
