import SwiftUI

struct RecordDrive: View {
  @StateObject private var locationFetcher = LocationFetcher()

  var body: some View {
    Text("Record drive")
  }
}

#Preview {
  RecordDrive()
}
