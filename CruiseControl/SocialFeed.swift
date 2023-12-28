import MapKit
import SwiftUI

struct SocialFeed: View {
  @StateObject var viewModel = SocialFeedViewModel()
  var body: some View {

    List {
      ForEach(viewModel.drivePosts) { drive in
        VStack(alignment: .leading) {
          Text(drive.name)
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
            .shadow(radius: 1.0)
        }
      }
    }.listStyle(.plain).onAppear {
      Task {
        await viewModel.fetchDrivePosts()
      }
    }
  }
}

#Preview {
  SocialFeed()
}
