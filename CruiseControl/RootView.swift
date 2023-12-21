import SwiftUI

struct RootView: View {
  var body: some View {
    TabView {
      RecordDrive().tabItem {
        Label("Record", systemImage: "steeringwheel")
      }
      ContentView().tabItem {
        Label("Drives", systemImage: "map")
      }
    }
  }
}

#Preview {
  RootView()
}
