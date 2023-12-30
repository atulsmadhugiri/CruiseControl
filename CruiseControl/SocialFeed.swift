import MapKit
import SwiftUI

struct SocialFeed: View {
  @StateObject var viewModel = SocialFeedViewModel()
  var body: some View {

    List {
      ForEach(viewModel.drivePosts) { drive in
        VStack(alignment: .leading) {

          HStack {
            Circle().fill(Color.blue).frame(width: 40)
            VStack(alignment: .leading) {
              Text("Atul Madhugiri")
              Text(drive.endTime.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: 12, design: .rounded))
            }
          }

          Text(drive.name).font(.title2)
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
          }.frame(height: 200)
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
