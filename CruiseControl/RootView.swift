import SwiftUI

struct RootView: View {
  var body: some View {
    TabView {
      RecordDrive().tabItem {
        Label("Record", systemImage: "steeringwheel")
      }
      AimlessDriveList().tabItem {
        Label("Drives", systemImage: "map")
      }
    }
  }
}

#Preview {
  RootView()
}
