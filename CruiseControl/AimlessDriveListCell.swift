import MapKit
import SwiftUI

struct AimlessDriveListCell: View {
  var drive: AimlessDrive
  var body: some View {
    HStack {
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
