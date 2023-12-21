import SwiftUI

struct AimlessDriveDetailView: View {
  var aimlessDrive: AimlessDrive
  var body: some View {
    Text(
      "Start Time: \(aimlessDrive.startTime, format: Date.FormatStyle(date: .numeric, time: .standard))"
    )
    Text(
      "End Time: \(aimlessDrive.endTime, format: Date.FormatStyle(date: .numeric, time: .standard))"
    )
    Text(
      "Start Location: \(aimlessDrive.startLocation.latitude.description), \(aimlessDrive.startLocation.longitude.description)"
    )
    Text(
      "End Location: \(aimlessDrive.endLocation.latitude.description), \(aimlessDrive.endLocation.longitude.description)"
    )
  }
}
